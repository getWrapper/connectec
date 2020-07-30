import 'dart:io';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:preferencia_usuario_app/src/pages/calendar_page.dart';
import 'package:preferencia_usuario_app/src/pages/avisos/avisos_page.dart';
import 'package:preferencia_usuario_app/src/widgets/modal_dialog.dart';

class NewsPage extends StatefulWidget {

    static final String routeName = 'news';

  @override
  _NewsPageState createState() => _NewsPageState();
}
  TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    NoticiasPage(),
    CalendarPage(),
  ];

class _NewsPageState extends State<NewsPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
          child: Scaffold(
        body: SizedBox.expand(
          child: _widgetOptions.elementAt(_currentIndex)),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          showElevation: true,
          itemCornerRadius: 8.0,
          curve: Curves.easeInBack,
          onItemSelected: _onItemTapped, 
          iconSize: 25,
          items: [
            _crearItem('Avisos', Icons.record_voice_over, Theme.of(context).accentColor),
            _crearItem('Eventos', Icons.insert_invitation, Theme.of(context).accentColor)
          ],
          )
       ),
    );
  }

    BottomNavyBarItem _crearItem(String etiqueta, IconData icon, Color colorActive){
    return BottomNavyBarItem(
            icon: Icon(icon),
            inactiveColor: Theme.of(context).primaryColor,
            title: Text(etiqueta),
            activeColor: colorActive,
            textAlign: TextAlign.center
          );
  }

   void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _onBackPressed() {
   var alert = ModalDialog('¿Estás seguro?',
        '¿Quieres salir de la aplicación?', 'Cancelar', 'Salir', () {
          exit(0);
      // Navigator.of(context).pop(true);
    },null);
    return showDialog(context: context, builder: (context) => alert);
  }
   Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      padding: EdgeInsets.all(5.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF696969),
            offset: Offset(1.0, 6.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: new TextStyle(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
    return loginBtn;
  }
}