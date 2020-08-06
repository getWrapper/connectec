import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:preferencia_usuario_app/src/util/utils.dart';

class TokenPushProvider{
  String _url = Configuracion.url;

  Future<String> setTokenId(String token) async{
    final url = Uri.http(_url, 'token');
    final resp = await http.post(url,body:{"token":token});
    final decodeData = json.decode(resp.body);
    return decodeData['ok'].toString();
  }
   Future<String> actTokenId(String token, String newToken) async{
    final url = Uri.http(_url, 'token');
    final resp = await http.put(url,body:{"token":token, "newToken":newToken});
    final decodeData = json.decode(resp.body);
    return decodeData['ok'].toString();
  }
}