import 'package:preferencia_usuario_app/src/models/noticias_model.dart';

class AvisosResponse {

  List<Noticia> avisos;

  // 0 = OK
  // 1 = Error conexión
  // 2 = KO
  int codResp;

  String message;
}