import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {

  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }


  // GET y SET del _colorSecundario
  get darkMode {
    return _prefs.getBool("darkMode") ?? false;
  }

  set darkMode( bool value ) {
    _prefs.setBool("darkMode", value);
  }


  // GET y SET del nombreUsuario
  get nombreUsuario {
    return _prefs.getString("nombreUsuario") ?? '';
  }

  set nombreUsuario( String value ) {
    _prefs.setString("nombreUsuario", value);
  }

// GET y SET del nick
  get nick {
    return _prefs.getString("nick") ?? '';
  }

  set nick( String nick ) {
    _prefs.setString("nick", nick);
  }
  // GET y SET del nick
  get phrase {
    return _prefs.getString("phrase") ?? '';
  }

  set phrase( String phrase ) {
    _prefs.setString("phrase", phrase);
  }

  ////////////////// FCM 
  // GET y SET del TokenFCM
  get tokenFCM {
    return _prefs.getString("tokenFCM") ?? null;
  }

  set tokenFCM( String value ) {
    _prefs.setString("tokenFCM", value);
  }

  // Conocer si el token se tiene en prefs
  get tokenFCMSaved {
    return _prefs.getInt("tokenFCMSaved") ?? 0;
  }

  set tokenFCMSaved( int value ) {
    _prefs.setInt("tokenFCMSaved", value);
  }

  get tokenFCMSavedTime {
    return _prefs.getString("tokenFCMSavedTime") ?? '0';
  }

  set tokenFCMSavedTime( String value ) {
    _prefs.setString("tokenFCMSavedTime", value);
  }

  get tokenLogin{
    return _prefs.getString("tokenLogin") ?? "token";
  }
  set tokenLogin(String token){
    _prefs.setString("tokenLogin", token);
  }

  get loggedIn{
    return _prefs.getInt("loggedIn")?? 0;
  }

  set loggedIn(int loggedIn){
    _prefs.setInt("loggedIn", loggedIn);
  }

  get userRol{
    return _prefs.getString("userRol") ?? 'USER_ROLE';
  }

  set userRol(String role){
    _prefs.setString("userRol", role);
  }
  get notAvisos{
    return _prefs.getBool("notAvisos") ?? false;
  }

  set notAvisos(bool notAvisos){
    _prefs.setBool("notAvisos", notAvisos);
  }

}


