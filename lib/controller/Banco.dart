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

  Future<String> login(String email, String senha)async{
      try{
        await auth.signInWithEmailAndPassword(email: email, password: senha,);
        return "Logando...";
      }catch(e){
         print(e);
         throw e;
      }
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

  Future<Usuario> recuperarUsuario(User user) async{

    Usuario usuario = Usuario();
           DocumentSnapshot dados = await firestore.collection("usuario").doc(user.uid).get();

          usuario.nome = dados.get("nome");
          usuario.email = dados.get("email");
          usuario.fotoPerfil=dados.get("fotoPerfil");

          return usuario;
  }

  Future<User?> verificarUsuarioLogado() async{
    User? user = await auth.currentUser;
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
        await firestore.collection("usuario")
            .doc(userLogado?.uid.toString())
            .set(usuario.toMap());
        return "usario salvo no fireestore";
      }
            return "usario null";
   }catch(e){
      print(e);
      rethrow;
   }
 }

 Future<List<Conversa>> recuperarConversas( ) async{
    final userLogado = await verificarUsuarioLogado();
    if(userLogado != null){
      Banco _bd = Banco();
      final stream =  await _bd.firestore.collection("conversa")
          .doc(userLogado.uid)
          .collection("utimaConversa")
          .snapshots();

       stream.listen((event) {
         print("event ${event}");
       });
    }
    return [];
    }

  }


