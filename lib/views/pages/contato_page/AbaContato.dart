
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/GeraRotas.dart';
import 'package:whatsapp/helper/Helper.dart';
import 'package:whatsapp/model/Contato.dart';
import 'package:whatsapp/views/pages/contato_page/store/contact_bloc.dart';

class AbaContato extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>AbaContatoState();
}

class AbaContatoState extends State<AbaContato> {

  final contactoBloc= ContactBloc();

   @override
  void initState() {
    super.initState();
   contactoBloc.getAllContacts();
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: BlocConsumer<ContactBloc,ContactState>(
          bloc:contactoBloc,
          listener: (BuildContext context, ContactState state) {
             if(state is ContactErrorState){
               Helper.mostrarSnackBar(context,state.erroMenseger);
             }
          },
          builder:(context,state){
             if(state is ContactLoadingState) {
               return const Center(
                 child: CircularProgressIndicator(),
               );
             }
             if(state is ContactLoadedState){
               return
                 ListView.builder(
                     itemCount: state.users.length,
                     itemBuilder: (context,index){
                       Contato contato = state.users[index];
                       return ListTile(
                         contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                         leading: CircleAvatar(
                           backgroundImage:NetworkImage(contato.foto),
                           maxRadius: 30,
                           backgroundColor: Colors.green,
                         ),

                         trailing: const Icon(Icons.message_rounded,color: Colors.green),
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
             }else{
               return  Center(
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     const Text("Algo deu errado :(" ),
                     IconButton.outlined(
                         onPressed:() => contactoBloc.getAllContacts(),
                         icon: const Icon(Icons.refresh_outlined,),
                         color: const Color(0xFFFF9000)
                     ),
                   ],
                 ),
               );
             }
         },
      )
    );
  }
}