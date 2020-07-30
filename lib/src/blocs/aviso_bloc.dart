import 'dart:async';
import 'package:rxdart/rxdart.dart';

class AvisoBloc{

  final _idController = BehaviorSubject<String>();
  final _titleController = BehaviorSubject<String>();
  final _descriptionController = BehaviorSubject<String>();
  final _imageController = BehaviorSubject<String>();
  final _haveImageController = BehaviorSubject<bool>();

  // Recuperar los datos del Stream
  Stream<String> get titleStream => _titleController.stream;
  Stream<String> get descriptionStream => _descriptionController.stream;
  Stream<String> get imageStream => _imageController.stream;
  Stream<bool> get haveImageStream => _haveImageController.stream;

  // Insertar valor a Stream
  Function(String) get changeTitle   => _titleController.sink.add;
  Function(String) get changeDescription => _descriptionController.sink.add;
  Function(String) get changeImage => _imageController.sink.add;
  Function(bool) get changeHaveImage => _haveImageController.sink.add;
  Function(String) get changeId => _idController.sink.add;
  // Obtener el último valor ingresado a los streams
  String get title => _titleController.value;
  String get description => _descriptionController.value;
  String get image => _imageController.value;
  bool get haveImage => _haveImageController.value;
  String get idAviso => _idController.value;



dispose(){
  _titleController?.close();
  _descriptionController?.close();
  _imageController?.close();
  _haveImageController?.close();
  _idController?.close();
}
}