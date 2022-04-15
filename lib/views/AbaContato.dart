import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/GeraRotas.dart';
import 'package:whatsapp/model/Contato.dart';
import 'package:whatsapp/model/Usuario.dart';

class AbaContato extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>AbaContatoState();

}

class AbaContatoState extends State<AbaContato> {

  String emaillUser = "";

   Future<List<Contato>> recuperarContatos() async{
      FirebaseFirestore bd = FirebaseFirestore.instance;

      QuerySnapshot snapshot  = await bd.collection("usuario").get();

         List<Contato> listContato = [];
         for(QueryDocumentSnapshot item  in snapshot.docs){
           if(item.get("email") == emaillUser) continue;

           Contato contato = Contato();
           contato.nome=item.get("nome");
           contato.email=item.get("email");
           contato.foto=item.get('fotoPerfil');
           contato.idContato=item.id;

           listContato.add(contato);
         }

         return listContato;
   }

   Future recuperarDados() async{
     FirebaseAuth auth = FirebaseAuth.instance;
     FirebaseFirestore bd = FirebaseFirestore.instance;

     DocumentSnapshot dados = await bd.collection("usuario").doc(auth.currentUser!.uid).get();

       emaillUser  = dados.get("email");

   }
   @override
  void initState() {
    // TODO: implement initState
    super.initState();

    recuperarDados();
    recuperarContatos();

  }
  @override
  Widget build(BuildContext context) {


     return Scaffold(
      body: FutureBuilder<List<Contato>>(
         future: recuperarContatos(),
        builder:(context,snapshot){
              String teste;
             switch(snapshot.connectionState){
               case ConnectionState.none:
                 break;
               case ConnectionState.waiting:
                 return Center(
                    child: CircularProgressIndicator(),
                 );
                 break;
               case ConnectionState.active:
                 break;


               case ConnectionState.done:
                 if(snapshot.hasData){

                    return

                          ListView.builder(

                            itemCount: snapshot.data!.length,
                            itemBuilder: (context,index){
                               List<Contato>? contatos = snapshot.data;
                               Contato contato = contatos![index];


                              return ListTile(
                                contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                leading: CircleAvatar(
                                  backgroundImage:NetworkImage(contato.foto),
                                  maxRadius: 30,
                                  backgroundColor: Colors.green,
                                ),

                                trailing: Icon(Icons.message_rounded,color: Colors.green),
                                title: Text(contato.nome),
                                subtitle: Text(contato.email),
                                onTap: (){
                                     Navigator.pushNamed(
                                         context,
                                         GerarRotas.ROUTE_CONVERSA
                                         ,arguments: contato
                                     );
                                },
                              );
                            }
                        );


                 } else{
                   return Center(
                      child: Text("Erro ao  Carregar os Contatos"),
                   );
                 }
                 break;
                 }
              return Center();
      }
      )
    );
  }
}