import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:preferencia_usuario_app/src/models/noticias_model.dart';

class NoticiasProvider{
  // Local
  // String _url = '10.0.2.2:3000';
  //Heroku
  String _url = 'connectec-alpha.herokuapp.com';
  bool _cargando = false;
  int _noticiasPage = 0;
  int _totalPaginas = 1;
  List<Noticia> _noticias = new List();

    // Stream controller para cargar neuva inforamción de las peliculas populares
  StreamController<List<Noticia>> _noticiasStreamController = StreamController<List<Noticia>>.broadcast();

  // Enviar datos al stream
  Function(List<Noticia>) get noticiasSink => _noticiasStreamController.sink.add;
  // Escuchar datos
  Stream<List<Noticia>> get noticiasStream => _noticiasStreamController.stream;
  
  get cleanStream => _noticiasStreamController.stream.drain;

  void disposeStreams(){
    _noticiasStreamController?.close();
  }

  Future<List<Noticia>> _procesarRespuesta(Uri url) async{
  final resp = await http.get(url);
  final decodeData = json.decode(resp.body);
  _totalPaginas = decodeData['totalPaginas'];
  final noticias = new Noticias.fromJsonList(decodeData['noticias']);
  return noticias.items;
  }

  Future<List<Noticia>>  getNoticias() async{
  // noticiasSink(_noticias);
  if (_cargando || _totalPaginas ==_noticiasPage){
    return [];
  } else{
    _cargando = true;
  }
  _noticiasPage ++;
  // En local va http
  // final url = Uri.http(_url, '/noticia',{
    //En pro va https
  final url = Uri.https(_url, '/noticia',{
    'page'    : _noticiasPage.toString()
  });
 
 final resp = await _procesarRespuesta(url);
 _noticias.addAll(resp);
 noticiasSink(_noticias);
 _cargando = false;
 return resp;

}
Future<List<Noticia>>  buscarNoticia(String query) async{
  //En local va http
    // final url = Uri.http(_url, '/noticia/buscar/'+query, {});
    //En pro va https
  final url = Uri.https(_url, '/noticia/buscar/'+query, {});
  return await _procesarRespuesta(url);
}

Future<List<Noticia>>  getNoticiasInit() async{
  _noticiasPage = 0;
  return getNoticias();
}

// Eliminar un aviso
Future<AvisoDelete> deleteAviso(String id)async{
  final url = Uri.https(_url, '/noticia/'+id);
  final resp = await http.delete(url);
  final decodeData = json.decode(resp.body);
  final ok = decodeData['ok'];
  AvisoDelete avisoDelete = new AvisoDelete();
  avisoDelete.ok = ok;
  if(ok == true){
    avisoDelete.message = decodeData['message'];
  }else{
    avisoDelete.message = decodeData['err']['message'];
  }
  return avisoDelete;
}
  
  void dispose() {
    _noticiasStreamController.close();
  }
}