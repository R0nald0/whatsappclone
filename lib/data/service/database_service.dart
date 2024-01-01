import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../helper/Constants.dart';
import '../../model/Conversa.dart';
import '../../model/Usuario.dart';

class DatabaseService{
   final FirebaseFirestore _firestore ;
   DatabaseService(this._firestore);
   final _controller =StreamController<List<Conversa>>.broadcast();

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
    await _firestore
        .collection(Constants.COLLECTION_CONVERSA_BD_NAME)
        .doc(uuidUser)
        .collection(Constants.COLLECTION_ULTIMA_CONVERSA_BD_NAME)
        .doc(idDestinatarioConversa)
        .delete()
        .whenComplete(() =>
        _firestore.
        collection(Constants.COLLECTION_MENSAGEM_BD_NAME)
            .doc(uuidUser)
            .collection(idDestinatarioConversa)
    );
  }
}