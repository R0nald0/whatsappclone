import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:whatsapp/data/service/storage_service.dart';
import 'package:whatsapp/helper/Constants.dart';

import '../../model/Usuario.dart';

class AuthenticationService{
  final FirebaseAuth _auth ;

  AuthenticationService(this._auth);

  Future<String> login(String email, String senha)async{
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      return "Logando...";
    }catch(e){
      print(e);
      rethrow;
    }
  }

  User? verificarUsuarioLogado() {
    User? user =  _auth.currentUser;
    return user;
  }

  Future<User?> cadastrarUsuario(Usuario usuario)async {
    try{
      final idUser = await _auth.createUserWithEmailAndPassword(email: usuario.email, password: usuario.senha);
      return  idUser.user;
    }catch(execption){
      if( execption is FirebaseAuthException){
        print(execption);
        throw FirebaseAuthException(message: "email inválido,altere o email", code: '1');
      }
      rethrow;
    }
  }


  void logout(){
    _auth.signOut();
  }
}