import 'package:flutter/material.dart';
import 'package:preferencia_usuario_app/src/models/noticias_model.dart';
import 'package:preferencia_usuario_app/src/pages/avisos/avisos_detalle_page.dart';
import 'package:preferencia_usuario_app/src/providers/noticias_provider.dart';

class NoticiasSearch extends SearchDelegate{
String seleccion ='';
final noticiasProvider = new NoticiasProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro appBar
    return [
      IconButton( 
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';
        },
      ),
    ];
  } 

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon( 
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container( 
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion)
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando se escribe
   if(query.isEmpty){
     return Container();
   }

   return FutureBuilder(
     future: noticiasProvider.buscarNoticia(query),
     builder: (BuildContext context, AsyncSnapshot<List<Noticia>> snapshot) {
       if(snapshot.hasData){
         final peliculas = snapshot.data;
         return ListView(
           children: peliculas.map((noticia){
             return ListTile(
               leading: FadeInImage( 
                 image: NetworkImage(noticia.getNoticiaImg()[0]),
                 placeholder: AssetImage('assets/img/no-image.jpg'),
                 width: 50.0,
                 fit: BoxFit.contain,
               ),
               title: Text(noticia.titulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.headline1),
               subtitle: Text(noticia.descripcion,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.bodyText1),
               onTap: (){
                 close(context, null);
                 Navigator.pushNamed(context, NoticiasDetallePage.routeName, arguments: noticia);
               },
             );
           }).toList(),
           );
       }else{
         return Center( 
           child: CircularProgressIndicator(),
         );
       }
     },
   );
  }

  

}