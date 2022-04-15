import 'package:flutter/material.dart';
import 'package:whatsapp/controller/Banco.dart';

import 'Usuario.dart';

class Contato {
  late String _nome;
  late String _email;
  late String _foto;
  late String _idContato;

  Contato();

  Future recuperararContato(String id) async{
    Usuario user =  await Usuario().dadosUser(id);
    Contato contatoCv =Contato();
    contatoCv.nome=user.nome;
    contatoCv.email=user.email;
    contatoCv.foto=user.fotoPerfil;
    contatoCv.idContato=id;
    return contatoCv;
  }

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

  String get idContato => _idContato;

  set idContato(String value) {
    _idContato = value;
  }
}
