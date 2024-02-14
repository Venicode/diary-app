import 'package:uuid/uuid.dart';

class Journal {
  String id;
  String content;
  DateTime createdAt;
  DateTime updatedAt;

  Journal({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

//Construtor vazio apenas para testar a aplicação e o registro no Journal
  Journal.empty()
      : id = const Uuid().v1(),
        content = "",
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

//Transforma o Map em um Json
  Journal.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        content = map["content"],
        createdAt = DateTime.parse(map["created_At"]),
        updatedAt = DateTime.parse(map["updated_At"]);

//Retorna os dados em formato de Map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "content": content,
      "created_At": createdAt.toString(),
      "updated_At": updatedAt.toString()
    };
  }

  @override
  String toString() {
    return "$content \ncreated_at: $createdAt\nupdated_at:$updatedAt";
  }
}