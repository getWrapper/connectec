
class Noticias {

  List<Noticia> items = new List();
  Noticias();
  Noticias.fromJsonList( List<dynamic> jsonList ){
    if(jsonList == null) return;

    for (var item in jsonList) {
      final noticia = new Noticia.fromJsonMap(item);
      items.add(noticia);
    }
  }
}

class Noticia {
  String time;
  String id;
  String titulo;
  int v;
  String descripcion;
  Area area;
  String img;

  Noticia({
    this.time,
    this.id,
    this.titulo,
    this.v,
    this.descripcion,
    this.area,
    this.img,
  });


Noticia.fromJsonMap(Map<String, dynamic> json) {
    time = json['time'];
    id  = json['_id'];
    titulo      = json['titulo'];
    descripcion = json['descripcion'];
    area         = new Area.fromJsonMap(json['area']);
    img      = json['img'];   
  }

   getNoticiaImg  (){
         String _url = 'connectec-alpha.herokuapp.com';
      if(img == null){
        return 'https://www.pequenomundo.cl/wp-content/themes/childcare/images/default.png';
      }else{
        // Local
      // return 'http://10.0.2.2:3000/imagen/noticia/$img';
      // Prod
      return 'https://'+_url+'/imagen/noticia/$img';

      }
  }
}
class Area {
  String id;
  String nombre;

  Area({
    this.id,
    this.nombre,
  });

    Area.fromJsonMap(Map<String, dynamic> json) {
    id  = json['_id'];
    nombre  = json['nombre'];
    }

}

class AvisoDelete{
  bool ok;
  String message;
}



