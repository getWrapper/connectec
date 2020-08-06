import 'package:flutter/material.dart';
import 'package:preferencia_usuario_app/src/models/noticias_model.dart';
import 'package:preferencia_usuario_app/src/pages/avisos/avisos_detalle_page.dart';
import 'package:timeago/timeago.dart' as timeago;


class CardText extends StatelessWidget {
  const CardText({
    Key key,
    @required this.icon,
    @required this.colorIcon,
    @required this.noticia,
  }) : super(key: key);

  final IconData icon;
  final Color colorIcon;
  final Noticia noticia;

  @override
  Widget build(BuildContext context) {
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
}
