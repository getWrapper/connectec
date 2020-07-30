import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:preferencia_usuario_app/src/models/noticias_model.dart';
class GridImagesWidget extends StatefulWidget {
  
final Noticia aviso;
  

GridImagesWidget(this.aviso, {Key key}) : super(key: key);

  @override
  _GridImagesWidgetState createState() => _GridImagesWidgetState();
}

class _GridImagesWidgetState extends State<GridImagesWidget> {
List<String> images;
List<Asset> assets;
// String _error = 'No Error Dectected';

  @override
  void initState() {
    images= widget.aviso.getNoticiaImg();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text('Imagenes actuales',style: Theme.of(context).textTheme.headline3),
          _getWidgetViewCard(context)
        ],
      ),
    );

  }

  Widget _getWidgetViewCard(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    var height = sizeScreen.height * 0.3;
    if(images.length == 0){
      height = sizeScreen.height * 0.1;
    }else if(images.length == 2){
      height = sizeScreen.height * 0.25;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
Container(
        color: Colors.grey[100],
        height: height,
        child: buildGridView(context),
      ),
      Positioned(child: _buttonImg(), bottom: 0.0, right: 0.0,)
            ],
                       
          ),
      _labelSelected(context),
        ],
      ),
    );
  }

Widget _labelSelected(BuildContext context){
    Widget text = Container();
    if(images.length == 0){
      text= Text('Sin archivos seleccionados', style: Theme.of(context).textTheme.headline3 );
    }else if(images.length == 1){
      text= Text('${images.length} archivo seleccionado',style: Theme.of(context).textTheme.headline3 );
    }else{
      if(images.length > 1){
      text= Text('${images.length} archivos seleccionados', style: Theme.of(context).textTheme.headline3 );
    }
    }
    
    return text;
  }

   Widget _buttonImg() {
    var fab = FloatingActionButton(
      onPressed: () {
        loadAssets();
      },
      child: Icon(Icons.camera_alt),
    );
    return fab;
  }

   Widget buildGridView(BuildContext context) {
    // listFile.clear();
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(images.length, (index) {
        // _convertAssetToFile(images[index]);
        // Asset asset = images[index];
        return Container(
          padding: EdgeInsets.all(2.0),
          child: Stack(
                alignment: Alignment.center,
            children: <Widget>[
              FadeInImage(
          height: 300,
          image: NetworkImage(images[index]),
          placeholder: AssetImage('assets/loading.gif'),
          fadeInDuration: Duration(milliseconds: 200),
          fit: BoxFit.fill,
        ),
            //   AssetThumb(
            // asset: asset,
            // width: 300,
            // height: 300,
          // ),

          Positioned(top: 5, right: 5, child: GestureDetector(child: Icon(Icons.delete_forever, color: Theme.of(context).accentColor), onTap: (){
            setState(() {
            images.removeAt(index);
            // listFile.removeAt(index);
            });
          },)),
            ],
          ),
        );
        // return Container(color: Colors.green, height: 100.0 ,child: Image.file(listFile[index].absolute, fit: BoxFit.fill));
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 20,
        enableCamera: true,
        selectedAssets: assets,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      assets = resultList;
      // _error = error;
    });
  }
}