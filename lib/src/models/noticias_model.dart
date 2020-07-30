
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
  Images img;

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
    img      = new Images.fromJsonList(json['img']);   
  }

   getNoticiaImg  (){
     List<String> imgUrls = new List();
         String _url = 'connectec-alpha.herokuapp.com';
         if(img.images.isEmpty){
           imgUrls.add('https://www.pequenomundo.cl/wp-content/themes/childcare/images/default.png');
         }
         img.images.forEach((urlImg) {
           imgUrls.add('https://'+_url+'/imagen/noticia/$urlImg');
         });
    
      return imgUrls;

  }

  Noticia.nuevoAviso(Map<String, dynamic> json) {
    time = json['time'];
    id  = json['_id'];
    titulo      = json['titulo'];
    descripcion = json['descripcion'];
    img      = new Images.fromJsonList(json['img']);  
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

class Images {
  List<String> images = new List();

  Images({
    this.images
  });
 Images.fromJsonList( List<dynamic> jsonList ){
    if(jsonList == null) return;

    for (var item in jsonList) {
      images.add(item);
    }
  }

}



