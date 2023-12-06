
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/Banco.dart';
import 'package:whatsapp/model/Contato.dart';
import 'package:whatsapp/model/Conversa.dart';

class ConversaBloc extends Cubit<ConversaState> {
   final _banco = Banco();
   final _controller = StreamController<QuerySnapshot>.broadcast();
  ConversaBloc() : super(ConversaInitialSate(conversas: []));


   Stream<QuerySnapshot>  getAllConversations() {
   // try{
   //  emit(ConvesarLoadingState(conversas:[]));

     // var listConversations = <Conversa>[];
     //  print("lista de conversas ${ listConversations.length}");
    //  emit(ConvesarLoadedState(conversas: []));
    // }catch(e){
    //    print(e);
    //    emit(ConvesarErrorState(conversas:[], errorMessenger:"Falha ao recuperar lista de conversas"));
    //    rethrow;
    // }
    return  _banco.recuperarConversas();
   }

  Future<Contato> getContactData(String idDestinatario) async{
     return await _banco.recuperarContato(idDestinatario);
    }
   Future<void> deleteConversation(String idDestinatarioConversa) async{
       await _banco.deleteConversation(idDestinatarioConversa);
   }
}



abstract class ConversaState {
    List<Conversa> conversas =<Conversa>[];
    ConversaState({required this.conversas});
}

class ConversaInitialSate extends ConversaState{
  List<Conversa> conversas = <Conversa>[];
  ConversaInitialSate({required this.conversas}) : super(conversas:conversas);
}

class ConvesarLoadingState extends ConversaState {
   final conversas ;
  ConvesarLoadingState({required this.conversas}) : super( conversas:conversas);

}

class ConvesarLoadedState extends ConversaState {
   final List<Conversa> conversas ;
  ConvesarLoadedState({required this.conversas}) : super(conversas :conversas);

}

class ConvesarErrorState extends ConversaState {
  List<Conversa> conversas ;
  final errorMessenger ;
  ConvesarErrorState({required this.conversas,required this.errorMessenger}) : super( conversas : conversas);
}