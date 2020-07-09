import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:preferencia_usuario_app/src/providers/token_push_provider.dart';
import 'dart:io';

import 'package:preferencia_usuario_app/src/shared_prefs/preferencias_usuario.dart';

class PushNotificationsProvder {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final prefs = new PreferenciasUsuario();
  TokenPushProvider tokenPushProvider = TokenPushProvider();
  final _mensajeStreamController = StreamController<Map>.broadcast();
  Stream<Map> get mensajes => _mensajeStreamController.stream;

  initNotifications() {
    _firebaseMessaging.requestNotificationPermissions();
      if(prefs.tokenFCMSaved == 0){
        _obtenerTokenFCM();
      }else{
       final now = new DateTime.now();
       final timeSaved = DateTime.parse(prefs.tokenFCMSavedTime);
       final diff = now.difference(timeSaved);
       final diasDif = diff.inDays;
       if(diasDif > 30){
         _actualizarTimeTokenFCM();
       }
      }
    _firebaseMessaging.configure(
      onMessage: (info) {
        print('====== On Message =====');
        print(info);

          String argumento = 'no-data';
        // if(Platform.isAndroid){
        //   argumento = info['data']['tipo'] ?? argumento;
        // }else{
        //   argumento = info['tipo'] ?? argumento;
        // }
        // Map<String,String> map = {'mode' : 'onMessage', 'title':argumento};
        // // _mensajeStreamController.sink.add(argumento);
        
        // // _mensajeStreamController.sink.add('onMessage');
        // _mensajeStreamController.sink.add(map);
        var title;
        var body;
        Map<String,String> map;
        if(Platform.isAndroid){
          title = info['notification']['title'] ?? argumento;
          body = info['notification']['body'] ?? argumento;
          map = {'mode' : 'onMessage', 'title':title, 'body':body};
        }else{
          argumento = ['tipo'] ?? argumento;
          map = {'mode' : 'onMessage', 'title':title, 'body':body};
        }
        // _mensajeStreamController.sink.add(argumento);
        _mensajeStreamController.sink.add(map);

      },
      onLaunch: (info) {
        print('====== On Launch =====');
        print(info);

        String argumento = 'no-data';
        if(Platform.isAndroid){
          argumento = info['data']['tipo'] ?? argumento;
        }else{
          argumento = ['tipo'] ?? argumento;
        }
        // _mensajeStreamController.sink.add(argumento);
        Map<String,String> map = {'mode' : 'onLaunch', 'args':argumento};
        _mensajeStreamController.sink.add(map);
      },
      onResume: (info) {
        print('====== On Resume =====');
        print(info);

        String argumento = 'no-data';
        if(Platform.isAndroid){
          argumento = info['data']['tipo'] ?? argumento;
        }else{
          argumento = ['tipo'] ?? argumento;
        }
        // _mensajeStreamController.sink.add(argumento);
        Map<String,String> map = {'mode' : 'onResume', 'title':argumento};
        _mensajeStreamController.sink.add(map);
      },
    );
  }

  dispose(){
    _mensajeStreamController?.close();
  }

  _obtenerTokenFCM(){
  _firebaseMessaging.getToken().then((token) async{
    final resp = await tokenPushProvider.setTokenId(token);
    if(resp == 'true'){
      prefs.tokenFCMSaved = 1;
      prefs.tokenFCM = token;
      prefs.tokenFCMSavedTime = new DateTime.now().toString();
    }else{
      prefs.tokenFCMSaved = 0;
    }
    });
  }
  _actualizarTimeTokenFCM()async{
 final resp = await tokenPushProvider.actTokenId(prefs.tokenFCM);
    if(resp == 'true'){
      prefs.tokenFCMSaved = 1;
      prefs.tokenFCMSavedTime = new DateTime.now().toString();
    }else{
      prefs.tokenFCMSaved = 0;
    }
  }
  
}
