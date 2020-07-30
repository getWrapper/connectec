import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:preferencia_usuario_app/src/models/noticias_model.dart';
import 'package:preferencia_usuario_app/src/models/nuevo_aviso.dart';
import 'package:preferencia_usuario_app/src/providers/connection_provider.dart';
import 'package:preferencia_usuario_app/src/providers/noticias_provider.dart';
import 'package:preferencia_usuario_app/src/widgets/menu_widget.dart';
import 'package:preferencia_usuario_app/src/widgets/modal_dialog.dart';
import 'package:multi_image_picker/multi_image_picker.dart';


class AvisoEditarPage extends StatefulWidget {
  const AvisoEditarPage({Key key}) : super(key: key);
  static final String routeName = 'editar-aviso';

  @override
  _AvisoEditarPageState createState() => _AvisoEditarPageState();
}

class _AvisoEditarPageState extends State<AvisoEditarPage>
    with TickerProviderStateMixin {
  NoticiasProvider avisoProvider = NoticiasProvider();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static var _keyValidationForm = GlobalKey<FormState>();
  TextEditingController _textEditTitle = TextEditingController();
  TextEditingController _textEditDescription = TextEditingController();
  bool switchOn = false;
  File _image;
  final picker = ImagePicker();
  Color _colorButton;
  Animation _animation;
  AnimationController _controller;
  GlobalKey _globalKey = GlobalKey();
  double _width = double.maxFinite;
  String _msg = '';
  int _state = 0;
  bool _formValid = true;
  Noticia avisoEditar = new Noticia();
  NuevoAviso nuevoAviso = new NuevoAviso();
  ConnectionProvider connectionProvider = ConnectionProvider();
  bool _progressActive;
  List<Asset> assets;

  @override
  Widget build(BuildContext context) {
    avisoEditar = ModalRoute.of(context).settings.arguments;
    _colorButton = Theme.of(context).primaryColor;
    _textEditTitle.text = avisoEditar.titulo;
    _textEditDescription.text = avisoEditar.descripcion;
    return Scaffold(
      drawer: MenuWidget(),
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Actualizar Aviso'),
      ),
      body: Stack(
              children: <Widget>[ Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              child: Container(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _getWidgetAvisoCard(),
                  _gridImagesView(),
                  //  Container(child: ListTile(trailing: _buttonImg()), width: MediaQuery.of(context).size.width),
                  _getWidgetButton(context),
                  _getWidgetSizedBox(),
                ]),
          )),
        ),
        _progressActive == true
              ? Container(
                  color: Colors.black.withOpacity(0.7),                )
              : Container(),],
      ),
    );
  }

  Widget _getWidgetAvisoCard() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: Form(
          key: _keyValidationForm,
          child: Column(
            children: <Widget>[
              _widgetTitle(),
              _widgetDescription(),
              _widgetToogleImg()
            ],
          )),
    );
  }

  Widget _widgetTitle() {
    return Container(
      child: TextFormField(
        controller: _textEditTitle,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        validator: _validateUserName,
        decoration:
            InputDecoration(labelText: 'Titulo',
            fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0))
            ),
        onSaved: (value) {
          setState(() {
            avisoEditar.titulo = value;
          });
        },
        onChanged: (value){
          avisoEditar.titulo = value;
        },
        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
        maxLines: 1,
        
        // style: new TextStyle(
        //                 fontFamily: "Poppins",
        //               )
      ),
    );
  }

  Widget _widgetDescription() {
    return Container(
      padding: EdgeInsets.only(top: 16.0),
      child: TextFormField(
        controller: _textEditDescription,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value.isEmpty) {
            return 'Descripción es requerida';
          }
          return null;
        },
        decoration: InputDecoration(
            labelText: 'Descripción',fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0))),
        onSaved: (value) {
          setState(() {
            avisoEditar.descripcion = value;
          });
        },
        onChanged: (value){
          avisoEditar.descripcion = value;
        },
        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
        maxLines: 5,
      ),
    );
  }

  Widget _widgetToogleImg() {
    return Container(
      child: Row(children: <Widget>[
        Icon(Icons.photo),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text('¿Actualizar la imagen?'),
        ),
        Expanded(child: Container()),
        Switch(
          value: switchOn,
          onChanged: (value) {
            setState(() {
              _keyValidationForm.currentState.save();
              switchOn = value;
              if (!value) {
                _image = null;
              }
            });
          },
          activeTrackColor: Theme.of(context).hoverColor,
          activeColor: Theme.of(context).primaryColor,
        )
      ]),
    );
  }

  String _validateUserName(String value) {
    return value.trim().isEmpty ? "Título es requerido" : null;
  }

  Widget _buttonImg() {
    var fab = FloatingActionButton(
      onPressed: () {
        _keyValidationForm.currentState.save();
        loadAssets();
      },
      child: Icon(Icons.camera_alt),
    );
    if (switchOn) {
      return fab;
    }
    return Container();
  }

  void _showSelectionDialog(BuildContext context) {
    var alert = ModalDialog('Cargar imagen',
        '¿De dónde quieres tomar la imagen?', 'Galería', 'Cámara', () {
      _getImage(ImageSource.camera);
      Navigator.of(context).pop();
    }, () {
      _getImage(ImageSource.gallery);
      Navigator.of(context).pop();
    });

    showDialog(context: context, builder: (context) => alert);
  }

  Future _getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      avisoEditar.img = null;
      _image = File(pickedFile.path);
      nuevoAviso.cargarImagen = true;
    });
  }

  Widget _getWidgetViewCard() {
    var img;
    if (avisoEditar.img != null) {
      img = FadeInImage(
        image: NetworkImage(avisoEditar.getNoticiaImg()),
        placeholder: AssetImage('assets/loading.gif'),
        fadeInDuration: Duration(milliseconds: 200),
        fit: BoxFit.cover,
      );
    } else {
      img = _image == null
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child:
                  Text('Sin imagen seleccionada.', textAlign: TextAlign.center),
            )
          : Image.file(_image, fit: BoxFit.fill);
    }
    final sizeScreen = MediaQuery.of(context).size;
    if (!switchOn) return Container();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 10.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              height: sizeScreen.height * 0.4,
              width: sizeScreen.width,
              child: img,
            ),
          )),
    );
  }

  Widget _getWidgetButton(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: PhysicalModel(
          elevation: 8,
          shadowColor: Colors.yellow[200],
          color: _colorButton,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            key: _globalKey,
            height: 48,
            width: _width,
            child: RaisedButton(
              animationDuration: Duration(milliseconds: 1000),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: EdgeInsets.all(0),
              child: setUpButtonChild(),
              onPressed: _formValid
                  ? () {
                      if (switchOn &&
                          _image == null &&
                          avisoEditar.img == null) {
                        _msg = 'No ha seleccionado una imagen';
                        _showToast(context, Colors.red);
                      } else if (_keyValidationForm.currentState.validate()) {
                        _keyValidationForm.currentState.save();
                        setState(() {
                          if (_state == 0) {
                            animateButton(context);
                          }
                        });
                      }
                    }
                  : null,
              elevation: 4,
              color: _colorButton,
              disabledColor: Colors.yellow[200],
            ),
          ),
        ));
  }

  Widget _getWidgetSizedBox() {
    if (switchOn) {
      return SizedBox(height: 70.0);
    } else {
      return SizedBox();
    }
  }

  setUpButtonChild() {
    if (_state == 0) {
      _colorButton = Theme.of(context).primaryColor;
      return Text(
        'Actualizar aviso',
        style: const TextStyle(
          color: Colors.red,
          fontSize: 17,
        ),
      );
    } else if (_state == 1) {
      return SizedBox(
        height: 36,
        width: 36,
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else if (_state == 2) {
      _colorButton = Colors.green;
      return Icon(Icons.check, color: Colors.white);
    } else {
      _colorButton = Colors.red;
      return Icon(Icons.close, color: Colors.white);
    }
  }

  void animateButton(BuildContext context) async {
    var images = new List<File>();
    images.add(_image);
    images.add(_image);

    double initialWidth = _globalKey.currentContext.size.width;
    var connection = await connectionProvider.checkConnection();
    var resp = 3;
    if (connection) {
      _controller = AnimationController(
          duration: Duration(milliseconds: 300), vsync: this);

      _animation = Tween(begin: 0.0, end: 1).animate(_controller)
        ..addListener(() {
          setState(() {
            _width = initialWidth - ((initialWidth - 48) * _animation.value);
          });
        });
      _controller.forward();

      setState(() {
        _state = 1;
        _progressActive = true;
      });

      bool actualizarAviso = await avisoProvider.actualizarAviso(avisoEditar);
      if (actualizarAviso != null) {
        if (nuevoAviso.cargarImagen == true) {
          await avisoProvider.cargarImg(images, avisoEditar.id);
        }
        _msg = 'Ocurrio un error al crear el aviso';

        if (actualizarAviso) {
          resp = 2;
          _msg = 'Se actualizó el aviso con éxito';
        }
      } else {
        _msg = 'Revisa tu conexión a internet';
        resp = 3;
      }
    } else {
      _msg = 'Revisa tu conexión a internet';
      resp = 3;
    }
    setState(() {
      _progressActive = false;
      _state = resp;
      if (resp == 3) {
        _showToast(context, Colors.red);
        Timer(Duration(milliseconds: 4200), () {
          if (_state != 0) {
            setState(() {
              _state = 0;
              animateResetButton();
            });
          }
        });
      } else {
        _showToast(context, Colors.green);
        Timer(Duration(milliseconds: 4200), () {
          if (_state != 0) {
            setState(() {
              _state = 0;
              Navigator.pushReplacementNamed(context, 'news');
            });
          }
        });
      }
    });
  }

  void animateResetButton() {
    final sizeScreen = MediaQuery.of(context).size;
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          // _width = double.infinity;
          _width = (sizeScreen.width * 0.8) * _animation.value;
        });
      });
    _controller.forward();
  }

  void _showToast(BuildContext context, Color colorText) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          _msg,
          style: TextStyle(fontSize: 15.0, color: colorText),
        ),
        action: SnackBarAction(
            textColor: Colors.blue,
            label: 'OK',
            onPressed: () {
              if (_state != 0) {
                setState(() {
                  _scaffoldKey.currentState.hideCurrentSnackBar();
                  _state = 0;
                  animateResetButton();
                });
              }
            }),
      ),
    );
  }

  Widget _gridImagesView(){
    return Container(
      child: Column(
        children: <Widget>[
          Text('Imagenes cargadas',style: Theme.of(context).textTheme.headline3),
          _getWidgetViewImages()
        ],
      ),
    );
  }

  Widget _getWidgetViewImages() {
    final sizeScreen = MediaQuery.of(context).size;
    var height = sizeScreen.height * 0.3;
    if(avisoEditar.img.images.length == 0){
      height = sizeScreen.height * 0.1;
    }else if(avisoEditar.img.images.length == 2){
      height = sizeScreen.height * 0.25;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
                    Container(
                  color: Colors.grey[100],
                  height: height,
                  child: buildGridView(),
                ),
        ],
      ),
    );
  }
  
  Widget buildGridView() {
    // listFile.clear();
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(avisoEditar.img.images.length, (index) {
        // _convertAssetToFile(images[index]);
        // Asset asset = images[index];
        return Container(
          padding: EdgeInsets.all(2.0),
          child: Stack(
                alignment: Alignment.center,
            children: <Widget>[
              FadeInImage(
          height: 300,
          image: NetworkImage(avisoEditar.getNoticiaImg()[index]),
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
            avisoEditar.img.images.removeAt(index);
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

Widget _labelSelected(BuildContext context){
    Widget text = Container();
    if(avisoEditar.img.images.length == 0){
      text= Text('Sin archivos seleccionados', style: Theme.of(context).textTheme.headline3 );
    }else if(avisoEditar.img.images.length == 1){
      text= Text('${avisoEditar.img.images.length} archivo seleccionado',style: Theme.of(context).textTheme.headline3 );
    }else{
      if(avisoEditar.img.images.length > 1){
      text= Text('${avisoEditar.img.images.length} archivos seleccionados', style: Theme.of(context).textTheme.headline3 );
    }
    }
    
    return text;
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

  @override
  void dispose() {
    super.dispose();
  }
}