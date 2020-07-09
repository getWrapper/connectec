import 'dart:async';
class Validators{

final validarEmail=StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink){
      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern);
      if(regExp.hasMatch(email)){
        sink.add(email);
      }else{
        sink.addError('Email no valido');
      }
    });

  final validarPassword=StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink){
      if(password.length >= 5 ){
        sink.add(password);
      }else{
        sink.addError('Contraseña de 4 a 8 caracteres');
      }
    });

    final validaUser =StreamTransformer<String, String>.fromHandlers(
    handleData: (user, sink){
      if(user.length >= 5 && user.length <= 8){
        sink.add(user);
      }else{
        sink.addError('Usuario de 5 a 8 caracteres');
      }
    });

}