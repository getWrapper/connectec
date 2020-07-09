import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:preferencia_usuario_app/src/pages/calendar_page.dart';
import 'package:preferencia_usuario_app/src/pages/noticias_page.dart';
import 'package:preferencia_usuario_app/src/pages/tareas_page.dart';

class NewsPage extends StatefulWidget {

    static final String routeName = 'news';

  @override
  _NewsPageState createState() => _NewsPageState();
}
  TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    NoticiasPage(),
    TareasPage(),
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
        // bottomNavigationBar: BottomNavy(),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          showElevation: true,
          itemCornerRadius: 8.0,
          curve: Curves.easeInBack,
          onItemSelected: _onItemTapped, 
          iconSize: 25,
          items: [
            _crearItem('Noticias', Icons.new_releases, Theme.of(context).accentColor),
            _crearItem('Tareas', Icons.playlist_add_check, Theme.of(context).accentColor),
            _crearItem('Materias', Icons.insert_invitation, Theme.of(context).accentColor)
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
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text('¿Estás seguro?'),
                content: new Text('¿Quieres salir de la aplicación?'),
                actions: <Widget>[
                   // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            new FlatButton(
              child: new Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
                ],
              ),
        ) ??
        false;
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