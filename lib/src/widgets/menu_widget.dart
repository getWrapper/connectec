import 'package:flutter/material.dart';
import 'package:preferencia_usuario_app/src/shared_prefs/preferencias_usuario.dart';
import 'package:preferencia_usuario_app/src/widgets/modal_dialog.dart';

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
        Container(child: Divider()),
        _crearItemSession(context),
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
          size: 30.0,
        ),
        title: Text('$titulo'),
        onTap: () {
          if (backButton == 0) {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, route);
          } else {
            Navigator.pushNamed(context, route);
          }
        });
  }

  Widget _crearItemSession(BuildContext context) {
    if (prefs.loggedIn == 0) {
      return _crearItem(
          Icons.exit_to_app, context, 'Iniciar Session', 'login-page', 0, 1);
    } else {
      return ListTile(
          leading: Icon(
            Icons.directions_run,
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
                image: AssetImage('assets/img/menu.jpg'), fit: BoxFit.cover)),
        // margin: EdgeInsets.only(bottom: 40.0),
        currentAccountPicture: CircleAvatar(
          backgroundImage: AssetImage('assets/img/tec.jpg'),
        ),
        accountName: new Container(
            child: Text(
          prefs.nombreUsuario,
          style: TextStyle(color: _accentColor, fontSize: 18.0),
        )),
        // accountEmail: new Container(
        //     child: Text(
        //   'jccalderon@stefanini.com',
        //   style: TextStyle(color: _accentColor),
        // )),
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
        _crearItem(Icons.record_voice_over, context, 'Nuevo Aviso',
            'aviso-nuevo', 0, 0),
      ];
    } else {
      return [
        _crearItem(Icons.pages, context, 'Avisos', 'news', 0, 0),
        _crearItem(Icons.insert_invitation, context, 'Materias', '', 1, 0),
      ];
    }
  }

  void _showDetails(context) {
    var alert = ModalDialog('Cerrar Sesión', '¿Desea cerrar su sesión?',
        'Cancelar', 'Cerrar sesión', () {
      prefs.loggedIn = 0;
      Navigator.pushReplacementNamed(context, 'news');
    });

    showDialog(context: context, builder: (context) => alert);
  }
}
