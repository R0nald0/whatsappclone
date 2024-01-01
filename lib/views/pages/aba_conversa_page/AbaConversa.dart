

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/GeraRotas.dart';
import 'package:whatsapp/model/Contato.dart';
import 'package:whatsapp/model/Conversa.dart';
import 'package:whatsapp/views/pages/aba_conversa_page/stream/conversa_bloc.dart';



import '../../../main.dart';

class AbaConversa extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>AbaConversaState();
}

class AbaConversaState extends State<AbaConversa> {

  String userLogado = "";
  late String destinatarioId ;
  final conversaBloc = getIt.get<ConversaBloc>();

  @override
  void initState() {
    super.initState();
    conversaBloc.getAllConversations();
  }

  @override
  void dispose() {
    conversaBloc.destroyListen();
   super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
             //listaStreamConversa()
          listaBlocConversa()
         //
        ],
      )
    );
  }

  /*listaStreamConversa(){
    return  Expanded(
      child: StreamBuilder(
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
                }else if(querySnapshot.docs.isEmpty){
                  return const Center(
                    child: Text("Você ainda não tem conversas"),
                  );
                }

            }
            return const Center(child: Text(""),);
          }
      ),
    );
  }*/
  listaBlocConversa(){
    return  BlocBuilder(
          bloc: conversaBloc,
          builder:(context, state){
              if ( state is ConvesarLoadingState){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
               else if ( state is ConvesarLoadedState){
                return listaConversas(state.conversas);
              }
              else{
              return const Center(child: Text(""),);
             }
          }
      );
  }
 Widget listaConversas( List<Conversa> query){
    return
       Expanded(
        child:ListView.builder(
            itemCount: query.length,
            itemBuilder: (context,index){
             // List<DocumentSnapshot> conversa = query.docs.toList();
              Conversa conversaItem = query[index];

              return Dismissible(
                key: Key(conversaItem.idRemetente /*conversaItem["idDestinatario"]*/),
                onDismissed: (direction){
                  if(DismissDirection.endToStart == direction){
                         conversaBloc.deleteConversation(conversaItem.idDestinatario /*conversaItem["idDestinatario"]*/);
                  }
                },
                child: Card(
                  borderOnForeground: false,
                  margin: const EdgeInsets.all(1),
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(16,8,16,8),
                    leading: CircleAvatar(
                     // backgroundImage: NetworkImage(conversaItem["fotoUrlRemetente"]),
                      backgroundImage: NetworkImage(conversaItem.fotoUrl/*conversaItem["fotoUrlRemetente"]*/),
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

                    title:   Text(conversaItem.remetenteNome/*conversaItem["remetenteNome"]*/,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),
                    ),
                    subtitle: Container(
                      child:  conversaItem.tipo/*conversaItem["tipo"]*/=="texto"?Text(conversaItem.urlImagenConversa/*conversaItem["UltimaMsg"]*/)
                          :  const Padding(padding: EdgeInsets.only(right:225,top: 10),
                                   child:Icon(Icons.image_rounded) ,)
                    ),

                    onTap: () async{
                         destinatarioId = conversaItem.idDestinatario/*conversaItem["idDestinatario"]*/;
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