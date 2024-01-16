import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/model/Usuario.dart';

abstract class IReposioryUser{
    Future<Usuario> getUserData();
    User? verificarUsuarioLogado();
    Future<String> createImage(String imagePath,String idLoggedUser);
    logoutUser();
    Future<String> loginUser(String email, String senha);
    Future<String?> cadastrarUsuario(Usuario usuario);
    Future<Usuario?> upadate(Usuario usuario);
}