import 'dart:async';
import 'package:flutter/material.dart';
import 'package:preferencia_usuario_app/src/models/noticias_model.dart';
import 'package:preferencia_usuario_app/src/providers/noticias_provider.dart';
import 'package:preferencia_usuario_app/src/search/noticias_search_delegate.dart';
import 'package:preferencia_usuario_app/src/widgets/menu_widget.dart';

import 'noticias_detalle_page.dart';
import 'package:timeago/timeago.dart' as timeago;

class NoticiasPage extends StatefulWidget {
  static final String routeName = 'noticias-page';

  @override
  _NoticiasPageState createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage> {
  NoticiasProvider noticiasProvider = NoticiasProvider();
  PageController _pageController = PageController(viewportFraction: 0.3);
  var refreshkey = GlobalKey<RefreshIndicatorState>();

  Future<Null> _handleRefresh() async {
    setState(() {
      noticiasProvider.dispose();
      noticiasProvider = new NoticiasProvider();
      noticiasProvider.getNoticiasInit();
    });
    return null;
  }

  @override
  void initState() {
    super.initState();
    noticiasProvider.getNoticias();
  }

  @override
  Widget build(BuildContext context) {
    _pageController.addListener(() {
      if (_pageController.position.pixels >=
              _pageController.position.maxScrollExtent - 200 &&
          (_pageController.position.maxScrollExtent - 200 > 0)) {
        noticiasProvider.getNoticias();
      }
    });

    return Scaffold(
      drawer: MenuWidget(),
      appBar: AppBar(
        elevation: 1.0,
        title: Text('Avisos'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: NoticiasSearch());
            },
          ),
        ],
      ),
      body: _generarStreamBuilder(),
      // body: _getContentSection(),
    );
  }

  Widget _generarStreamBuilder() {
    return StreamBuilder(
        stream: noticiasProvider.noticiasStream,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return _cargarCards(noticias: snapshot.data);
            // return CardNoticias(noticias: snapshot.data, siguientePagina: noticiasProvider.getNoticias);
          } else {
            return Container(
                height: 400.0,
                child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  Widget _cargarCards({List<Noticia> noticias}) {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: RefreshIndicator(
        key: refreshkey,
        onRefresh: _handleRefresh,
        child: ListView.builder(
            controller: _pageController,
            itemBuilder: (BuildContext context, int index) {
              if (noticias[index].img == null || noticias[index].img == '') {
                return _cardSinImagen(
                    Icons.record_voice_over, Colors.teal, noticias[index]);
              } else {
                return _cardConImagen(context, noticias[index]);
              }
            },
            itemCount: noticias.length),
      ),
    );
  }

  Widget _cardSinImagen(IconData icon, Color colorIcon, Noticia noticia) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, NoticiasDetallePage.routeName,
              arguments: noticia);
        },
        child: Container(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(icon, color: Theme.of(context).accentColor, size: 35.0),
                trailing: Icon(Icons.keyboard_arrow_right,
                    color: Theme.of(context).accentColor),
                title: Text(noticia.titulo,
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.headline1),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(noticia.descripcion,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.bodyText1)),
              Divider(
                color: Theme.of(context).accentColor,
                indent: 20,
                endIndent: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                child: Row(
                  children: <Widget>[
                    // Agregamos los botones de tipo Flat, un icono, un texto y un evento
                    Text(
                        timeago.format(DateTime.parse(noticia.time),
                            locale: 'es'),
                        style: Theme.of(context).textTheme.subtitle2),
                    Expanded(child: Container()),
                    Text(noticia.area.nombre,
                        style: Theme.of(context).textTheme.subtitle2),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardConImagen(BuildContext context, Noticia noticia) {
    final tamano = MediaQuery.of(context).size.width;
    final tamanoH = MediaQuery.of(context).size.height;
    final card = Container(
      // height: tamanoH * 0.225,
      child: Row(children: <Widget>[
        Expanded(
            child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: FadeInImage(
            image: NetworkImage(noticia.getNoticiaImg()),
            placeholder: AssetImage('assets/loading.gif'),
            fadeInDuration: Duration(milliseconds: 200),
            fit: BoxFit.cover,
          ),
        )),
        Container(
          height: tamanoH * 0.18,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          width: tamano * 0.6,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(noticia.titulo,
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ),
              Expanded(child: Container()),
              Divider(
                color: Theme.of(context).accentColor,
                indent: 20,
                endIndent: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Row(
                  children: <Widget>[
                    // Agregamos los botones de tipo Flat, un icono, un texto y un evento
                    Text(
                        timeago.format(DateTime.parse(noticia.time),
                            locale: 'es'),
                        style: Theme.of(context).textTheme.subtitle2),
                    Expanded(child: Container()),
                    Text(noticia.area.nombre,
                        style: Theme.of(context).textTheme.subtitle2),
                  ],
                ),
              )
            ],
          ),
        ),
      ]),
    );
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                spreadRadius: 2.0,
                offset: Offset(2.0, 10.0),
              )
            ]),
        // child: ClipRRect(
        //   borderRadius: BorderRadius.circular(20.0),
        child: card,
        // ),
      ),
      onTap: () {
        Navigator.pushNamed(context, NoticiasDetallePage.routeName,
            arguments: noticia);
      },
    );
  }

  ////////////////////////////

  Widget _cardTipo2() {
    final card = Container(
      child: Column(children: <Widget>[
        FadeInImage(
          image: NetworkImage(
            // 'https://www.yourtrainingedge.com/wp-content/uploads/2019/05/background-calm-clouds-747964.jpg',
            'http://10.0.2.2:3000/imagen/noticia/5ef369b1afbc803d0816e90f-319.jpg',
            // 'https://fathomless-fjord-54392.herokuapp.com/imagen/usuarios/5eed05ac06cc7756782e254d-743.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c3VhcmlvIjp7InJvbGUiOiJBRE1JTl9ST0xFIiwiZXN0YWRvIjp0cnVlLCJnb29nbGUiOmZhbHNlLCJfaWQiOiI1ZWVkMzRiNTQwMTM3ZjBiZDg0YmQxMDQiLCJub21icmUiOiJUZXN0MSIsImVtYWlsIjoidGVzdDFAZW1haWwuY29tIiwiX192IjowfSwiaWF0IjoxNTkyOTU2NTUyLCJleHAiOjE1OTI5NjAxNTJ9.GY4owWFCrojUpGQrfb6ad8AYLs2sM1LvxUQGXtKtQWM',
          ),
          placeholder: AssetImage('assets/loading.gif'),
          fadeInDuration: Duration(milliseconds: 200),
          fit: BoxFit.cover,
        ),

        // Image(
        //  image: NetworkImage('https://www.yourtrainingedge.com/wp-content/uploads/2019/05/background-calm-clouds-747964.jpg'),
        //  ),

        Padding(
            padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: Text('Esto es un titulo de noticia',
                textAlign: TextAlign.justify,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0))),
        Divider(
          color: Colors.blue,
          indent: 20,
          endIndent: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
          child: Row(
            children: <Widget>[
              // Agregamos los botones de tipo Flat, un icono, un texto y un evento
              Text('1 hour ago'),
              Expanded(child: Container()),
              Text('Sistemas'),
            ],
          ),
        )
      ]),
    );
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              spreadRadius: 2.0,
              offset: Offset(2.0, 10.0),
            )
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: card,
      ),
    );
  }
}
