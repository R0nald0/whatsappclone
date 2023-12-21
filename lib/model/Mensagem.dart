import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/controller/Banco.dart';

import '../helper/Constants.dart';

class Mensagem {
  late String _idRemetente;
  late String _msg;
  late String _url;
  late String _idDestinatario;
  late String _tipo;
  late String _data;
  late String _time;

  String get time => _time;

  set time(String value) {
    _time = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }

  Mensagem();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idRemetente": this._idRemetente,
      "url": this.url,
      "tipo": this.tipo,
      "mensagem": this._msg,
      "idDestinatario": this._idDestinatario,
      "data": this.data,
      "time": this._time
    };

    return map;
  }


  String get idRemetente => _idRemetente;

  set idRemetente(String value) {
    _idRemetente = value;
  }

  String get msg => _msg;

  set msg(String value) {
    _msg = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get idDestinatario => _idDestinatario;

  set idDestinatario(String value) {
    _idDestinatario = value;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }
}
