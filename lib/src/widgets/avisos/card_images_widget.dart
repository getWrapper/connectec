import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:preferencia_usuario_app/src/models/noticias_model.dart';
import 'package:preferencia_usuario_app/src/pages/avisos/avisos_detalle_page.dart';
import 'package:preferencia_usuario_app/src/pages/avisos/carousel_page.dart';
import 'package:timeago/timeago.dart' as timeago;


class CardImages extends StatelessWidget {
  const CardImages({
    Key key,
    @required this.aviso,
  }) : super(key: key);

  final Noticia aviso;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      child: Column(children: <Widget>[
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
        if(aviso.descripcion == null || aviso.descripcion.replaceAll(' ','').isEmpty){
          Navigator.pushNamed(context, CarouselPage.routeName,
                      arguments: aviso.getNoticiaImg());

        }else{
        Navigator.pushNamed(context, NoticiasDetallePage.routeName,
            arguments: aviso);
        }
      },
    );
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
                        color: Colors.black.withOpacity(0.3),
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
   String _cargarImg(Noticia aviso, int index) {
    List<String> listImg = aviso.getNoticiaImg();
    return listImg[index];
  }
}
