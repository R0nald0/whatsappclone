import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/Banco.dart';
import 'package:whatsapp/model/Contato.dart';

import '../../../../main.dart';

class ContactBloc extends Cubit<ContactState>{
  final _repository = getIt.get<Banco>();
  ContactBloc() : super(ContactIniteState());

  getAllContacts() async{
    try{
      emit(ContactLoadingState());
      final list = await _repository.recuperarContatos();
      emit(ContactLoadedState(users: list));
    }catch(e){
        print(e);
        emit(ContactErrorState(erroMenseger: "não conseguimos carregar a lista de contatos, tente novamente"));
    }
  }
}

abstract class ContactState {
   ContactState();
}
 class ContactIniteState extends ContactState {
    ContactIniteState();
 }
 class ContactLoadingState extends ContactState {
     ContactLoadingState();
 }
 class ContactLoadedState extends ContactState {
    final List<Contato> users;
    ContactLoadedState({required this.users});

 }
 class ContactErrorState extends ContactState {
    final String erroMenseger ;
    ContactErrorState({ required this.erroMenseger});
 }
 //class ContactIniteState extends ContactState {}