import 'package:whatsapp/model/Contato.dart';

import '../../../../model/Mensagem.dart';

abstract class TelaConversaBlocState{
   final Contato? contato;
   TelaConversaBlocState({required this.contato});
}

class TelaConversaInitState extends TelaConversaBlocState{
   TelaConversaInitState():super(contato: null);
}
class TelaConversaLoadingState extends TelaConversaBlocState{
  TelaConversaLoadingState():super(contato: null);
}

class TelaConversaLoadingImageState extends TelaConversaBlocState{
  TelaConversaLoadingImageState():super(contato: null);
}

class TelaConversaLoadedContatoState extends TelaConversaBlocState{
  final Contato contato;
  TelaConversaLoadedContatoState({required this.contato}) :super(contato: contato);
}

class TelaConversaLoadedMessangetState extends TelaConversaBlocState{
  final List<Mensagem> mensagem;
  TelaConversaLoadedMessangetState({required this.mensagem}) :super(contato: null);
}

class TelaConversaErrortState extends TelaConversaBlocState{
  final String errorMessenger;
  TelaConversaErrortState({required this.errorMessenger}):super(contato: null);
}