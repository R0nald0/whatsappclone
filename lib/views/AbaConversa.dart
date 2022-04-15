import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/GeraRotas.dart';
import 'package:whatsapp/controller/Banco.dart';
import 'package:whatsapp/model/Contato.dart';
import 'package:whatsapp/model/Conversa.dart';
import 'package:whatsapp/model/Usuario.dart';


class AbaConversa extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>AbaConversaState();
}





class AbaConversaState extends State<AbaConversa> {

  String userLogado = "";
  final _controller =StreamController<QuerySnapshot>.broadcast();
  late String destinatarioId ;

  Stream<QuerySnapshot> _recuperarConversas(){

    Banco _bd = Banco();
     final stream =  _bd.firestore.collection("conversa")
         .doc(userLogado)
         .collection("utimaConversa")
         .snapshots();

    stream.listen((dados) {
        _controller.add(dados);
    });
    return _controller.stream;
  }

  _verificarUsuarioLogado() async {

     Banco auth = Banco() ;
     User? usuario =  await auth.auth.currentUser;
     if(usuario !=null){
         userLogado = usuario.uid.toString();
         print("user" + userLogado.toString());
         _recuperarConversas();
     }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verificarUsuarioLogado();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.close();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

         child: Column(
           children: <Widget>[
              listaStreamConversa(),
            //
           ],
         ),
      )
    );
  }


  listaConversas( QuerySnapshot query){
    return
       Expanded(
        child:ListView.builder(
            itemCount: query.docs.length,
            itemBuilder: (context,index){
                List<DocumentSnapshot> conversa = query.docs.toList();
                DocumentSnapshot conversaItem = conversa[index];


              return Card(
                borderOnForeground: false,
                margin: EdgeInsets.all(1),
                child: ListTile(
                  contentPadding: EdgeInsets.fromLTRB(16,8,16,8),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(conversaItem["fotoUrlRemetente"]),
                    backgroundColor: Colors.grey,
                    maxRadius: 35,
                  ),
                  trailing:Column(
                       children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 5,bottom: 15),
                          child: Text("1"),
                          ),

                         
                       ],
                      ),

                  title: Text(conversaItem["remetenteNome"],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    ),
                  ),
                  subtitle: Container(
                    child: conversaItem["tipo"]=="texto"?Text(conversaItem["UltimaMsg"])
                        :Padding(padding: EdgeInsets.only(right:225,top: 10),child:Icon(Icons.image_rounded) ,)
                  ),

                  onTap: () async{
                       destinatarioId = conversaItem["idDestinatario"];
                       Contato contatoCv =  await  Contato().recuperararContato(destinatarioId);
                       Navigator.pushNamed(
                           context,
                           GerarRotas.ROUTE_CONVERSA
                           ,arguments: contatoCv
                       );

                  },
                ),

              );
            }
        ) ,
      );

  }

  listaStreamConversa(){
    return StreamBuilder(
         stream: _controller.stream,
         builder:(context,AsyncSnapshot snapshot){

           switch(snapshot.connectionState){
             case ConnectionState.none:

             case ConnectionState.waiting:
               return Center(
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
                  return Center(
                    child: Text("Você ainda não tem conversas"),
                  );
               }

           }

           return Center(child: Text(""),);
         }
    );
  }
}