import 'package:http/http.dart' as http;

class JournalService{
  static const String url = "http://172.24.0.1:3000/";
  static const String resource = "learnhttp/";

  String getUrl(){
    return "$url$resource";
  }
  register(String content){
    http.post(Uri.parse(getUrl()), body: {
      "content": content
    });
  }
}