import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../helper/Constants.dart';
import '../../model/Contato.dart';
import '../../model/Conversa.dart';
import '../../model/Mensagem.dart';
import '../../model/Usuario.dart';

class DatabaseService{
   final FirebaseFirestore _firestore ;

   DatabaseService(this._firestore);
   final _controller =StreamController<List<Conversa>>.broadcast();
   final _controllerConversa =StreamController<List<Mensagem>>.broadcast();

   Future<String> salvarUsuario(Usuario usuario,String uudiUser) async {
    try{
        await _firestore.collection(Constants.COLLECTION_USUARIO_BD_NAME)
            .doc(uudiUser)
            .set(usuario.toMap());
        return "Usuário Cadastrado...";
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      throw Exception("erro ao salvar usuario no banco");
    }
  }

   Stream<List<Conversa>> recuperarConversas(String uuidUser ) {

    _firestore.collection(Constants.COLLECTION_CONVERSA_BD_NAME)
         .doc(uuidUser)
         .collection(Constants.COLLECTION_ULTIMA_CONVERSA_BD_NAME)
         .snapshots().listen((event) {
          final list = event.docs.map((element) => Conversa.fromMap(element)).toList();
           _controller.add(list);
        });
       return _controller.stream;
     }

   Future<void> deleteConversation(String idDestinatarioConversa,String uuidUser) async {

   await _firestore.collection(Constants.COLLECTION_MENSAGEM_BD_NAME)
        .doc(uuidUser)
        .collection(idDestinatarioConversa)
        .get().then((value){
        var map   = value.docs.map((e) => Mensagem.fromQuerySnap(e)).toList();
        map.forEach((element) {
          _firestore.collection(Constants.COLLECTION_MENSAGEM_BD_NAME)
            .doc(uuidUser)
            .collection(idDestinatarioConversa)
            .doc(element.idMensagem)
              .delete();
        });
         _firestore
            .collection(Constants.COLLECTION_CONVERSA_BD_NAME)
            .doc(uuidUser)
            .collection(Constants.COLLECTION_ULTIMA_CONVERSA_BD_NAME)
            .doc(idDestinatarioConversa)
            .delete();
   });
  }

  Future<List<Contato>> recuperarContatos(String emailUserLogged) async{

     QuerySnapshot snapshot  = await _firestore.collection(Constants.COLLECTION_USUARIO_BD_NAME).get();
     List<Contato> listContato = [];
     for(QueryDocumentSnapshot item  in snapshot.docs){
       if(item.get("email") == emailUserLogged) continue;

       Contato contato = Contato();
       contato.nome=item.get("nome");
       contato.email=item.get("email");
       contato.foto=item.get('fotoPerfil');
       contato.idContato=item.id;

       listContato.add(contato);
     }
     return listContato;
   }

   Future<Usuario> recuperarUsuario(User user) async{

     Usuario usuario = Usuario();
     DocumentSnapshot dados = await _firestore.collection(Constants.COLLECTION_USUARIO_BD_NAME).doc(user.uid).get();

     usuario.nome = dados.get("nome");
     usuario.email = dados.get("email");
     usuario.fotoPerfil=dados.get("fotoPerfil");

     return usuario;
   }

   Future<Contato> recuperarDadoContato(String id) async{
     Usuario user =  await Usuario().dadosUser(id);
     Contato contatoCv =Contato();
     contatoCv.nome=user.nome;
     contatoCv.email=user.email;
     contatoCv.foto=user.fotoPerfil;
     contatoCv.idContato=id;
     return contatoCv;
   }

   Stream<List<Mensagem>> adicionarListenerMensagens(String idUserLogado ,String idDestinatario) {
     var stream = _firestore
         .collection(Constants.COLLECTION_MENSAGEM_BD_NAME)
         .doc(idUserLogado)
         .collection(idDestinatario)
         .orderBy("time", descending: false)
         .snapshots().listen((event) {
           final list = event.docs.map((element) =>Mensagem.fromMap(element)).toList();
            _controllerConversa.add(list);
         });

     return _controllerConversa.stream;
   }

   Future salvarRemetenteMensagem (Mensagem mensagem) async{
     await  _firestore
         .collection(Constants.COLLECTION_MENSAGEM_BD_NAME)
         .doc(mensagem.idRemetente)
         .collection(mensagem.idDestinatario)
         .doc(mensagem.idMensagem)
         // .doc(Constants.COLLECTION_MENSAGEM_BD_NAME)
         .set(mensagem.toMap());
         //.add(mensagem.toMap());
   }

   Future  salvarDestinatarioMensagem (Mensagem mensagem) async{
     await  _firestore
         .collection(Constants.COLLECTION_MENSAGEM_BD_NAME)
         .doc(mensagem.idDestinatario)
         .collection(mensagem.idRemetente)
         .doc(mensagem.idMensagem)
     // .doc(Constants.COLLECTION_MENSAGEM_BD_NAME)
         .set(mensagem.toMap());

     //.doc(Constants.COLLECTION_MENSAGEM_BD_NAME)
         // .set(mensagem.toMap());
        // .add(mensagem.toMap());
   }

   Future salvarUltimaMensagemBd(Conversa conversa) async {
     await _firestore
         .collection(Constants.COLLECTION_CONVERSA_BD_NAME)
         .doc(conversa.idRemetente)
         .collection(Constants.COLLECTION_ULTIMA_CONVERSA_BD_NAME)
         .doc(conversa.idDestinatario)
         .set(conversa.toMap());
   }

   destroyListenser(){
      _controllerConversa.close();
      _controller.close();
   }

   Future<void> updateUser(Usuario usuario,String id) async{
     try{
       await _firestore
           .collection(Constants.COLLECTION_USUARIO_BD_NAME)
           .doc(id).update(usuario.toMap());
     }catch(exception){
       print(exception);
       rethrow;
     }
   }

}