import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/screens/commom/confirmation_dialog.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:uuid/uuid.dart';
import '../../../helpers/weekday.dart';
import '../../../models/journal.dart';
import '../../add_journal_screen/add_journal_screen.dart';

class JournalCard extends StatelessWidget {
  final Journal? journal;
  final DateTime showedDate;
  final Function refresh;
  const JournalCard({
    Key? key,
    this.journal,
    required this.showedDate,
    required this.refresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (journal != null) {
      return InkWell(
        onTap: () {
          callAddJournalScreen(context, journal: journal);
        },
        child: Container(
          height: 115,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black87,
            ),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    height: 75,
                    width: 75,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      border: Border(
                          right: BorderSide(color: Colors.black87),
                          bottom: BorderSide(color: Colors.black87)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      journal!.createdAt.day.toString(),
                      style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 38,
                    width: 75,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.black87),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text(WeekDay(journal!.createdAt).short),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    journal!.content,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    removeJournal(context);
                  },
                  icon: const Icon(Icons.delete))
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          callAddJournalScreen(context);
        },
        child: Container(
          height: 115,
          alignment: Alignment.center,
          child: Text(
            "${WeekDay(showedDate).short} - ${showedDate.day}",
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  callAddJournalScreen(BuildContext context, {Journal? journal}) {
    Journal internalJournal = Journal(
        id: const Uuid().v1(),
        content: "",
        createdAt: showedDate,
        updatedAt: showedDate);

    if (journal != null) {
      internalJournal = journal;
    }

    Map<String, dynamic> map = {
      'journal': internalJournal,
      'is_editing': journal != null
    };

    Navigator.pushNamed(
      context,
      'add-journal',
      arguments: map,
    ).then((value) {
      refresh();

      if (value == DisposeStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registro salvo com sucesso."),
          ),
        );
      } else if (value == DisposeStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Houve uma falha ao registar."),
          ),
        );
      }
    });
  }

  removeJournal(BuildContext context) {
    JournalService service = JournalService();
    if (journal != null) {
      showConfirmationDialog(context,
              content: "Deseja realmente deletar essa anotação?",
              affirmativeOption: "Remover")
          .then((value) {
        if (value != null) {
          if (value) {
            service.delete(journal!.id).then((value) {
              if (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Removido com sucesso!"),
                  ),
                );
                refresh();
              }
            });
          }
        }
      });
    }
  }
}
