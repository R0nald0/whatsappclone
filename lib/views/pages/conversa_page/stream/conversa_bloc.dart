
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/model/Conversa.dart';

class ConversaBloc extends Cubit<ConversaState> {
  ConversaBloc() : super(ConversaInitialSate(conversas: []));

}

abstract class ConversaState {
    List<Conversa> listConversa =<Conversa>[];
    ConversaState({required this.listConversa});
}

class ConversaInitialSate extends ConversaState{
  List<Conversa> conversas = <Conversa>[];
  ConversaInitialSate({required this.conversas}) : super(listConversa:conversas);
}

class ConvesarLoadingState extends ConversaState {
   final listConversa ;
  ConvesarLoadingState({required this.listConversa}) : super( listConversa:listConversa);

}

class ConvesarLoadedState extends ConversaState {
   final List<Conversa> listConversa ;
  ConvesarLoadedState({required this.listConversa}) : super(listConversa :listConversa);

}

class ConvesarErrorState extends ConversaState {
  List<Conversa> listConversa ;
  final errorMessenger ;
  ConvesarErrorState({required this.listConversa,required this.errorMessenger}) : super( listConversa : listConversa);
}