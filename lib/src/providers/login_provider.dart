
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:preferencia_usuario_app/src/models/usuarios_model.dart';
import 'package:preferencia_usuario_app/src/util/utils.dart';

class LoginProvider{
  String _url = Configuracion.url;


  Future<Usuario> _procesarRespuesta(Uri url, body) async{
    try{
  final resp = await http.post(url, body: body);
  final decodeData = json.decode(resp.body);
  Usuario usuario = new Usuario();
  if(decodeData['ok'] == false){
    usuario.ok = false;
    usuario.message = decodeData['err']['message'];
  }else{
    usuario = new Usuario.fromJson(decodeData['usuario']);
    usuario.ok = true;
    usuario.token = decodeData['token'];
  }
  return usuario;
    }on SocketException catch (_) {
     return null;
    }
  }

  Future<Usuario> getLogin(String nick, String pass)async{
  final url = Uri.https(_url, '/login');
  final body = {
    'nickname': nick,
    'password': pass
  };
  final resp = await _procesarRespuesta(url, body);
  return resp;
  }
}