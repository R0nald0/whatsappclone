
import 'package:flutter/material.dart';
import 'package:whatsapp/views/Home.dart';
import 'package:whatsapp/views/Login.dart';
import 'package:whatsapp/views/cadastro.dart';
import 'package:whatsapp/views/telaConfiguracao.dart';
import 'package:whatsapp/views/telaConversa.dart';

import 'model/Contato.dart';

class GerarRotas {
  static const ROUTE_HOME = "/home";
  static const ROUTE_LOGIN = "/login";
  static const ROUTE_CADASTRO = "/cadastro";
  static const ROUTE_CONFIG ="/configuracao";
  static const ROUTE_CONVERSA ="/conversa";

  static var args;

  static Route<dynamic>? inicializarRotas(RouteSettings settings) {

    args = settings.arguments;

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

      case ROUTE_CONFIG:
         return MaterialPageRoute(builder: (context) =>TelaConfiguracao() );
            break;

      case ROUTE_CONVERSA:
        return MaterialPageRoute(builder: (context)=> TelaConversa(args)
        );
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
