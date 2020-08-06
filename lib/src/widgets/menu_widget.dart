import 'package:flutter/material.dart';
import 'package:preferencia_usuario_app/src/pages/avisos/avisos_page.dart';
import 'package:preferencia_usuario_app/src/pages/avisos/video.dart';
import 'package:preferencia_usuario_app/src/shared_prefs/preferencias_usuario.dart';
import 'package:preferencia_usuario_app/src/widgets/modal_dialog.dart';

// ignore: must_be_immutable
class MenuWidget extends StatelessWidget {

  Color _primaryColor;

  Color _accentColor;

  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    _primaryColor = Theme.of(context).primaryColor;
    _accentColor = Theme.of(context).accentColor;

    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        _validarHeaderSesion(),
        ..._crearItemsAdmin(context),
         _crearItem(Icons.assessment, context, 'Calificaciones', 'calificaciones-page', 0, 1),
        Container(child: Divider()),
        // _itemDarkMode(),
        _crearItem(Icons.settings, context, 'Configuración', 'settings-page', 0, 1),
        Container(child: Divider()),
        _crearItemSession(context),
        _crearItem(Icons.assignment, context, 'Video', Video.routeName, 0, 1),
      ]),
    );
  }

  Widget _crearItem(IconData icon, BuildContext context, String titulo,
      String route, int validaSesion, int backButton) {
    if (prefs.loggedIn == 0 && validaSesion == 1) return Container();

    return ListTile(
        leading: Icon(
          icon,
          color: _primaryColor,
          size: 30.0
        ),
        title: Text('$titulo'),
        onTap: () {
          Navigator.pop(context);
          if (backButton == 0) {
            Navigator.pushReplacementNamed(context, route);
          } else {
            Navigator.pushNamed(context, route);
          }
          
        });
  }

  Widget _crearItemSession(BuildContext context) {
    if (prefs.loggedIn == 0) {
      return _crearItem(
          Icons.power_settings_new, context, 'Iniciar Session', 'login-page', 0, 1);
    } else {
      return ListTile(
          leading: Icon(
            Icons.exit_to_app,
            color: _primaryColor,
            size: 30.0,
          ),
          title: Text('Cerrar Sesión'),
          onTap: () => _showDetails(context));
    }
  }

  Widget _validarHeaderSesion() {
    if (prefs.loggedIn == 1) {
      return UserAccountsDrawerHeader(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/img/tec.jpg'), fit: BoxFit.cover)),
        // margin: EdgeInsets.only(bottom: 40.0),
        // currentAccountPicture: CircleAvatar(
        //   backgroundImage: AssetImage('assets/img/tec.jpg'),
        // ),
        accountName: new Container(
            child: Text(
          prefs.nombreUsuario,
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        )),
        accountEmail: new Container(
            child: Text(
          prefs.nick,
          style: TextStyle(color: Colors.white),
        )),
      );
    } else {
      return DrawerHeader(
          child: Container(),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/img/menu.jpg'), fit: BoxFit.cover),
          ));
    }
  }

  List<Widget> _crearItemsAdmin(BuildContext context) {
    if (prefs.userRol == 'ADMIN_ROLE' && prefs.loggedIn == 1) {
      return [
        _crearItem(Icons.assignment, context, 'Avisos', NoticiasPage.routeName, 0, 0),
        _crearItem(Icons.announcement, context, 'Nuevo Aviso',
            'aviso-nuevo', 0, 0),
      ];
    } else {
      return [
        _crearItem(Icons.assignment, context, 'Avisos', NoticiasPage.routeName, 0, 0),
        _crearItem(Icons.insert_invitation, context, 'Materias', '', 1, 0),
      ];
    }
  }

  void _showDetails(context) {
    var alert = ModalDialog('Cerrar Sesión', '¿Desea cerrar su sesión?',
        'Cancelar', 'Cerrar sesión', () {
      prefs.loggedIn = 0;
      Navigator.pushReplacementNamed(context, 'news');
    },null);

    showDialog(context: context, builder: (context) => alert);
  }
}