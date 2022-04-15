
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:whatsapp/controller/Banco.dart';

class Usuario {
  late String _nome;
  late String _email;
  late String _senha;
  late String _fotoPerfil ;

  Usuario();


   Future<Usuario> dadosUser(String idUsuario ) async {
    Banco bd = Banco();
       DocumentSnapshot snapshot = await bd.firestore.collection("usuario").doc(idUsuario).get();

       Usuario usuario = Usuario();
        usuario.nome = snapshot.get("nome");
        usuario.fotoPerfil =snapshot.get("fotoPerfil");
        usuario.email=snapshot.get("email");

        return usuario;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome": this.nome,
      "email": this.email,
      "fotoPerfil" :this._fotoPerfil
    };
    return map;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get fotoPerfil => _fotoPerfil;

  set fotoPerfil(String value) {
    _fotoPerfil = value;
  }
}
