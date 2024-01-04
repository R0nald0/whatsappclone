import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/Contato.dart';
import '../../model/Mensagem.dart';

abstract class IMessageRepository {
  Stream<List<Mensagem>> getAllMessagesFromConversation(String idUserLogado ,String idDestinatario);

  Future<void> saveMessager(Mensagem mensagem);
  Future<void> salvarUltimaMensagemConversa(Mensagem mensagem,Contato contato);
  Future<void> _saveLastMessageToSender(Mensagem mensagem,Contato contato);
  Future<void> _saveLastMessageToRecipient(Mensagem mensagem);
}
