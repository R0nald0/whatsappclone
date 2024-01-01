
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/Conversa.dart';

abstract class IConversaRepository{
  Stream<List<Conversa>> getAllConversations();
  Future<void>  deleteConversation(String idDestinatarioConversa,String userLoggedId);
  destroyListen();
}