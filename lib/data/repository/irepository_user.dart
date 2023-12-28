import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/model/Usuario.dart';

abstract class IReposioryUser{
    void getUserData();
    User? verificarUsuarioLogado();
    logoutUser();
    Future<String> loginUser(String email, String senha);
    Future<String?> cadastrarUsuario(Usuario usuario);
}