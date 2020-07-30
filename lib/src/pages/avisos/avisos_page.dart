import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:preferencia_usuario_app/src/models/noticias_model.dart';
import 'package:preferencia_usuario_app/src/providers/noticias_provider.dart';
import 'package:preferencia_usuario_app/src/search/noticias_search_delegate.dart';
import 'package:preferencia_usuario_app/src/widgets/menu_widget.dart';

import 'avisos_detalle_page.dart';
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
      color: Colors.grey[300],
      child: RefreshIndicator(
        key: refreshkey,
        onRefresh: _handleRefresh,
        child: ListView.builder(
            controller: _pageController,
            itemBuilder: (BuildContext context, int index) {
              if (noticias[index].id == '0') {
                return _sinAvisos();
              } else if (noticias[index].id == '1') {
                return _finAvisos();
              } else if (noticias[index].img == null ||
                  noticias[index].img.images.isEmpty) {
                return _cardSinImagen(
                    Icons.record_voice_over, Colors.teal, noticias[index]);
              } else {
                return _cardTipo2(context, noticias[index]);
                // return _cardConImagen(context, noticias[index]);
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, NoticiasDetallePage.routeName,
              arguments: noticia);
        },
        child: Container(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(icon,
                    color: Theme.of(context).accentColor, size: 35.0),
                trailing: Icon(Icons.keyboard_arrow_right,
                    color: Theme.of(context).accentColor),
                title: Text(noticia.titulo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                            locale: 'es_short'),
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
        child: card,
      ),
      onTap: () {
        Navigator.pushNamed(context, NoticiasDetallePage.routeName,
            arguments: noticia);
      },
    );
  }

  ////////////////////////////

  Widget _cardTipo2(BuildContext context, Noticia aviso) {
    final card = Container(
      child: Column(children: <Widget>[
        // ClipRRect(
        //   borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20.0)),
        //           child: FadeInImage(
        //             height: 300,
        //     image: NetworkImage(_cargarImg(aviso)),
        //     placeholder: AssetImage('assets/loading.gif'),
        //     fadeInDuration: Duration(milliseconds: 200),
        //     fit: BoxFit.fill,
        //   ),
        // ),
        _cargarImagenes(aviso),
        Padding(
            padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: Text(aviso.titulo,
                softWrap: true,
                textAlign: TextAlign.justify,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                maxLines: 2,
                overflow: TextOverflow.ellipsis)),
        Divider(
          color: Theme.of(context).accentColor,
          indent: 20,
          endIndent: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
          child: Row(
            children: <Widget>[
              // Agregamos los botones de tipo Flat, un icono, un texto y un evento
              Text(timeago.format(DateTime.parse(aviso.time), locale: 'es'),
                  style: Theme.of(context).textTheme.subtitle2),
              Expanded(child: Container()),
              Text(aviso.area.nombre,
                  style: Theme.of(context).textTheme.subtitle2),
            ],
          ),
        )
      ]),
    );
    // );

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                spreadRadius: 2.0,
                offset: Offset(2.0, 10.0),
              )
            ]),
        child: card,
      ),
      onTap: () {
        Navigator.pushNamed(context, NoticiasDetallePage.routeName,
            arguments: aviso);
      },
    );
  }

  Widget _sinAvisos() {
    // _showToast('Revisa tu conexión a internet');
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * .9,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SizedBox(height: size.height * .3),
          Center(
              child: Text('No se puede cargar avisos',
                  style: Theme.of(context).textTheme.headline6)),
        ],
      ),
    );
  }

  Widget _finAvisos() {
    // _showToast('Revisa tu conexión a internet');
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Text('No hay mas avisos',
                    style: Theme.of(context).textTheme.headline1)),
          ),
        ],
      ),
    );
  }

  void _showToast(String msg) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(fontSize: 15.0),
        ),
      ),
    );
  }

  String _cargarImg(Noticia aviso, int index) {
    List<String> listImg = aviso.getNoticiaImg();
    if(index > listImg.length){
      
    }
    return listImg[index];
  }

  Widget _cargarImagenes(Noticia aviso) {
    Widget child;
    if (aviso.img.images.length == 1) {
      child = ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
        child: FadeInImage(
          // height: 200,
          image: NetworkImage(_cargarImg(aviso, 0)),
          placeholder: AssetImage('assets/loading.gif'),
          fadeInDuration: Duration(milliseconds: 200),
          fit: BoxFit.cover
        ),
      );
    } else if (aviso.img.images.length == 2) {
      child = ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: CachedNetworkImage(height: 150,fadeInDuration: Duration(milliseconds: 200), fit: BoxFit.cover,imageUrl: _cargarImg(aviso, 0), placeholder: (context, url) =>  Image.asset('assets/loading.gif')
              ),

              // child: FadeInImage(
              //   height: 150,
              //   image: NetworkImage(_cargarImg(aviso, 0)),
              //   placeholder: AssetImage('assets/loading.gif'),
              //   fadeInDuration: Duration(milliseconds: 200),
              //   fit: BoxFit.cover,
              // ),
            ),
            Expanded(
              child: CachedNetworkImage(height: 150,fadeInDuration: Duration(milliseconds: 200), fit: BoxFit.cover,imageUrl: _cargarImg(aviso, 1), placeholder: (context, url) =>  Image.asset('assets/loading.gif')),
              // child: FadeInImage(
              //     height: 150,
              //     image: NetworkImage(_cargarImg(aviso, 1)),
              //     placeholder: AssetImage('assets/loading.gif'),
              //     fadeInDuration: Duration(milliseconds: 200),
              //     fit: BoxFit.cover),
            ),
          ],
        ),
      );
    } else if (aviso.img.images.length > 2) {
      child = ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: CachedNetworkImage(height: 200,fadeInDuration: Duration(milliseconds: 200), fit: BoxFit.cover,imageUrl: _cargarImg(aviso, 0), placeholder: (context, url) =>  Image.asset('assets/loading.gif')),
              // child: FadeInImage(
              //   height: 200,
              //   image: NetworkImage(_cargarImg(aviso, 0)),
              //   placeholder: AssetImage('assets/loading.gif'),
              //   fadeInDuration: Duration(milliseconds: 200),
              //   fit: BoxFit.cover,
              // ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  CachedNetworkImage(height: 100,fadeInDuration: Duration(milliseconds: 200), fit: BoxFit.cover,imageUrl: _cargarImg(aviso, 1), placeholder: (context, url) =>  Image.asset('assets/loading.gif')),
                  // FadeInImage(
                  //   height: 100,
                  //   // width: 200,
                  //   image: NetworkImage(_cargarImg(aviso, 1)),
                  //   placeholder: AssetImage('assets/loading.gif'),
                  //   fadeInDuration: Duration(milliseconds: 200),
                  //   fit: BoxFit.cover,
                  // ),
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      CachedNetworkImage(height: 100,fadeInDuration: Duration(milliseconds: 200), fit: BoxFit.cover,imageUrl: _cargarImg(aviso, 2), placeholder: (context, url) =>  Image.asset('assets/loading.gif')),

                      // FadeInImage(
                      //   height: 100,
                      //   // width: 200,
                      //   // image: NetworkImage(_cargarImg(aviso, 2)),
                      //   // placeholder: AssetImage('assets/loading.gif'),
                      //   // fadeInDuration: Duration(milliseconds: 200),
                      //   // fit: BoxFit.cover,
                      //   // image: CachedNetworkImage(imageUrl: _cargarImg(aviso, 2),
                      // ),
                     aviso.img.images.length > 3 ? Container(
                        height: 100.0,
                        color: Colors.black.withOpacity(0.6),
                        child: Center(child: Text('+${aviso.img.images.length - 3}', style: TextStyle(color: Colors.white, fontSize: 20.0),)),
                      ):Container()
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
    }
    return child;
  }
}
