import 'package:flutter/material.dart';
import 'package:preferencia_usuario_app/src/blocs/aviso_bloc.dart';
import 'package:preferencia_usuario_app/src/blocs/login_bloc.dart';

class Provider extends InheritedWidget{

  static Provider _instancia;

  factory Provider({Key key, Widget child}){
    if(_instancia == null){
      _instancia = new Provider._internal(key: key, child: child,);
    }
    return _instancia;
  }

  Provider._internal({Key key, Widget child}) : super(key:key, child: child);

  final loginBloc = LoginBloc();
  final avisoBloc = AvisoBloc();


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of (BuildContext context){
        return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }
  static AvisoBloc ofAviso (BuildContext context){
        return context.dependOnInheritedWidgetOfExactType<Provider>().avisoBloc;
  }
  
}