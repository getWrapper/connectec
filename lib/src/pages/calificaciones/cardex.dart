import 'package:flutter/material.dart';

class CardexPage extends StatefulWidget {
  static final String routeName = 'cardex-page';

  @override
  _CardexPageState createState() => _CardexPageState();
}

class _CardexPageState extends State<CardexPage> {
  List<CardexItem> _items = <CardexItem>[
    
    new CardexItem(materia: '1N1 CALCULO DIFERENCIAL', cdts: '5', calif: '94',acred: 'Ordinario', ordinario: AcreditacionItem(sem: '1',periodo: 'AGO-DIC', anio: '2019')),
    new CardexItem(materia: '1N2 FUNDAMENTOS DE PROGRAMACION', cdts: '4', calif: '97',acred: 'Ordinario'),
    new CardexItem(
        materia: '4N1 ANALISIS DE SEÑALES Y SISTEMAS DE COMUNICACION',
        cdts: '5', calif: '94',acred: 'Ordinario'),
    new CardexItem(materia: '1N2 FUNDAMENTOS DE PROGRAMACION', cdts: '5', calif: '100',acred: 'Ord. Complement', ordinario: AcreditacionItem(sem: '1',periodo: 'AGO-DIC', anio: '2019'), repeticion: AcreditacionItem(sem: '2',periodo: 'FEB-JUL', anio: '2020')),
    new CardexItem(materia: '1N2 FUNDAMENTOS DE PROGRAMACION', cdts: '4', calif: '92',acred: 'Especial', ordinario: AcreditacionItem(sem: '1',periodo: 'AGO-DIC', anio: '2019'), repeticion: AcreditacionItem(sem: '2',periodo: 'FEB-JUL', anio: '2020'),especial: AcreditacionItem(sem: '3',periodo: 'AGO-DIC', anio: '2020')),
    new CardexItem(materia: '1N2 FUNDAMENTOS DE PROGRAMACION', cdts: '4', calif: '86',acred: 'Ordinario')
  ];

     final styleText = TextStyle(fontSize: 15.0, color: Colors.black54);


  final margin = const EdgeInsets.only(bottom: 10.0, right: 10.0, left: 10.0);

  final backColor = Colors.lightGreen;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ListView(
      children: <Widget>[
        ExpansionTile(
            title: Text('No Control: 10030165'),
            subtitle: Text('Nombre: Julio Cesar Sanchez Calderon'),
            // backgroundColor: Theme.of(context).primaryColor,
            children: <Widget>[
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(width: double.infinity, child: Text('ING. SIST COMP'), padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0)),
                  Container(width: double.infinity, child:Text('Especialidad: INGENIERIA DE SOFTWARE'), padding: EdgeInsets.symmetric(horizontal: 16.0)),
                  
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                    Expanded(child: Container(child: Container(padding: EdgeInsets.only(right: 4.0), child: Column(
                      children: <Widget>[
                        Container(width: double.infinity, child:Text('Cdts. Reunidos: 209',style: styleText)),
                        Container(width: double.infinity, child:Text('Sem. Actual: 8', style: styleText)),
                        Container(width: double.infinity, child:Text('Estatus: VIGENTE', style: styleText))
                      ],
                    ),),)),
                    Expanded(child: Container(padding: EdgeInsets.only(left: 4.0) ,child: Container(child: Column(
                      children: <Widget>[
                        Container(width: double.infinity, child:Text('Cdts. Actuales: 34', style: styleText)),
                        Container(width: double.infinity, child:Text('Inscrito: NO', style: styleText)),
                        Container(child: Text(''),)
                      ],
                    ),),)),
                      ],
                    ),
                  )
                ],
              ),
              
            )
            ]),
        ExpansionPanelList(
          animationDuration: Duration(milliseconds: 500),
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _items[index].isExpanded = !_items[index].isExpanded;
            });
          },
          children: _items.map((CardexItem item) {
            return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                      title: Text(item.materia,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(fontSize: 12.0, color: Colors.black54)),
                      trailing: Text(item.calif,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12.0)));
                },
                isExpanded: item.isExpanded,
                body: _bodyCardex(item)
                );
          }).toList(),
        ),
      ],
    );
  }

 Widget _bodyCardex(CardexItem item){
    return Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  _headerSection('CDTS','CALIF','ACREDITACION'),
                  _contentSection(item.cdts,item.calif,item.acred),
                  Container(child: Text('ORDINARIO', style: TextStyle(color: Theme.of(context).accentColor),)),
                  _headerSection('SEM','PERIODO','AÑO'),
                  _contentSection('1','AGO-DIC','2019'),
                  Container(child: Text('REPETICION', style: TextStyle(color: Theme.of(context).accentColor),)),
                  _headerSection('SEM','PERIODO','AÑO'),
                  _contentSection('1','AGO-DIC','2019'),
                  Container(child: Text('ESPECIAL', style: TextStyle(color: Theme.of(context).accentColor),)),
                  _headerSection('SEM','PERIODO','AÑO'),
                  _contentSection('1','AGO-DIC','2019')
                ],
              ),
              
            );
  }

  Widget _headerSection(String header1,String header2,String header3){
    return Container(padding: EdgeInsets.only(top: 5.0, left: 16.0, right: 16.0), color: Theme.of(context).primaryColor, child: Row(
                    children: <Widget>[
                      Expanded(child: Container(child: Text(header1, textAlign: TextAlign.center))),
                      Expanded(child: Container(child: Text(header2, textAlign: TextAlign.center))),
                      Expanded(child: Container(child: Text(header3, textAlign: TextAlign.center)))
                    ],
                  ),);
  }

  Widget _contentSection(String content1, String content2, String content3){
    return Container(padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0, top: 5.0), color: Colors.grey[100], child: Row(
                    children: <Widget>[
                      Expanded(child: Container(child: Text(content1, textAlign: TextAlign.center))),
                      Expanded(child: Container(child: Text(content2, textAlign: TextAlign.center))),
                      Expanded(child: Container(child: Text(content3, textAlign: TextAlign.center)))
                    ],
                  ));
  }
}

class CardexItem {
  CardexItem({this.isExpanded: false, this.materia, this.cdts, this.calif, this.acred, this.ordinario, this.repeticion, this.especial});

  bool isExpanded;
  String materia;
  String cdts;
  String calif;
  String acred;
  AcreditacionItem ordinario;
  AcreditacionItem repeticion;
  AcreditacionItem especial;

}
class AcreditacionItem {
  AcreditacionItem({this.sem, this.periodo, this.anio});

  String sem;
  String periodo;
  String anio;
}
