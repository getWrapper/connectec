import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:preferencia_usuario_app/src/models/noticias_model.dart';
import 'package:preferencia_usuario_app/src/models/nuevo_aviso.dart';
import 'package:preferencia_usuario_app/src/providers/connection_provider.dart';
import 'package:preferencia_usuario_app/src/providers/noticias_provider.dart';
import 'package:preferencia_usuario_app/src/widgets/menu_widget.dart';
import 'package:preferencia_usuario_app/src/widgets/modal_dialog.dart';

class AvisoNuevoPage extends StatefulWidget {
  const AvisoNuevoPage({Key key}) : super(key: key);
  static final String routeName = 'aviso-nuevo';

  @override
  _AvisoNuevoPageState createState() => _AvisoNuevoPageState();
}

class _AvisoNuevoPageState extends State<AvisoNuevoPage>
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
  NuevoAviso aviso = new NuevoAviso();
  ConnectionProvider connectionProvider = ConnectionProvider();
  bool _progressActive;
  List<Asset> images = List<Asset>();
  List<File> listFile = List<File>();

  String _error = 'No Error Dectected';

  @override
  Widget build(BuildContext context) {
    _colorButton = Theme.of(context).primaryColor;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        drawer: MenuWidget(),
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Nuevo Aviso'),
        ),
        body: Stack(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                child: Container(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _getWidgetAvisoCard(),
                    _getWidgetViewCard(),
                    _getWidgetButton(context),
                  ]),
            )),
          ),  
          _progressActive == true
              ? Container(
                  color: Colors.black.withOpacity(0.7),
                  child: Center(child: Image.asset('assets/loader.gif', width: 100.0),),
                )
              : Container(),
        ]),
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
        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
            labelText: 'Titulo',
            icon: Icon(Icons.receipt),
            border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(8.0))),
        onSaved: (value) {
          setState(() {
            aviso.titulo = value;
          });
        },
      ),
    );
  }

  Widget _widgetDescription() {
    return Container(
      padding: EdgeInsets.only(top: 16.0),
      child: TextFormField(
        textAlign: TextAlign.justify,
        controller: _textEditDescription,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
            labelText: 'Descripción',
            icon: Icon(Icons.description),
            border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(8.0))),
        onSaved: (value) {
          setState(() {
            aviso.descripcion = value;
          });
        },
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
          child: Text('¿Agregar imágenes?'),
        ),
        Expanded(child: Container()),
        Switch(
          value: switchOn,
          onChanged: (value) {
            setState(() {
              switchOn = value;
              if (!value) {
                _image = null;
              }
              aviso.cargarImagen = value;
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
        loadAssets();
        // _showSelectionDialog(context);
      },
      child: Icon(Icons.camera_alt),
    );
    if (switchOn) {
      return fab;
    }
    return Container();
  }

  Widget _getWidgetViewCard() {
    final sizeScreen = MediaQuery.of(context).size;
    var height = sizeScreen.height * 0.3;
    if (switchOn == false) {
      return Container();
    }
    if (images.length == 0) {
      height = sizeScreen.height * 0.1;
    } else if (images.length == 2) {
      height = sizeScreen.height * 0.25;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                color: Colors.grey[100],
                height: height,
                child: buildGridView(),
              ),
              Positioned(
                child: _buttonImg(),
                bottom: 0.0,
                right: 0.0,
              )
            ],
          ),
          _labelSelected(),
        ],
      ),
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
                      if (switchOn && images.length == 0) {
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

  setUpButtonChild() {
    if (_state == 0) {
      _colorButton = Theme.of(context).primaryColor;
      return Text(
        'Publicar aviso',
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
    double initialWidth = _globalKey.currentContext.size.width;

    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    var connection = await connectionProvider.checkConnection();
    var resp = 3;
    if (connection) {
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

      Noticia crearAviso = await avisoProvider.crearAviso(aviso);

      if (crearAviso != null) {
        if (aviso.cargarImagen == true) {
          await avisoProvider.cargarImgAsset(images, crearAviso.id);
        }
        _msg = 'Ocurrio un error al crear el aviso';

        if (crearAviso.id != null) {
          resp = 2;
          _msg = 'Se publico el aviso con éxito';
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
        _textEditTitle.clear();
        _textEditDescription.clear();
        switchOn = false;
        _showToast(context, Colors.green);
        Timer(Duration(milliseconds: 4200), () {
          if (_state != 0) {
            setState(() {
              _state = 0;
              animateResetButton();
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

  Future<bool> _onBackPressed() {
    var alert = ModalDialog('¿Estás seguro?',
        '¿Quieres salir de la aplicación?', 'Cancelar', 'Salir', () {
      Navigator.of(context).pop(true);
    }, null);
    return showDialog(context: context, builder: (context) => alert);
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 20,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "ConnecTEC",
          allViewTitle: "Todas las imagenes",
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
      images = resultList;
      _error = error;
    });
  }

  Widget buildGridView() {
    listFile.clear();
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(images.length, (index) {
        // _convertAssetToFile(images[index]);
        Asset asset = images[index];
        return Container(
          padding: EdgeInsets.all(2.0),
          child: Stack(
            children: <Widget>[
              AssetThumb(
                asset: asset,
                width: 300,
                height: 300,
              ),
              Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    child: Icon(Icons.delete_forever,
                        color: Theme.of(context).accentColor),
                    onTap: () {
                      setState(() {
                        images.removeAt(index);
                        // listFile.removeAt(index);
                      });
                    },
                  )),
            ],
          ),
        );
      }),
    );
  }
  // _convertAssetToFile(Asset image)async{
  //   final filePath = await FlutterAbsolutePath.getAbsolutePath(image.identifier);
  //   listFile.add(File(filePath));
  // }

  Widget _labelSelected() {
    Widget text = Container();
    if (images.length == 0) {
      text = Text('Sin archivos seleccionados',
          style: Theme.of(context).textTheme.headline3);
    } else if (images.length == 1) {
      text = Text('${images.length} archivo seleccionado',
          style: Theme.of(context).textTheme.headline3);
    } else {
      if (images.length > 1) {
        text = Text('${images.length} archivos seleccionados',
            style: Theme.of(context).textTheme.headline3);
      }
    }

    return text;
  }
}
