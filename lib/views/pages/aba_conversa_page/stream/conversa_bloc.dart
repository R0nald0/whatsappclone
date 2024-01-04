
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/model/Contato.dart';
import 'package:whatsapp/model/Conversa.dart';
import '../../../../data/repository/IContactRepository.dart';
import '../../../../data/repository/i_conversa_repository.dart';

class ConversaBloc extends Cubit<ConversaState> {

   final IConversaRepository _conversaRepository;
   final IContactRepository _contactRepository;
   ConversaBloc(this._conversaRepository, this._contactRepository) : super(ConversaInitialSate(conversas: []));

  Future<Contato> getContactData(String contactId) async{
     try{
      return  await _contactRepository.getContactData(contactId);
     }catch (exception){
       rethrow;
     }
   }
   getAllConversations() async {
    try{
         emit(ConvesarLoadingState(conversas:[]));
         await _conversaRepository.getAllConversations().listen((event) {
         emit(ConvesarLoadedState(conversas: event));
      });
     }catch(e){
        print(e);
        emit(ConvesarErrorState(errorMessenger:"Falha ao recuperar lista de conversas"));
     }
   }
   Future<void> deleteConversation(String idDestinatarioConversa,String remetenteId) async{
      try{
        emit(ConvesarLoadingState(conversas: []));
        await _conversaRepository.deleteConversation(idDestinatarioConversa,remetenteId);
        emit(ConvesarSucessState(sucessMessager: 'Conversa Deletada'));
      }catch(exeption){
        emit(ConvesarErrorState(errorMessenger: '${exeption} erro Deletada'));
      }
   }

   void destroyListen(){
     _conversaRepository.destroyListen();
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

class ConvesarSucessState extends ConversaState {
  final String sucessMessager;
  ConvesarSucessState({required this.sucessMessager}) : super(conversas :[]);

}

class ConvesarErrorState extends ConversaState {
  final errorMessenger ;
  ConvesarErrorState({required this.errorMessenger}) : super( conversas :[]);
}