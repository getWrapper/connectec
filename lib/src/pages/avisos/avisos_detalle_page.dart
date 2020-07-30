import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:preferencia_usuario_app/src/models/noticias_model.dart';
import 'package:preferencia_usuario_app/src/pages/avisos/carousel_page.dart';
import 'package:preferencia_usuario_app/src/providers/noticias_provider.dart';
import 'package:preferencia_usuario_app/src/shared_prefs/preferencias_usuario.dart';
import 'package:preferencia_usuario_app/src/widgets/modal_dialog.dart';

class NoticiasDetallePage extends StatefulWidget {
  static final String routeName = 'noticias-detalle';

  @override
  _NoticiasDetallePageState createState() => _NoticiasDetallePageState();
}

class _NoticiasDetallePageState extends State<NoticiasDetallePage> {
  final prefs = new PreferenciasUsuario();

  final avisosProvider = NoticiasProvider();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _progressActive;

  @override
  Widget build(BuildContext context) {
    final Noticia noticia = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              _imgAppBar(noticia, context),
              // Agrega un app bar al CustomScrollView
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(
                      height: 10.0,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _footer(noticia, context),
                        Divider(
                          color: Theme.of(context).accentColor,
                          indent: 20,
                          endIndent: 20,
                        ),
                        _titulo(noticia),
                        _descripcion(noticia, context),
                      ],
                    )
                    // _posterTitulo(pelicula, context),
                  ],
                ),
              ),
            ],
          ),
          _progressActive == true
              ? Container(
                  color: Colors.black.withOpacity(0.7),
                  child: Center(child: CircularProgressIndicator()),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _imgAppBar(Noticia noticia, BuildContext context) {
    if (noticia.img.images == null || noticia.img.images.isEmpty) {
      return SliverAppBar(actions: _actionsAdmin(context, noticia));
    }
    List<CachedNetworkImage> _listImg = new List();

    List<String> _imagenes = noticia.getNoticiaImg();
    _imagenes.forEach((urlImg) {
      _listImg.add(CachedNetworkImage(fadeInDuration: Duration(milliseconds: 200), fit: BoxFit.cover,imageUrl: urlImg, placeholder: (context, url) =>  Image.asset('assets/loading.gif')));
  });

    var img = SliverAppBar(
      backgroundColor: Colors.black,
        actions: _actionsAdmin(context, noticia),
        floating: true,
        expandedHeight: 250,
        pinned: true,
        flexibleSpace: _listImg.length > 1 ? Carousel(
            boxFit: BoxFit.cover,
            autoplay: false,
            autoplayDuration: Duration(seconds: 3),
            animationCurve: Curves.fastOutSlowIn,
            animationDuration: Duration(milliseconds: 2000),
            dotSize: 6.0,
            dotIncreasedColor: Theme.of(context).accentColor,
            dotBgColor: Colors.transparent,
            dotPosition: DotPosition.bottomCenter,
            dotVerticalPadding: 0.0,
            showIndicator: true,
            indicatorBgPadding: 7.0,
            images: _listImg,
            defaultImage:  AssetImage('assets/loading.gif'),
            onImageTap: (img) {
                  Navigator.pushNamed(context, CarouselPage.routeName,
                      arguments: _imagenes);
                },
          ) : GestureDetector(child: _listImg[0], onTap: (){
            Navigator.pushNamed(context, CarouselPage.routeName,
                      arguments: _imagenes);
          },)
        );
    return img;
  }

  Widget _titulo(Noticia noticia) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(noticia.titulo,
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
    );
  }

  Widget _descripcion(Noticia noticia, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(noticia.descripcion,
          // 'Officia qui id aliquip exercitation. Cillum incididunt laborum quis dolore proident proident aliqua aliqua in quis amet minim. Velit ex culpa aliqua enim mollit aliqua incididunt. Commodo aute nulla culpa veniam duis. Cillum adipisicing eu esse deserunt esse quis elit occaecat consectetur. Amet fugiat est dolore occaecat veniam voluptate nulla duis id. Proident magna veniam ea qui laborum excepteur fugiat id enim. Incididunt duis ea culpa sit dolor. Sit amet amet cupidatat occaecat qui ex sit in cillum occaecat reprehenderit consequat laborum magna. Nulla consequat et labore esse dolore amet officia. In non sint ullamco aute voluptate adipisicing fugiat do exercitation magna. Est mollit eiusmod proident nulla laborum aliqua magna dolore. Cupidatat aliquip dolor in et nostrud excepteur sint ea nisi fugiat dolor. Irure sit voluptate labore nisi proident irure aliqua aute ea ea. Voluptate pariatur mollit reprehenderit in reprehenderit duis qui dolor incididunt duis occaecat. Ex sint sint irure laboris commodo commodo Lorem.',
          textAlign: TextAlign.justify,
          style: Theme.of(context).textTheme.bodyText1),
    );
  }

  Widget _footer(Noticia noticia, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      child: Row(
        children: <Widget>[
          // Agregamos los botones de tipo Flat, un icono, un texto y un evento
          Text(noticia.time, style: Theme.of(context).textTheme.subtitle2),
          Expanded(child: Container()),
          Text(noticia.area.nombre,
              style: Theme.of(context).textTheme.subtitle2),
        ],
      ),
    );
  }

  List<Widget> _actionsAdmin(BuildContext context, Noticia aviso) {
    List<Widget> actions = new List();
    if (prefs.loggedIn == 1 && prefs.userRol == 'ADMIN_ROLE') {
      actions.add(IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.pushNamed(context, 'editar-aviso', arguments: aviso);
          }));
      actions.add(IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            _showConfirmDelete(context, aviso);
          }));
    }
    return actions;
  }

  void _showConfirmDelete(context, Noticia aviso) {
    var alert = ModalDialog('Eliminar Aviso',
        '¿Esta seguro de eliminar el aviso?', 'Cancelar', 'Eliminar', () async {
      setState(() {
        _progressActive = true;
      });
      Navigator.of(context).pop();
      var respDel = await avisosProvider.deleteAviso(aviso.id);
      setState(() {
        _progressActive = false;
      });
      String msg = "Error al eliminar el aviso";
      Color color = Colors.red;
      if (respDel.ok == true) {
        msg = "Aviso eliminado con éxito";
        color = Colors.green;
      }
      _showToast(context, msg, color);
      Timer(Duration(milliseconds: 3000), () {
        Navigator.pushReplacementNamed(context, 'news');
      });
    }, null);

    showDialog(context: context, builder: (context) => alert);
  }

  void _showToast(BuildContext context, String msg, Color color) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
          content: Text(
        msg,
        style: TextStyle(fontSize: 15.0, color: color),
      )),
    );
  }
}
