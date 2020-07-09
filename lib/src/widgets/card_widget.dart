import 'package:flutter/material.dart';
import 'package:preferencia_usuario_app/src/models/noticias_model.dart';
import 'package:preferencia_usuario_app/src/pages/noticias_detalle_page.dart';
import 'package:preferencia_usuario_app/src/providers/noticias_provider.dart';

class CardNoticias extends StatelessWidget {
  final List<Noticia> noticias;
  final Function siguientePagina;

  CardNoticias({@required this.noticias,  @required this.siguientePagina});
  final _pageController = new PageController(viewportFraction: 0.3);
  var refreshkey = GlobalKey<RefreshIndicatorState>();
  NoticiasProvider noticiasProvider = NoticiasProvider();

Future<Null> _handleRefresh() async {
    noticiasProvider.dispose();
    noticiasProvider = new NoticiasProvider();
    await noticiasProvider.getNoticiasInit();
    // _pageController = new PageController(viewportFraction: 0.3);
    // setState(() {
    // // _scrollListener();
    // });
    return null;
  }
  @override
  Widget build(BuildContext context) {
    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: RefreshIndicator(
        key: refreshkey,
        onRefresh: _handleRefresh,
              child: ListView.builder(
          controller: _pageController,
          itemBuilder: (BuildContext context, int index) {
            if (noticias[index].img == null || noticias[index].img == '') {
              return _cardSinImagen(Icons.warning, Colors.green, noticias[index]);
            } else {
              return _cardConImagen(context, noticias[index]);
            }
          },
          itemCount: noticias.length
        ),
      ),
    );
  }

  Widget _cardSinImagen(IconData icon, Color colorIcon, Noticia noticia) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(icon, color: colorIcon, size: 35.0),
              title: Text(noticia.titulo,
                  textAlign: TextAlign.justify,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            ),
            Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(noticia.descripcion, textAlign: TextAlign.justify)),
            Divider(
              color: Colors.blue,
              indent: 20,
              endIndent: 20,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
              child: Row(
                children: <Widget>[
                  // Agregamos los botones de tipo Flat, un icono, un texto y un evento
                  Text('1 hour ago'),
                  Expanded(child: Container()),
                  Text(noticia.area.nombre),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cardConImagen(BuildContext context, Noticia noticia) {
    final tamano = MediaQuery.of(context).size.width;
    final card = Container(
      child: Row(children: <Widget>[
        Expanded(
            // width: tamano * 0.34,
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
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          width: tamano * 0.6,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child:Text(
                  noticia.titulo,
                  softWrap: true,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ),
              Divider(
                color: Colors.blue,
                indent: 20,
                endIndent: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Row(
                  children: <Widget>[
                    // Agregamos los botones de tipo Flat, un icono, un texto y un evento
                    Text('1 hour ago'),
                    Expanded(child: Container()),
                    Text(noticia.area.nombre),
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
      ),
      onTap: () {
        Navigator.pushNamed(context, NoticiasDetallePage.routeName,
            arguments: noticia);
      },
    );
  }
}
