

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:whatsapp/helper/Constants.dart';
import 'package:whatsapp/model/Conversa.dart';
import 'package:whatsapp/model/Mensagem.dart';
import 'package:whatsapp/model/Usuario.dart';

import '../model/Contato.dart';

class Banco {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore =FirebaseFirestore.instance;
  Banco();
  final _controller =StreamController<QuerySnapshot>.broadcast();

  Future<String> login(String email, String senha)async{
      try{
        await auth.signInWithEmailAndPassword(email: email, password: senha,);
        return "Logando...";
      }catch(e){
         print(e);
         rethrow;
      }
  }

  recuperarMensagens(Mensagem mensagem) async{
         QuerySnapshot snapshot = await firestore.
         collection(Constants.COLLECTION_MENSAGEM_BD_NAME)
             .doc(mensagem.idRemetente)
            .collection(mensagem.idDestinatario)
             .get();

       return mensagem;
  }

  salvarDestinatarioMensagem (Mensagem mensagem) async{
    await  firestore.collection(Constants.COLLECTION_MENSAGEM_BD_NAME)
        .doc(mensagem.idDestinatario)
        .collection(mensagem.idRemetente)
        .add(mensagem.toMap());
  }

  Future<Usuario> recuperarUsuario(User user) async{

    Usuario usuario = Usuario();
           DocumentSnapshot dados = await firestore.collection(Constants.COLLECTION_USUARIO_BD_NAME).doc(user.uid).get();

          usuario.nome = dados.get("nome");
          usuario.email = dados.get("email");
          usuario.fotoPerfil=dados.get("fotoPerfil");

          return usuario;
  }

  User? verificarUsuarioLogado() {
    User? user =  auth.currentUser;
    return user;
  }

  Future<String> cadastrarUsuario(Usuario usuario)async {

        try{
         var  a= await auth.createUserWithEmailAndPassword(email: usuario.email, password: usuario.senha).
              whenComplete(() async => await salvarUsuario(usuario));
          return "Sucesso ao cadastrar";
        }catch(execption){
           if( execption is FirebaseAuthException){
             print(execption);
             throw FirebaseAuthException(message: "email inválido,altere o email", code: '1');
           }
           rethrow;
         }

        }

  Future<String>  salvarUsuario(Usuario usuario) async {
   try{
     final userLogado = await verificarUsuarioLogado();
      if(userLogado !=null){
        await firestore.collection(Constants.COLLECTION_USUARIO_BD_NAME)
            .doc(userLogado?.uid.toString())
            .set(usuario.toMap());
        return "usario salvo no fireestore";
      }
            return "usario null";
   }catch(e){
      if (kDebugMode) {
        print(e);
      }
      rethrow;
   }
 }

  Stream<QuerySnapshot> recuperarConversas( ) {
  var list =<Conversa>[];
   final userLogado =  verificarUsuarioLogado();
       var stream =  firestore.collection(Constants.COLLECTION_CONVERSA_BD_NAME)
          .doc(userLogado?.uid)
          .collection(Constants.COLLECTION_ULTIMA_CONVERSA_BD_NAME)
          .snapshots();

   stream.listen((event) {
         for (var element in event.docs) {
           var a = element["remetenteNome"];
           print("element $a");
            _controller.add(event);
           list.add(Conversa.fromMap(element));
         }

       },onError: (errp){
         print(errp.toString());
         throw errp;
       });
   return _controller.stream;
  }

  Future<Contato> recuperarContato(String id) async{
    Usuario user =  await Usuario().dadosUser(id);
    Contato contatoCv =Contato();
    contatoCv.nome=user.nome;
    contatoCv.email=user.email;
    contatoCv.foto=user.fotoPerfil;
    contatoCv.idContato=id;
    return contatoCv;
  }
    destroyListen(){
     _controller.close();
    }

  Future<void> deleteConversation(String idDestinatarioConversa) async {
       await firestore
           .collection(Constants.COLLECTION_CONVERSA_BD_NAME)
           .doc(verificarUsuarioLogado()?.uid)
           .collection(Constants.COLLECTION_ULTIMA_CONVERSA_BD_NAME)
           .doc(idDestinatarioConversa)
           .delete();
    }
  }




