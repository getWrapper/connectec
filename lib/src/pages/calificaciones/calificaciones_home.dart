import 'package:flutter/material.dart';
import 'package:preferencia_usuario_app/src/pages/calificaciones/cardex.dart';
import 'package:preferencia_usuario_app/src/pages/calificaciones/parciales.dart';
import 'package:preferencia_usuario_app/src/widgets/menu_widget.dart';

class CalificacionesHomePage extends StatelessWidget {
  static final String routeName = 'calificaciones-page';


  @override
  Widget build(BuildContext context) {
    final pageView = TabBarView(
    children: <Widget>[
      ParcialesPage(),
      CardexPage()
    ],
  );

    return DefaultTabController(
      length: 2,
          child: Scaffold(
        drawer: MenuWidget(),
          appBar: AppBar(
            bottom: TabBar(tabs: [
              Tab(text: 'Parciales'),
              Tab(text: 'Cardex')
            ],),
            title: Text('Calificaciones'),
          
          ),
        body: pageView,
      ),
    );
  }
}