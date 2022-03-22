import 'package:flutter/material.dart';

class Conversa {
  late String _remetenteNome;
  late String _msg;
  late String _fotoUrl;

  Conversa(this._remetenteNome,this._msg,this._fotoUrl);

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
}