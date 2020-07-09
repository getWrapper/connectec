import 'package:flutter/material.dart';
import 'package:preferencia_usuario_app/src/models/noticias_model.dart';
import 'package:preferencia_usuario_app/src/providers/noticias_provider.dart';
import 'package:preferencia_usuario_app/src/shared_prefs/preferencias_usuario.dart';
import 'package:preferencia_usuario_app/src/widgets/modal_dialog.dart';

class NoticiasDetallePage extends StatelessWidget {
  static final String routeName = 'noticias-detalle';
  final prefs = new PreferenciasUsuario();
  NoticiasProvider avisosProvider = NoticiasProvider();


  @override
  Widget build(BuildContext context) {
    final Noticia noticia = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: CustomScrollView(
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
    );
  }

  Widget _imgAppBar(Noticia noticia, BuildContext context) {
    if (noticia.img == '' || noticia.img == null) {
      return SliverAppBar(actions: _actionsAdmin(context, noticia));
    }
    var img = SliverAppBar(
        actions: _actionsAdmin(context, noticia),
        floating: true,
        expandedHeight: 250,
        pinned: true,
        // Mostrar un widget placeholder para visualizar el tamaño de reducción
        flexibleSpace: FlexibleSpaceBar(
          // background: Image.asset('assets/img/tec.jpg', fit: BoxFit.cover),
          background: Hero(
            tag: noticia.id,
            child: FadeInImage(
              image: NetworkImage(noticia.getNoticiaImg()),
              placeholder: AssetImage('assets/loading.gif'),
              fadeInDuration: Duration(milliseconds: 200),
              fit: BoxFit.cover,
            ),
          ),
        ));
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

  List<Widget> _actionsAdmin(BuildContext context, Noticia noticia) {
    List<Widget> actions = new List();
    if(prefs.loggedIn == 1 && prefs.userRol == 'ADMIN_ROLE'){
      actions.add(IconButton(icon: Icon(Icons.edit), onPressed: () {

      }));
      actions.add(IconButton(icon: Icon(Icons.delete), onPressed: (){
         _showConfirmDelete(context, noticia);
         }));
    }
    return actions;
  }
  void _showConfirmDelete(context, Noticia aviso){
 var alert = ModalDialog('Eliminar Aviso', '¿Esta seguro de eliminar el aviso?', 'Cancelar', 'Eliminar', (){
    //  avisosProvider.deleteAviso(aviso.id);
    });

  showDialog(context: context, builder: (context) => alert);
 

}
}
