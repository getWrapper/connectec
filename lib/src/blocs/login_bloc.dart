import 'dart:async';
import 'package:preferencia_usuario_app/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators{

  final _userController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Recuperar los datos del Stream
  Stream<String> get userStream => _userController.stream.transform(validaUser);
  Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword);

  Stream<bool> get formValidStream => Rx.combineLatest2(userStream, passwordStream, (u, p)=>true);

  // Insertar valor a Stream
  Function(String) get changeUser   => _userController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // Obtener el último valor ingresado a los streams

  String get user => _userController.value;
  String get password => _passwordController.value;



dispose(){
  _userController?.close();
  _passwordController?.close();
}
}