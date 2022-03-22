import 'package:flutter/material.dart';

class Contato {
  late String _nome;
  late String _email;
  late String _foto;

  Contato(this._nome, this._email, this._foto);

  String get foto => _foto;

  set foto(String value) {
    _foto = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }
}