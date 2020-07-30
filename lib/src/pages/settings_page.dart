import 'package:flutter/material.dart';
import 'package:preferencia_usuario_app/src/providers/push_notifications_provider.dart';
import 'package:preferencia_usuario_app/src/shared_prefs/preferencias_usuario.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);
  static final String routeName = 'settings-page';
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  PreferenciasUsuario prefs = PreferenciasUsuario();
  PushNotificationsProvder pushProvider = PushNotificationsProvder();
  bool _notiAvisos;
  @override
  void initState() {
    _notiAvisos = prefs.notAvisos;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color _primaryColor = Theme.of(context).primaryColor;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Configuraciones'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ..._notificaciones(_primaryColor, size),
          ..._cuenta(_primaryColor, size),
          ..._acerca(_primaryColor, size, context)
        ],
      ),
    );
  }

  List<Widget> _notificaciones(Color color, Size size) {
    return [
      Container(
        width: size.width,
        padding: const EdgeInsets.only(top: 20.0, left: 15.0, bottom: 10.0),
        child: Text(
          'Notificaciones',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.record_voice_over, color: color, size: 30.0),
              title: Text('Avisos'),
              trailing: Switch(
                value: _notiAvisos,
                onChanged: (value) {
                  setState(() {
                    prefs.notAvisos = value;
                    _notiAvisos = value;
                    pushProvider.confNotAvisos(value);

                  });
                },
              ),
            ),
            ListTile(
              enabled: false,
              leading: Icon(Icons.event_available, color: color, size: 30.0),
              title: Text('Eventos'),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
            )
          ],
        ),
      )
    ];
  }

  List<Widget> _cuenta(Color color, Size size) {
    return [
      Container(
        width: size.width,
        padding: const EdgeInsets.only(top: 20.0, left: 15.0, bottom: 10.0),
        child: Text(
          'Cuenta',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            ListTile(
              enabled: false,
              leading: Icon(Icons.lock_outline, color: color, size: 30.0),
              title: Text('Cambiar Contraseña'),
              trailing: Icon(Icons.keyboard_arrow_right),
            )
          ],
        ),
      )
    ];
  }

  List<Widget> _acerca(Color color, Size size, BuildContext context) {
    return [
      Container(
        width: size.width,
        padding: const EdgeInsets.only(top: 20.0, left: 15.0, bottom: 10.0),
        child: Text(
          'Acerca de',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            ListTile(
                leading: Icon(Icons.info_outline, color: color, size: 30.0),
                title: Text('ConnecTEC - Pre-Alfa'),
                onTap: () => _displayBottomSheet(context))
          ],
        ),
      )
    ];
  }

  void _displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft:Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        backgroundColor: Colors.white,
        builder: (ctx) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: SingleChildScrollView(
                          child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text('ConnecTEC',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 20.0)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    width: MediaQuery.of(context).size.width,
                      child: Column(children: <Widget>[
                        Text(
                    'ConnecTEC es una App creada con la finalidad de mantener a la comunidad estudiantil informada de forma oportuna y rápida de los avisos del plantel.',
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Text(
                    'A través de esta App también podrás consultar tus calificaciones en cualquier momento que lo desees.',
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  SizedBox(height:MediaQuery.of(context).size.height * 0.03),
                  Image.asset('assets/icon/itsch.jpg',
                        width: MediaQuery.of(context).size.height * 0.1),
                  SizedBox(height:MediaQuery.of(context).size.height * 0.03),
                  Text('ConnecTEC ha sido desarrollada por ISC. Julio Cesar Sanchez Calderon ',
                  style: Theme.of(context).textTheme.overline,
                  textAlign: TextAlign.justify)
                      ],))
                ],
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
