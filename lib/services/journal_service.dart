import 'dart:convert';
import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';
import '../models/journal.dart';

class JournalService {
  //url de onde esta rodando o servidor
  static const String url = 'http://192.168.0.10:3000/';
  //resource do arquivo db.json (um endpoint do servidor)
  static const String resource = 'journals/';

//Utiliza os Interceptors para personalizar o log e o associa com o client da biblioteca http
//para acompanhar a requisição e resposta
  http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);

//pega a url e concatena com o resource journals (vindo do arquivo db.json)
  String getUrl() {
    return '$url$resource';
  }

//MÉTODO POST -> Registra um novo conteúdo json na key journal do db.json
  Future<bool> register(Journal journal) async {
    //Transforma o map do Journal em arquivo json
    String jsonJournal = json.encode(journal.toMap());
    //espera pela url com o headers e o body para retornar a resposta
    http.Response response = await client.post(Uri.parse(getUrl()),
        headers: {'Content-type': 'application/json'}, body: jsonJournal);
    //caso de certo, ou seja, o status code da resposta ser 201, retorna true
    if (response.statusCode == 201) {
      return true;
    } //caso ao contrário, retorna false
    return false;
  }
//MÉTODO GET -> Pega os dados do json e transforma em lista
  Future<List<Journal>> getAll() async {
    http.Response response = await client.get(Uri.parse(getUrl()));
    if (response.statusCode != 200) {
      throw Exception();
    }
    List<Journal> list = [];
    List<dynamic> listDynamic = json.decode(response.body);
    for (var jsonMap in listDynamic) {
      list.add(Journal.fromMap(jsonMap));
    }
    return list;
  }
}
