import '../../../../model/Mensagem.dart';

abstract class TelaConversaBlocState{}

class TelaConversaInitState extends TelaConversaBlocState{
  TelaConversaInitState();
}
class TelaConversaLoadingState extends TelaConversaBlocState{
  TelaConversaLoadingState();
}
class TelaConversaLoadedState extends TelaConversaBlocState{
  final Mensagem mensagem;
  TelaConversaLoadedState({required this.mensagem});
}

class TelaConversaErrortState extends TelaConversaBlocState{
  final String errorMessenger;
  TelaConversaErrortState({required this.errorMessenger});
}