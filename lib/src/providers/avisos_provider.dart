import 'dart:async';
import 'dart:convert';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:path/path.dart';
import 'dart:io';

import 'package:preferencia_usuario_app/src/models/noticias_model.dart';
import 'package:preferencia_usuario_app/src/models/nuevo_aviso.dart';
import 'package:preferencia_usuario_app/src/models/usuarios_model.dart';
import 'package:preferencia_usuario_app/src/providers/connection_provider.dart';
import 'package:preferencia_usuario_app/src/providers/login_provider.dart';
import 'package:preferencia_usuario_app/src/shared_prefs/preferencias_usuario.dart';
import 'package:preferencia_usuario_app/src/util/utils.dart';

class AvisosProvider {
 
  bool _cargando = false;
  int _noticiasPage = 0;
  int _totalPaginas = 1;
  List<Noticia> _noticias = new List();
  bool fin = false;
  LoginProvider login = LoginProvider();
  PreferenciasUsuario prefs = PreferenciasUsuario();
  String _url = Configuracion.url;
  ConnectionProvider connectionProvider = new ConnectionProvider();


  // Stream controller para cargar neuva inforamción de las peliculas populares
  StreamController<List<Noticia>> _noticiasStreamController =
      StreamController<List<Noticia>>.broadcast();

  // Enviar datos al stream
  Function(List<Noticia>) get noticiasSink =>
      _noticiasStreamController.sink.add;
  // Escuchar datos
  Stream<List<Noticia>> get noticiasStream => _noticiasStreamController.stream;

  get cleanStream => _noticiasStreamController.stream.drain;

  void disposeStreams() {
    _noticiasStreamController?.close();
  }

  Future<List<Noticia>> _procesarRespuesta(Uri url) async {
    if(! await connectionProvider.checkConnection()){
      return null;
    }
    try {
      final resp = await http.get(url, headers: {"Content-Type" : "application/json"});
      final decodeData = json.decode(resp.body);
      _totalPaginas = decodeData['totalPaginas'];
      final noticias = new Noticias.fromJsonList(decodeData['noticias']);
      return noticias.items;
    } on SocketException catch (error) {
      print(error);
      return null;
    } on HttpException catch (_) {
      return null;
    }
  }

  Future<List<Noticia>> getNoticias() async {
    if (_cargando || fin) {
      return [];
    } else if (_totalPaginas == _noticiasPage) {
      final sinConn = Noticia();
      sinConn.id = '1';
      _noticias.add(sinConn);
      noticiasSink(_noticias);
      fin = true;
      return [];
    } else {
      _cargando = true;
    }
    _noticiasPage++;
    final url = Uri.https(_url, '/aviso', {'page': _noticiasPage.toString()});
    final resp = await _procesarRespuesta(url);
    if (resp != null) {
      _noticias.addAll(resp);
    } else {
      final sinConn = Noticia();
      sinConn.id = '0';
      _noticias.add(sinConn);
    }
    noticiasSink(_noticias);
    _cargando = false;
    return resp;
  }

  Future<List<Noticia>> buscarNoticia(String query) async {
    final url = Uri.https(_url, '/aviso/buscar/' + query, {});
    return await _procesarRespuesta(url);
  }

  Future<List<Noticia>> getNoticiasInit() async {
    fin = false;
    _noticiasPage = 0;
    return getNoticias();
  }

// Eliminar un aviso
  Future<AvisoDelete> deleteAviso(String id) async {
    Usuario usuario = await login.getLogin(prefs.nick, prefs.phrase);
    prefs.tokenLogin;
    Map<String, String> headers = {'Authorization': usuario.token};
    final url = Uri.https(_url, '/noticia/' + id);
    final resp = await http.delete(url, headers: headers);
    final decodeData = json.decode(resp.body);
    final ok = decodeData['ok'];
    AvisoDelete avisoDelete = new AvisoDelete();
    avisoDelete.ok = ok;
    if (ok == true) {
      avisoDelete.message = decodeData['message'];
    } else {
      avisoDelete.message = decodeData['err']['message'];
    }
    return avisoDelete;
  }

  Future<Noticia> crearAviso(NuevoAviso req) async {
    Usuario usuario = await login.getLogin(prefs.nick, prefs.phrase);
    prefs.tokenLogin = usuario.token;
    Map<String, String> headers = {'Authorization': prefs.tokenLogin};
    Noticia aviso = new Noticia();
    var notifica = '0';
    if (req.cargarImagen != true) {
      notifica = '1';
    }
    try {
      final url = Uri.https(_url, '/aviso');
      final body = {
        'titulo': req.titulo,
        'descripcion': req.descripcion,
        'area': '5ef612e9a5254100176652fb',
        'notifica': notifica
      };
      final resp = await http.post(url, body: body, headers: headers);
      final decodeData = json.decode(resp.body);
      if (decodeData['ok'] == true) {
        aviso = new Noticia.nuevoAviso(decodeData['noticia']);
      }
      return aviso;
    } on SocketException catch (_) {
      return null;
    } on HttpException catch (_){
      return null;
    }
  }

  Future<bool> cargarImg(List<File> images, String idAviso) async {
    Map<String, String> headers = {'Authorization': prefs.tokenLogin};
    bool carga = false;
    // string to uri
    var uri = Uri.https(_url, '/upload/noticia/' + idAviso);

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    for (var imageFile in images) {
      // open a bytestream
      var stream = new http.ByteStream(Stream.castFrom(imageFile.openRead()));
      // get file length
      var length = await imageFile.length();
      // multipart that takes file
      var multipartFile = new http.MultipartFile('archivo', stream, length,
          filename: basename(imageFile.path));
      // add file to multipart
      request.files.add(multipartFile);
    }
    request.headers.addAll(headers);
    // send
    var response = await request.send();
    if (response.statusCode == 200) {
      carga = true;
    }
    return carga;
  }

  Future<bool> cargarImgAsset(List<Asset> images, String idAviso) async {
    Map<String, String> headers = {'Authorization': prefs.tokenLogin, 'Content-Type' : 'application/json'};
    bool carga = false;
    // string to uri
    var uri = Uri.https(_url, '/upload/noticia/' + idAviso);

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    try {
      for (var imageFile in images) {
        var path =
            await FlutterAbsolutePath.getAbsolutePath(imageFile.identifier);
        request.files.add(await http.MultipartFile.fromPath('archivo', path,
            filename: imageFile.name));
      }
      Map<String, String> body = new Map(); 
      // body.
      // request.fiel = 
      request.headers.addAll(headers);
      // send
      var response = await request.send();
      if (response.statusCode == 200) {
        carga = true;
      }
    } catch (erro) {
      carga = false;
    }
    return carga;
  }

  Future<bool> actualizarAviso(Noticia req) async {
    Usuario usuario = await login.getLogin(prefs.nick, prefs.phrase);
    prefs.tokenLogin = usuario.token;
    Map<String, String> headers = {'Authorization': prefs.tokenLogin};
    bool codResp = false;
    try {
      final url = Uri.https(_url, '/aviso/' + req.id);
      final body = {
        'titulo': req.titulo,
        'descripcion': req.descripcion,
        'area': '5ef612e9a5254100176652fb',
      };
      if (req.img != null) {
        for (var file in req.img.images) {
           body.addAll({'img': file});
        }
      }
      final resp = await http.put(url, body: body, headers: headers);
      final decodeData = json.decode(resp.body);
      if (decodeData['ok'] == true) {
        codResp = true;
      }
      return codResp;
    } on SocketException catch (_) {
      return null;
    } on HttpException catch (_){
      return null;
    }
  }

   Future<bool> actualizarImgAviso(List<Asset> images, String idAviso, List<String> eliminar, List<String> existente) async {
    Map<String, String> headers = {'Authorization': prefs.tokenLogin, 'Content-Type' : 'application/json', 'Accept': 'application/json'};
    bool carga = false;
    // string to uri
    var uri = Uri.https(_url, '/upload/noticia/' + idAviso);

    // create multipart request
    var request = new http.MultipartRequest("PUT", uri);


    try {
      for (var imageFile in images) {
        var path =
            await FlutterAbsolutePath.getAbsolutePath(imageFile.identifier);
        request.files.add(await http.MultipartFile.fromPath('archivo', path,
            filename: imageFile.name));
      }
      if (eliminar.length > 0) {
      request.fields.addAll({'eliminar': json.encode(eliminar)});
        }
         if (existente.length > 0) {
      request.fields.addAll({'existente': json.encode(existente)});
        }
      request.headers.addAll(headers);
      // send
      var response = await request.send();
      if (response.statusCode == 200) {
        carga = true;
      }
    } catch (erro) {
      carga = false;
    }
    return carga;
  }
}
