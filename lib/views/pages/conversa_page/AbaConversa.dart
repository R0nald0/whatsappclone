import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/GeraRotas.dart';
import 'package:whatsapp/controller/Banco.dart';
import 'package:whatsapp/model/Contato.dart';
import 'package:whatsapp/views/pages/cadastro_page/stream/cadastro_bloc.dart';
import 'package:whatsapp/views/pages/conversa_page/stream/conversa_bloc.dart';

import '../../../model/Conversa.dart';

class AbaConversa extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>AbaConversaState();
}

class AbaConversaState extends State<AbaConversa> {

  String userLogado = "";
  late String destinatarioId ;
  final conversaBloc = ConversaBloc();
  Banco db = Banco() ;


  _verificarUsuarioLogado() async {
     Banco auth = Banco() ;
     User? usuario =  await auth.auth.currentUser;
     if(usuario !=null){
         userLogado = usuario.uid.toString();
     }
  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
  }

  @override
  void dispose() {
    db.destroyListen();
   super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
           listaStreamConversa(),
         //
        ],
      )
    );
  }

  listaStreamConversa(){
    return  StreamBuilder(
        stream: conversaBloc.getAllConversations(),
        builder:(context,AsyncSnapshot snapshot){

          switch(snapshot.connectionState){
            case ConnectionState.none:

            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
              break;
            case ConnectionState.active:

            case ConnectionState.done:
              QuerySnapshot querySnapshot =snapshot.data;
              if(snapshot.hasData ){

                print("data" + querySnapshot.docs.length.toString());
                return listaConversas(querySnapshot);
              }else if(querySnapshot.docs.length == 0){
                return const Center(
                  child: Text("Você ainda não tem conversas"),
                );
              }

          }

          return Center(child: Text(""),);
        }
    );
  }
 Widget listaConversas( QuerySnapshot query){
    return
       Expanded(
        child:ListView.builder(
            itemCount: query.docs.length,
            itemBuilder: (context,index){
              List<DocumentSnapshot> conversa = query.docs.toList();
              DocumentSnapshot conversaItem = conversa[index];

              return Dismissible(
                key: Key(conversaItem["idDestinatario"]),
                onDismissed: (direction){
                  if(DismissDirection.endToStart == direction){
                         conversaBloc.deleteConversation(conversaItem["idDestinatario"]);
                  }
                },
                child: Card(
                  borderOnForeground: false,
                  margin: const EdgeInsets.all(1),
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(16,8,16,8),
                    leading: CircleAvatar(
                     // backgroundImage: NetworkImage(conversaItem["fotoUrlRemetente"]),
                      backgroundImage: NetworkImage(conversaItem["fotoUrlRemetente"]),
                      backgroundColor: Colors.grey,
                      maxRadius: 35,
                    ),

                    trailing:const Column(
                         children: <Widget>[
                            Padding(padding: EdgeInsets.only(top: 5,bottom: 15),
                            child: Text("1"),
                            ),
                         ],
                        ),

                    title:   Text(conversaItem["remetenteNome"],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),
                    ),
                    subtitle: Container(
                      child:  conversaItem["tipo"]=="texto"?Text(conversaItem["UltimaMsg"])
                          :  const Padding(padding: EdgeInsets.only(right:225,top: 10),
                                   child:Icon(Icons.image_rounded) ,)
                    ),

                    onTap: () async{
                         destinatarioId = conversaItem["idDestinatario"];
                         Contato contatoCv =  await conversaBloc.getContactData(destinatarioId);
                         Navigator.pushNamed(
                             context,
                             GerarRotas.ROUTE_CONVERSA
                             ,arguments: contatoCv
                         );
                    },
                  ),

                ),
              );
            }
        ) ,
      );

  }


}