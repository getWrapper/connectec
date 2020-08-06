import 'dart:async';
import 'package:flutter/material.dart';
import 'package:preferencia_usuario_app/src/models/noticias_model.dart';
import 'package:preferencia_usuario_app/src/providers/avisos_provider.dart';
import 'package:preferencia_usuario_app/src/search/noticias_search_delegate.dart';
import 'package:preferencia_usuario_app/src/widgets/avisos/card_images_widget.dart';
import 'package:preferencia_usuario_app/src/widgets/avisos/card_text.dart';
import 'package:preferencia_usuario_app/src/widgets/menu_widget.dart';

class NoticiasPage extends StatefulWidget {
  static final String routeName = 'noticias-page';

  @override
  _NoticiasPageState createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage> {
  AvisosProvider noticiasProvider = new AvisosProvider();
  PageController _pageController = PageController(viewportFraction: 0.3);
  var refreshkey = GlobalKey<RefreshIndicatorState>();
  bool cargando = false;

  Future<Null> _handleRefresh() async {
    setState(() {
      noticiasProvider.disposeStreams();
      noticiasProvider = new AvisosProvider();
      noticiasProvider.getNoticiasInit();
    });
    return null;
  }

  @override
  void initState(){
    noticiasProvider = new AvisosProvider();
    noticiasProvider.getNoticias();
    super.initState();
  } 

  @override
  Widget build(BuildContext context) {
    _pageController.addListener(() async{
      if (_pageController.position.pixels >=
              _pageController.position.maxScrollExtent - 200 &&
          (_pageController.position.maxScrollExtent - 200 > 0)) {
        cargando = true;
        await noticiasProvider.getNoticias();
        cargando = false;
      }
    });

    return Scaffold(
      drawer: MenuWidget(),
      appBar: AppBar(
        elevation: 1.0,
        title: Text('Avisos'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: NoticiasSearch());
            },
          ),
        ],
      ),
      body: _generarStreamBuilder(),
    );
  }

  Widget _generarStreamBuilder() {
    return StreamBuilder(
        stream: noticiasProvider.noticiasStream,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return Column(children: <Widget>[
              Expanded(child: _cargarCards(noticias: snapshot.data)),
              cargando == true ? 
              Container(
                height: 40.0,
                child: Center(child: CircularProgressIndicator())) : Container()
            ],);
          } else {
            return Container(
                height: 400.0,
                child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  Widget _cargarCards({List<Noticia> noticias}) {
    return Container(
      color: Colors.grey[300],
      child: RefreshIndicator(
        key: refreshkey,
        onRefresh: _handleRefresh,
        child: ListView.builder(
            controller: _pageController,
            itemBuilder: (BuildContext context, int index) {
              if (noticias[index].id == '0') {
                return _sinAvisos();
              } else if (noticias[index].id == '1') {
                return _finAvisos();
              } else if (noticias[index].img == null ||
                  noticias[index].img.images.isEmpty) {
                return CardText(icon: Icons.record_voice_over, colorIcon: Colors.teal, noticia: noticias[index]);
              } else {
                return CardImages(aviso: noticias[index]);
              }
            },
            itemCount: noticias.length),
      ),
    );
  }

  Widget _sinAvisos() {
    // _showToast('Sin conexión a internet');
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * .9,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SizedBox(height: size.height * .3),
          Center(
              child: Text('No se puede cargar avisos',
                  style: Theme.of(context).textTheme.headline6)),
        ],
      ),
    );
  }


  Widget _finAvisos() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Text('No hay mas avisos',
                    style: Theme.of(context).textTheme.headline1)),
          ),
        ],
      ),
    );
  }

   void _showToast(String msg) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(fontSize: 15.0),
        ),
      ),
    );
  }

  @override
  void dispose() {
    noticiasProvider.disposeStreams();
    super.dispose();
  }
}

