import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../helper/Constants.dart';
import '../../model/Usuario.dart';

class DatabaseService{
  FirebaseFirestore _firestore ;
  DatabaseService(this._firestore);

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
}