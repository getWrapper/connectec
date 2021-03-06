import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:preferencia_usuario_app/src/pages/avisos/aviso_nuevo.dart';
import 'package:preferencia_usuario_app/src/pages/avisos/carousel_page.dart';
import 'package:preferencia_usuario_app/src/pages/avisos/aviso_editar.dart';
import 'package:preferencia_usuario_app/src/pages/calificaciones/calificaciones_home.dart';
import 'package:preferencia_usuario_app/src/pages/calificaciones/cardex.dart';
import 'package:preferencia_usuario_app/src/pages/calificaciones/parciales.dart';
import 'package:preferencia_usuario_app/src/pages/home_page.dart';
import 'package:preferencia_usuario_app/src/pages/avisos/avisos_detalle_page.dart';
import 'package:preferencia_usuario_app/src/pages/avisos/avisos_page.dart';
import 'package:preferencia_usuario_app/src/pages/settings_page.dart';
import 'package:preferencia_usuario_app/src/providers/avisos_provider.dart';
import 'package:preferencia_usuario_app/src/providers/push_notifications_provider.dart';
import 'package:preferencia_usuario_app/src/routes/routes.dart';
import 'package:preferencia_usuario_app/src/shared_prefs/preferencias_usuario.dart';
import 'package:preferencia_usuario_app/src/pages/login/login_page.dart';
import 'package:preferencia_usuario_app/src/blocs/provider.dart';


void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = new PreferenciasUsuario();
    await prefs.initPrefs();
    runApp(MyApp());
}

 
class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AvisosProvider noticiasProvider = new AvisosProvider();
  final prefs = new PreferenciasUsuario();
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  final localPush = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInit;
  IOSInitializationSettings iosInit;
  InitializationSettings initSettings;

  @override
  void initState() {
    super.initState();
    initializing();
    final pushProvider =  PushNotificationsProvder();
    pushProvider.initNotifications();
    pushProvider.mensajes.listen((data) { 

      if(data['mode'] == 'onMessage'){
          _showNotifications(data['title'], data['body']);
        }else{
          //  navigatorKey.currentState.pushNamed(HomePage.routeName, arguments: 'comida');
          navigatorKey.currentState.pushNamed(NewsPage.routeName);
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    return Provider(child: _materialApp());
    
  }

  Widget _materialApp(){
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(255, 213, 79,1),
        // primaryColor: Colors.teal[400],
        accentColor: Color.fromRGBO(221, 44, 0, 1),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.cyan[900], fontSize: 16.0),
          // bodyText1: TextStyle(color: Colors.cyan[900], fontSize: 16.0),
          headline1: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18.0),
          headline3: TextStyle(color: Colors.black54, fontSize: 15.0),
          subtitle2: TextStyle(color: Colors.black38, fontSize: 13.0)

        )
        ,appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Color.fromRGBO(221, 44, 0, 1)),
          textTheme: TextTheme(headline6:  TextStyle(color: Color.fromRGBO(221, 44, 0, 1), fontSize: 18.0,  fontWeight: FontWeight.bold)),
        ),
        hoverColor: Colors.yellow[100],
        textSelectionColor:  Color.fromRGBO(255, 213, 79,1),
        textSelectionHandleColor: Color.fromRGBO(221, 44, 0, 1)

      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.pink
      ),
      debugShowCheckedModeBanner: false,
      title: 'ConnecTec',
      initialRoute: NoticiasPage.routeName,

      routes: getAplicationRoutes()
    );
  }

  void initializing()async{
     androidInit = AndroidInitializationSettings('app_icon');
     iosInit = IOSInitializationSettings(onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
     initSettings = InitializationSettings(androidInit, iosInit);
     await localPush.initialize(initSettings, onSelectNotification: _onSelectNotification);
  }

  void _showNotifications(String title, String body)async{
    await notification(title, body);
  }
  Future<void> notification(String title, String body) async{
    AndroidNotificationDetails androidNotificationDetails=AndroidNotificationDetails(
      'Channel ID',
      'Channel title',
      'Channel body',
      priority: Priority.High,
      importance: Importance.Max,
      ticker: 'test',
      color: Colors.red[700]);
    IOSNotificationDetails iosNotificationDetails=IOSNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await localPush.show(0, title, body, notificationDetails);
  }

  Future _onSelectNotification(String payload){
    if(payload != null){
    }
    // Aqui se puede agregar navigator
  }

  Future _onDidReceiveLocalNotification(int id, String title, String body, String payload)async{
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: (){print('OnPressed push');},
          child: Text('Ok'),)

    ],);

  }
}