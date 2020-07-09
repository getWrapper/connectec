import 'package:http/http.dart' as http;
import 'dart:convert';

class TokenPushProvider{
  String _url = 'connectec-alpha.herokuapp.com';
  // String _url = '10.0.2.2:3000';

  Future<String> setTokenId(String token) async{
    final url = Uri.http(_url, 'token');
    final resp = await http.post(url,body:{"token":token});
    final decodeData = json.decode(resp.body);
    return decodeData['ok'].toString();
  }
   Future<String> actTokenId(String token) async{
    final url = Uri.http(_url, 'token');
    final resp = await http.put(url,body:{"token":token});
    final decodeData = json.decode(resp.body);
    return decodeData['ok'].toString();
  }
}