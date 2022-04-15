import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/Conversa.dart';
import 'package:whatsapp/model/Mensagem.dart';
import 'package:whatsapp/model/Usuario.dart';

class Banco {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore =FirebaseFirestore.instance;

  Banco();

  login(Usuario usuario)async{

      await auth.signInWithEmailAndPassword(
     email: usuario.email,
      password: usuario.senha,
  );

      return usuario;
  }

  recuperarMensagens(Mensagem mensagem) async{
         QuerySnapshot snapshot = await firestore.
         collection("mensagen")
             .doc(mensagem.idRemetente)
          .collection(mensagem.idDestinatario).get();

       return mensagem;
  }



  salvarDestinatarioMensagem (Mensagem mensagem) async{
    await  firestore.collection("mensagen").doc(mensagem.idDestinatario)
        .collection(mensagem.idRemetente)
        .add(mensagem.toMap());
  }

  Future recuperarUsuario(User user) async{

    Usuario usuario = Usuario();
           DocumentSnapshot dados = await firestore.collection("usuario").doc(user.uid).get();

          usuario.nome = dados.get("nome");
          usuario.email = dados.get("email");
          usuario.fotoPerfil=dados.get("fotoPerfil");

          return usuario;
  }

  Future verificarUsuarioLogado() async{
    User? user = await auth.currentUser;

    return user;
  }



}
