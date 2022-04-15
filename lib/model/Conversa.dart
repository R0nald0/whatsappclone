import 'package:flutter/material.dart';
import 'package:whatsapp/controller/Banco.dart';
import 'package:whatsapp/model/Usuario.dart';

class Conversa {
  late String _idDestinatario;
  late String _idRemetente;
  late String _remetenteNome;
  late String _msg;
  late String _fotoUrl;
  late String _tipo;
  late String _urlImagenConversa;
  late String _data;

  Conversa();

  Future salvarConversaBd() async {
    Banco bd = Banco();

    await bd.firestore
        .collection("conversa")
        .doc(this.idRemetente)
        .collection("utimaConversa")
        .doc(this.idDestinatario)
        .set(this.toMap());
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "remetenteNome": this.remetenteNome,
      "UltimaMsg": this.msg,
      "fotoUrlRemetente": this.fotoUrl,
      "idRemetente": this.idRemetente,
      "idDestinatario": this.idDestinatario,
      "tipo": this.tipo,
      "_urlImagenConversa": this.urlImagenConversa
    };
    return map;
  }


  String get data => _data;

  set data(String value) {
    _data = value;
  }

  String get urlImagenConversa => _urlImagenConversa;

  set urlImagenConversa(String value) {
    _urlImagenConversa = value;
  }

  String get idDestinatario => _idDestinatario;

  set idDestinatario(String value) {
    _idDestinatario = value;
  }

  String get fotoUrl => _fotoUrl;

  set fotoUrl(String value) {
    _fotoUrl = value;
  }

  String get msg => _msg;

  set msg(String value) {
    _msg = value;
  }

  String get remetenteNome => _remetenteNome;

  set remetenteNome(String value) {
    _remetenteNome = value;
  }

  String get idRemetente => _idRemetente;

  set idRemetente(String value) {
    _idRemetente = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }
}
