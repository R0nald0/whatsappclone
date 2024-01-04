import 'package:whatsapp/data/repository/I_message_repository.dart';
import 'package:whatsapp/data/service/database_service.dart';
import 'package:whatsapp/model/Mensagem.dart';
import '../../../model/Contato.dart';
import '../../../model/Conversa.dart';
import '../../../model/Usuario.dart';

class MessengerRepository implements IMessageRepository{
   final DatabaseService _databaseService;
   MessengerRepository(this._databaseService);

   @override
   Stream<List<Mensagem>> getAllMessagesFromConversation(String idRemetente ,String idDestinatario){
      return _databaseService.adicionarListenerMensagens(idRemetente, idDestinatario);
   }

   Future<void> saveMessager(Mensagem mensagem) async{
        try{
           await _databaseService.salvarRemetenteMensagem(mensagem);
           await _databaseService.salvarDestinatarioMensagem(mensagem);
        }catch(exception){
           print(exception);
           throw Exception(" Não conseguimos enviar a msg");
        }
   }

   Future<void> salvarUltimaMensagemConversa(Mensagem mensagem,Contato contato) async{
       try{
          await _saveLastMessageToSender(mensagem, contato);
          await _saveLastMessageToRecipient(mensagem);
       }  catch(exception){
          print(exception);
          throw Exception("error ao salvar mensagem");
       }
   }

   Future<void> _saveLastMessageToSender(Mensagem mensagem,Contato contato) async{
      try{
         Conversa cRementent = Conversa(
             mensagem.idRemetente,
             mensagem.idDestinatario,
             mensagem.url,
         );

         cRementent.data = mensagem.data;
         cRementent.idDestinatario = mensagem.idDestinatario;
         cRementent.idRemetente = mensagem.idRemetente;
         cRementent.urlImagenConversa = mensagem.url;
         cRementent.tipo = mensagem.tipo;
         cRementent.msg = mensagem.msg;
         cRementent.fotoUrl =contato.foto;
         cRementent.remetenteNome = contato.nome;

         _databaseService.salvarUltimaMensagemBd(cRementent);
      }catch( exception){
         print(exception);
         throw Exception("error ao salvar mensagem para o remetente");
      }
   }

   Future<void> _saveLastMessageToRecipient(Mensagem mensagem) async{
      try{
         Conversa cDestinatrio = Conversa(
             mensagem.idRemetente,
             mensagem.idDestinatario,
             mensagem.url
         );

         final usuario = await Usuario().dadosUser(mensagem.idRemetente);

         cDestinatrio.idDestinatario = mensagem.idRemetente;
         cDestinatrio.idRemetente = mensagem.idDestinatario;
         cDestinatrio.tipo = mensagem.tipo;
         cDestinatrio.urlImagenConversa = mensagem.url;
         cDestinatrio.msg = mensagem.msg;
         cDestinatrio.fotoUrl = usuario.fotoPerfil;
         cDestinatrio.remetenteNome = usuario.nome;
         cDestinatrio.data = mensagem.data;

         await _databaseService.salvarUltimaMensagemBd(cDestinatrio);
      }catch(exception){
         print(exception);
         throw Exception("error ao salvar mensagem para o remetente");
      }
   }
}