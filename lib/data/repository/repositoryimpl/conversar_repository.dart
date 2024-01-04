import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/data/repository/i_conversa_repository.dart';
import 'package:whatsapp/data/service/authentication_service.dart';

import '../../../controller/Banco.dart';
import '../../../model/Conversa.dart';
import '../../service/database_service.dart';

class ConversaRepository implements IConversaRepository{
    final Banco _banco;
    final DatabaseService _databaseService;
    final AuthenticationService _authenticationService;

    ConversaRepository(this._banco,this._authenticationService, this._databaseService);

    @override
    Stream<List<Conversa>> getAllConversations() {
      try{
        final user = _authenticationService.verificarUsuarioLogado();
        return _databaseService.recuperarConversas(user!.uid);
        //print("lista de conversas ${ listConversations.length}");

     }catch(e){
        print(e);
        rethrow;
     }
    }

    @override
    Future<void> deleteConversation(String idDestinatarioConversa,String userLoggedId) async{
          try{
               await _databaseService.deleteConversation(idDestinatarioConversa, userLoggedId);
          }
            catch(exception){
             rethrow;
          }
    }

     @override
    destroyListen(){
       _banco.destroyListen();
    }
}