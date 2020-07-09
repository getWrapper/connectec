import 'package:flutter/material.dart';
import 'package:preferencia_usuario_app/src/blocs/provider.dart';

class HomeAdminPage extends StatelessWidget {
static final String routeName = 'home-admin-page';

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Admin'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.power_settings_new), iconSize: 35.0, tooltip: 'Cerrar sesión',
          onPressed: (){},)
        ],
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
children: <Widget>[
  Text('Email: ${bloc.user}'),
  Divider(),
  Text('Pass: ${bloc.password}'),
],
        ),
    );
  }
}