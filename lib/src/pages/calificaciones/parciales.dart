import 'package:flutter/material.dart';
import 'package:preferencia_usuario_app/src/widgets/menu_widget.dart';

class ParcialesPage extends StatefulWidget {
  static final String routeName = 'parciales-page';
  @override
  _ParcialesPageState createState() => _ParcialesPageState();
}

class _ParcialesPageState extends State<ParcialesPage> {
  List<Item> _data = generateItems(8);
  List<MyItem> _items = <MyItem>[
    new MyItem(materia: '1N1 CALCULO DIFERENCIAL', body: 'body'),
    new MyItem(materia: '1N2 FUNDAMENTOS DE PROGRAMACION', body: 'body'),
    new MyItem(
        materia: '4N1 ANALISIS DE SEÑALES Y SISTEMAS DE COMUNICACION',
        body: 'body'),
    new MyItem(materia: '1N2 FUNDAMENTOS DE PROGRAMACION', body: 'body'),
    new MyItem(materia: '1N2 FUNDAMENTOS DE PROGRAMACION', body: 'body'),
    new MyItem(materia: '1N2 FUNDAMENTOS DE PROGRAMACION', body: 'body')
  ];


  @override
  Widget build(BuildContext context) {

    return Scaffold(
         body: ListView(
          children: [
            ListTile(
              title: Text('No Control: 10030165'),
              subtitle: Text('Nombre: JULIO CESAR SANCHEZ CALDERON'),
            ),
            ExpansionPanelList(
              animationDuration: Duration(milliseconds: 500),
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _items[index].isExpanded = !_items[index].isExpanded;
                });
              },
              children: _items.map((MyItem item) {
                return ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                          title: Text(item.materia,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.black54)),
                          trailing: Text('94', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0)));
                    },
                    isExpanded: item.isExpanded,
                    body: Container(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text('P1 ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0, color: Theme.of(context).accentColor)),
                                Expanded(child: Container()),
                                Text('P2 ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0, color: Theme.of(context).accentColor)),
                                Expanded(child: Container()),
                                Text('P3 ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0, color: Theme.of(context).accentColor)),
                                Expanded(child: Container()),
                                Text('P4 ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0, color: Theme.of(context).accentColor))
                              ],
                            ),
                            Divider(),
                            Row(
                              children: <Widget>[
                                Text('85 ', style: TextStyle(fontWeight: FontWeight.bold)),
                                Expanded(child: Container()),
                                Text('100 ', style: TextStyle(fontWeight: FontWeight.bold)),
                                Expanded(child: Container()),
                                Text('92 ', style: TextStyle(fontWeight: FontWeight.bold)),
                                Expanded(child: Container()),
                                Text('97 ', style: TextStyle(fontWeight: FontWeight.bold))
                              ],
                            )
                          ],
                        ),
                      ),
                    ));
              }).toList(),
            ),
          ],
        ));
  }

  // Widget _buildPanel() {
  //   return ExpansionPanelList.radio(
  //     initialOpenPanelValue: 1,
  //     animationDuration: Duration(milliseconds: 500),
  //     children: _data.map<ExpansionPanelRadio>((Item item) {
  //       return ExpansionPanelRadio(
  //           value: item.id,
  //           headerBuilder: (BuildContext context, bool isExpanded) {
  //             return ListTile(
  //               title: Text(item.headerValue),
  //             );
  //           },
  //           body: ListTile(
  //               title: Text(item.expandedValue),
  //               subtitle: Text('To delete this panel, tap the trash can icon'),
  //               trailing: Icon(Icons.delete),
  //               onTap: () {
  //                 setState(() {
  //                   _data.removeWhere((currentItem) => item == currentItem);
  //                 });
  //               }));
  //     }).toList(),
  //   );
  // }

// void _setAll(bool isExpanded) {
//     for (final data in _data) {
//       data.expandedValue = isExpanded ?? false;
//     }
//     setState(() {});
// }

}

List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
        id: index,
        headerValue: 'Panelss $index',
        expandedValue: 'This is item number $index',
        isExpanded: false);
  });
}

// stores ExpansionPanel state information
class Item {
  Item({this.id, this.expandedValue, this.headerValue, this.isExpanded});

  int id;
  String expandedValue;
  String headerValue;
  bool isExpanded;
}

class MyItem {
  MyItem({this.isExpanded: false, this.materia, this.body});

  bool isExpanded;
  final String materia;
  final String body;
}
