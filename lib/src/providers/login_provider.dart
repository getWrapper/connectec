
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:preferencia_usuario_app/src/models/usuarios_model.dart';

class LoginProvider{
  String _url = 'connectec-alpha.herokuapp.com';


  Future<Usuario> _procesarRespuesta(Uri url, body) async{
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