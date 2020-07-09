import 'dart:async';

import 'package:flutter/material.dart';
import 'package:preferencia_usuario_app/src/blocs/provider.dart';
import 'package:preferencia_usuario_app/src/providers/login_provider.dart';
import 'package:preferencia_usuario_app/src/shared_prefs/preferencias_usuario.dart';

class LoginPage extends StatefulWidget {
  static final String routeName = 'login-page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  LoginProvider loginProvider = LoginProvider();
  final prefs = new PreferenciasUsuario();
  bool _showPassword = false;
  int _state = 0;
  Animation _animation;
  AnimationController _controller;
  GlobalKey _globalKey = GlobalKey();
  double _width = double.maxFinite;
  Color _colorButton;
  String _msg = '';

  @override
  Widget build(BuildContext context) {
    _colorButton = Theme.of(context).primaryColor;
    return Scaffold(
      body: Stack(
        children: <Widget>[_crearFondo(context), _loginForm(context)],
      ),
    );
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.4,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/img/tec.jpg'), fit: BoxFit.cover),
        ));
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(child: Container(height: size.height * 0.3)),
          Container(
            width: size.width * 0.85,
            padding: EdgeInsets.symmetric(vertical: 50.0),
            margin: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: <Widget>[
                Text('Ingreso', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 20.0),
                _crearUsuario(context, bloc),
                SizedBox(height: 20.0),
                _crearPassword(context, bloc),
                SizedBox(height: 20.0),
                _crearBoton(bloc)
              ],
            ),
          ),
          Text('¿Olvido la contraseña?'),
          SizedBox(height: 100.0)
        ],
      ),
    );
  }

  Widget _crearUsuario(BuildContext context, LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.userStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  icon:
                      Icon(Icons.person, color: Theme.of(context).accentColor),
                  hintText: 'Usuario',
                  labelText: 'Usuario',
                  counterText: snapshot.data,
                  errorText: snapshot.error),
              onChanged: (value) => bloc.changeUser(value),
            ),
          );
        });
  }

  Widget _crearPassword(BuildContext context, LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.passwordStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              obscureText: !this._showPassword,
              decoration: InputDecoration(
                icon: Icon(Icons.lock, color: Theme.of(context).accentColor),
                labelText: 'Contraseña',
                errorText: snapshot.error,
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: this._showPassword
                        ? Theme.of(context).accentColor
                        : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() => this._showPassword = !this._showPassword);
                  },
                ),
              ),
              onChanged: bloc.changePassword,
            ),
          );
        });
  }

  Widget _crearBoton(LoginBloc bloc) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: StreamBuilder(
          stream: bloc.formValidStream,
          builder: (context, snapshot) {
            return PhysicalModel(
              elevation: 8,
              shadowColor: Colors.lightGreenAccent,
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
                  onPressed: snapshot.hasData
                      ? () {
                          setState(() {
                            if (_state == 0) {
                              animateButton(context);
                            }
                          });
                        }
                      : null,
                  elevation: 4,
                  color: _colorButton,
                  disabledColor: Colors.yellow[200],
                ),
              ),
            );
          }),
    );
  }

  setUpButtonChild() {
    if (_state == 0) {
      _colorButton = Theme.of(context).primaryColor;
      return Text(
        'Ingresar',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
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

    _animation = Tween(begin: 0.0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {
          _width = initialWidth - ((initialWidth - 48) * _animation.value);
        });
      });
    _controller.forward();

    setState(() {
      _state = 1;
    });

    var resp = await _login(context);
    setState(() {
      _state = resp;
      if (resp == 3) {
        _showToast(context);
        Timer(Duration(milliseconds: 4200), () {
          if(_state != 0){
          setState(() {
            _state = 0;
            // _width = double.infinity;
            animateResetButton();
          });
          }
        });
      } else {
        Timer(Duration(milliseconds: 1000), () {
          Navigator.pushReplacementNamed(context, 'news');
        });
      }
    });
  }

  void animateResetButton() {
    final sizeScreen = MediaQuery.of(context).size;
    _controller =
        AnimationController(duration: Duration(milliseconds:300), vsync: this);
    
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          // _width = double.infinity;
          _width = (sizeScreen.width*0.8) * _animation.value;
        });
      });
    _controller.forward();
  }

  Future<int> _login(BuildContext context) async {
    print('=============== LOGIN');
    var resp = 3;
    final bloc = Provider.of(context);
    final usuario = await loginProvider.getLogin(bloc.user, bloc.password);
    if (usuario.ok == true) {
      if (usuario.active == false) {
        _msg = 'El usuario no se encuentra activo';
      } else {
        _msg = 'Exito';
        resp = 2;
        prefs.loggedIn = 1;
        prefs.tokenLogin = usuario.token;
        prefs.userRol = usuario.role;
        prefs.nombreUsuario = usuario.name;
      }
    } else {
      _msg = usuario.message;
    }
    print('======================LOGIN RESp'+resp.toString());
    return resp;
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(
          _msg,
          style: TextStyle(fontSize: 15.0),
        ),
        action: SnackBarAction(
            // textColor: Colors.blue,
            label: 'OK',
            onPressed: () {
              if(_state != 0){
              setState(() {
                scaffold.hideCurrentSnackBar();
                _state = 0;
                animateResetButton();
              });
              }
            }),
      ),
    );
  }
}
