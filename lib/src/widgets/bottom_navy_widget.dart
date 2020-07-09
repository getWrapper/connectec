import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

class BottomNavy extends StatefulWidget {


  @override
  _BottomNavyState createState() => _BottomNavyState();
}

class _BottomNavyState extends State<BottomNavy> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavyBar(
        selectedIndex: currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (index) => setState(() {
          currentIndex = index;
          // Navigator.pushReplacementNamed(context, 'settings');
        }),
        items: [
          _crearItem('Noticias', Icons.new_releases, 30.0, Colors.blue),
          _crearItem('Tareas', Icons.playlist_add_check, 30.0, Colors.green),
          _crearItem('Materias', Icons.insert_invitation, 30.0, Colors.red)
        ],
        );
  }


  BottomNavyBarItem _crearItem(String etiqueta, IconData icon, double iconSize, Color colorActive){
    return BottomNavyBarItem(
            icon: Icon(icon, size: iconSize),
            inactiveColor: Colors.orange,
            title: Text(etiqueta),
            activeColor: colorActive,
            textAlign: TextAlign.center
          );
  }
}