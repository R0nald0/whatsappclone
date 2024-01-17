import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/data/repository/irepository_user.dart';
import 'package:whatsapp/data/service/authentication_service.dart';
import 'package:whatsapp/model/Usuario.dart';
import '../../../helper/Constants.dart';
import '../../service/database_service.dart';
import '../../service/storage_service.dart';

class UserRepositoryImpl implements IReposioryUser {
  final AuthenticationService _authenticationService;
  final DatabaseService _databaseService;
  final StorageService  _storageService;

  UserRepositoryImpl(this._authenticationService, this._databaseService, this._storageService);

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
  Future<Usuario> getUserData() {
     var user = verificarUsuarioLogado();
     if(user !=null){
      final userLogged =_databaseService.recuperarUsuario(user);
        return userLogged;
     }
     else{
       logoutUser();
       throw Exception("usuário deslogado");
     }
  }

  @override
  void logoutUser() {
    _authenticationService.logout();
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

  @override
  Future<String> createImage(String imagePath,String idLoggedUser) async {
    try{
      return  await _storageService.saveAndReturnImage(
          Constants.COLLECTION_STORAGE_FOTO_PERFIL,
          imagePath,
          idLoggedUser
      );
    }catch(e){
      rethrow;
    }
  }

  @override
  User? verificarUsuarioLogado() {
    User? user =  _authenticationService.verificarUsuarioLogado();
    if(user !=null){
       return user;
    }
    return null;
  }

  @override
  Future<Usuario?> upadate(Usuario usuario) async {
     try{
       final user  = verificarUsuarioLogado();
        if(user !=null){
            await _databaseService.updateUser(usuario, user.uid);
            return await _databaseService.recuperarUsuario(user);
        }
        return null;
     }catch(exception){
       print(exception);
       rethrow;
     }
  }
}