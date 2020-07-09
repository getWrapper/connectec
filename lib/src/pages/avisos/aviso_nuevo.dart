import 'package:flutter/material.dart';

class AvisoNuevoPage extends StatefulWidget {
  const AvisoNuevoPage({Key key}) : super(key: key);
  static final String routeName = 'aviso-nuevo';

  @override
  _AvisoNuevoPageState createState() => _AvisoNuevoPageState();
}

class _AvisoNuevoPageState extends State<AvisoNuevoPage> {
  static var _keyValidationForm = GlobalKey<FormState>();
  TextEditingController _textEditTitle = TextEditingController();
  TextEditingController _textEditDescription = TextEditingController();
      bool switchOn = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('title'),
          actions: <Widget>[
            IconButton(icon: const Icon(Icons.save), onPressed: () {})
          ],
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          _getWidgetAvisoCard(),
        ])));
  }

  Widget _getWidgetAvisoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 10.0,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
              key: _keyValidationForm,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Text(
                      'Register',
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                  ),
                  _widgetTitle(),
                  _widgetDescription(),
                  _widgetToogleImg()
                ],
              )),
        ),
      ),
    );
  }

Widget _widgetTitle(){
  return Container(
                    child: TextFormField(
                      controller: _textEditTitle,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: _validateUserName,
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                          labelText: 'Titulo',
                          icon: Icon(Icons.receipt)),
                    ),
                  );
}
Widget _widgetDescription(){
  return Container(
                    child: TextFormField(
                      controller: _textEditDescription,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      // validator: _validateUserName,
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                          labelText: 'Descripción',
                          icon: Icon(Icons.description)
                          ),
                    ),
                  );
}

Widget _widgetToogleImg(){

  return Container(
child: Row(
  children: <Widget>[
  Text('¿Agregar una imagen?'),
   Switch(
              value: switchOn,
              onChanged: (value) {
              setState(() {
                switchOn = value;
                print(switchOn);
              });
            },
            activeTrackColor: Theme.of(context).hoverColor,
            activeColor: Theme.of(context).primaryColor,
            
            )
  ]),
  );
}
  String _validateUserName(String value) {
    return value.trim().isEmpty ? "Name can't be empty" : null;
  }
}
