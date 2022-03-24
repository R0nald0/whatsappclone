import 'package:flutter/material.dart';
import 'package:whatsapp/views/Home.dart';
import 'package:whatsapp/views/Login.dart';
import 'package:whatsapp/views/cadastro.dart';

class GerarRotas {
  static const ROUTE_HOME = "/home";
  static const ROUTE_LOGIN = "/login";
  static const ROUTE_CADASTRO = "/cadastro";

  static Route<dynamic>? inicializarRotas(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Login());
        break;

      case ROUTE_LOGIN:
        return MaterialPageRoute(builder: (_) => Login());
        break;
      case ROUTE_HOME:
        return MaterialPageRoute(builder: (_) => Home());
        break;

      case ROUTE_CADASTRO:
        return MaterialPageRoute(builder: (_) => cadastro());
        break;

      default:
        _erroRoute();
    }
  }

  static Route<dynamic>? _erroRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("TELA DE ERRO"),
        ),
        body: Center(
          child: Text("Erro de Rota"),
        ),
      );
    });
  }
}
