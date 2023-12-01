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

  Future recuperarUsuario(User user) async{

    Usuario usuario = Usuario();
           DocumentSnapshot dados = await firestore.collection("usuario").doc(user.uid).get();

          usuario.nome = dados.get("nome");
          usuario.email = dados.get("email");
          usuario.fotoPerfil=dados.get("fotoPerfil");

          return usuario;
  }

  Future verificarUsuarioLogado() async{
    User? user = await auth.currentUser;
    return user;
  }

  Future<String> cadastrarUsuario(String name,String email ,String password)async {

        try{
          await  auth.createUserWithEmailAndPassword(email: email, password: password)
              .then((value) =>(){
            var user = value.user;
            if(user != null){
              Map<String, dynamic> map = {
                "nome": name,
                "email": user.email,
              };
              firestore.collection("usuario")
                  .doc(user.uid.toString())
                  .set(map);
            }
          });
          return "Sucesso ao cadastrar";
        }catch(execption){
           if( execption is FirebaseAuthException){
             print(execption);
             throw FirebaseAuthException(message: "email inválido,altere o email", code: '1');
           }
           rethrow;
         }

        }
  }


