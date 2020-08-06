import 'package:flutter/material.dart';

import 'package:preferencia_usuario_app/src/pages/avisos/aviso_nuevo.dart';
import 'package:preferencia_usuario_app/src/pages/avisos/carousel_page.dart';
import 'package:preferencia_usuario_app/src/pages/avisos/aviso_editar.dart';
import 'package:preferencia_usuario_app/src/pages/avisos/video.dart';
import 'package:preferencia_usuario_app/src/pages/calificaciones/calificaciones_home.dart';
import 'package:preferencia_usuario_app/src/pages/calificaciones/cardex.dart';
import 'package:preferencia_usuario_app/src/pages/calificaciones/parciales.dart';
import 'package:preferencia_usuario_app/src/pages/home_page.dart';
import 'package:preferencia_usuario_app/src/pages/avisos/avisos_detalle_page.dart';
import 'package:preferencia_usuario_app/src/pages/avisos/avisos_page.dart';
import 'package:preferencia_usuario_app/src/pages/settings_page.dart';
import 'package:preferencia_usuario_app/src/pages/login/login_page.dart';

Map<String, WidgetBuilder> getAplicationRoutes(){

return <String, WidgetBuilder>{
        "/"     : (BuildContext contest) => NoticiasPage(),
        NewsPage.routeName     : ( BuildContext context ) => NewsPage(),
        AvisoNuevoPage.routeName : (BuildContext context) => AvisoNuevoPage(),
        AvisoEditarPage.routeName: (BuildContext context) => AvisoEditarPage(),
        NoticiasPage.routeName : (BuildContext context) => NoticiasPage(),
        NoticiasDetallePage.routeName : (BuildContext context) => NoticiasDetallePage(),
        LoginPage.routeName    : (BuildContext context) => LoginPage(),
        SettingsPage.routeName : (BuildContext context) => SettingsPage(),
        CalificacionesHomePage.routeName: (BuildContext context) => CalificacionesHomePage(),
        ParcialesPage.routeName : (BuildContext context) => ParcialesPage(),
        CardexPage.routeName : (BuildContext context) => CardexPage(),
        CarouselPage.routeName : (BuildContext context) => CarouselPage(),
        Video.routeName : (BuildContext context) => Video()
      };
}
