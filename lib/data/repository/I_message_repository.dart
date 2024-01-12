import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../model/Contato.dart';
import '../../model/Mensagem.dart';

abstract class IMessageRepository {
  Stream<List<Mensagem>> getAllMessagesFromConversation(String idUserLogado ,String idDestinatario);

  Future<void> saveMessager(Mensagem mensagem);
  Future<void> salvarUltimaMensagemConversa(Mensagem mensagem,Contato contato);
  Future<UploadTask> salvarImage(String imagePath,String idLoggedUser);
  Future<String> dowloadImage(TaskSnapshot snapshot);
  Future<String> createImge(String imagePath,String idLoggedUser);
  Future<void> _saveLastMessageToSender(Mensagem mensagem,Contato contato);
  Future<void> _saveLastMessageToRecipient(Mensagem mensagem);
  void destroyListener();
}
