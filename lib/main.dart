import 'package:flutter/material.dart';
import 'models/journal.dart';
import 'screens/add_journal_screen/add_journal_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'services/journal_service.dart';

void main() {
  runApp(const MyApp());
   JournalService service = JournalService();
  //service.register(Journal.empty());
  service.getAll();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Journal',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      initialRoute: "home",
      routes: {
        "home": (context) => const HomeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == "add-journal") {
          Map<String,dynamic> map = settings.arguments as Map<String,dynamic>;
          final Journal journal = map["journal"] as Journal;
          final bool isEditing = map["is_editing"];
          return MaterialPageRoute(
            builder: (context) {
              return AddJournalScreen(
              journal: journal, 
              isEditing:isEditing);
            },
          );
        }
        return null;
      },
    );
  }
}
