import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/controller/Banco.dart';
import 'package:whatsapp/data/repository/irepository_user.dart';
import 'package:whatsapp/data/service/authentication_service.dart';
import 'package:whatsapp/model/Usuario.dart';

import '../../service/database_service.dart';

class UserRepositoryImpl implements IReposioryUser {
  AuthenticationService _authenticationService;
  DatabaseService _databaseService;

  UserRepositoryImpl(this._authenticationService, this._databaseService);

  @override
  Future<String> loginUser(String email, String senha) async {
    try {
      final result = await _authenticationService.login(email, senha);
      return result;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  void getUserData() {
    // TODO: implement getUserData
  }

  @override
  void logoutUser() {
    // TODO: implement logoutUser
  }

  @override
  void verifyUserLogin() {
    // TODO: implement verifyUserLogin
  }

  @override
  Future<String?> cadastrarUsuario(Usuario usuario) async {
    try {
      final userCreated = await _authenticationService.cadastrarUsuario(usuario);
      if (userCreated != null) {
        final result = await _databaseService.salvarUsuario(
            usuario, userCreated.uid);
        return result;
      }
      return null;
    } catch (execption) {
      if (execption is FirebaseAuthException) {
        throw FirebaseAuthException(
            message: "email inválido,altere o email", code: '1');
      }
      rethrow;
    }
  }

  User? verificarUsuarioLogado() {
    User? user =  _authenticationService.verificarUsuarioLogado();
    return user;
  }
}