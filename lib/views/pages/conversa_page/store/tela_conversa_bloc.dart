import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/data/repository/irepository_user.dart';
import 'package:whatsapp/model/Contato.dart';
import 'package:whatsapp/model/Mensagem.dart';
import '../../../../data/repository/IContactRepository.dart';
import '../../../../data/repository/I_message_repository.dart';
import '../../../../helper/Helper.dart';
import 'tela_conversa_bloc_state.dart';

class TelaConversaBloc extends Cubit<TelaConversaBlocState> {

   XFile? arquivo;
    var listMessenger = <Mensagem>[];
   final IContactRepository _contactRepository;
   final IMessageRepository _messageRepository;
   final IReposioryUser _reposioryUser;


  TelaConversaBloc(this._contactRepository,this._messageRepository,this._reposioryUser) : super(TelaConversaInitState());

   salvarUltimaMensagemConversa(Mensagem mensagem,Contato contato) async{
     try{
       await  _messageRepository.salvarUltimaMensagemConversa(mensagem, contato);
     }catch(exception){
       emit(TelaConversaErrortState(errorMessenger: "$exception"));
     }
  }

   enviarMensagem( Mensagem mensagem,Contato destinatario)  async{
    try{
      if (mensagem.msg.isNotEmpty && mensagem.idRemetente.isNotEmpty && mensagem.idDestinatario.isNotEmpty) {
        await _messageRepository.saveMessager(mensagem);
        salvarUltimaMensagemConversa(mensagem,destinatario);
      }else{
        emit(TelaConversaErrortState(errorMessenger: "remetente vazio ou mensagem vazia"));
      }
    }catch(e){
       emit(TelaConversaErrortState(errorMessenger: "$e"));
    }
  }

   Future<void>  listenerMenssagens(String idRemetente,String idDestinatario) async{
      try{
         emit(TelaConversaLoadingState());
          await _contactRepository.getContactData(idDestinatario);
         await _messageRepository.getAllMessagesFromConversation(idRemetente, idDestinatario).listen((event) {
              listMessenger = event;
             emit(TelaConversaLoadedMessangetState(mensagem: event));
         });
      }catch(exeption){
        emit(TelaConversaErrortState(errorMessenger: "$exeption"));
      }
  }

   destroyListener(){
       _messageRepository.destroyListener();
   }

   salvarImageBd(String imagePath,Contato contato,String idUsarioLogado) async{
     try{
       var resul   = await _messageRepository.createImge(imagePath, idUsarioLogado) ;
       if(resul.isNotEmpty){
         final mensagem = Mensagem();
         mensagem.tipo = "imagem";
         mensagem.msg = "";
         mensagem.data =Helper.formatarData(DateTime.now().toString());
         mensagem.idRemetente = idUsarioLogado;
         mensagem.idDestinatario = contato.idContato;
         mensagem.time = Timestamp.now().toString();
         mensagem.url = resul;
         await _messageRepository.saveMessager(mensagem);
         salvarUltimaMensagemConversa(mensagem,contato);

        // emit(TelaConversaLoadedMessangetState(mensagem: listMessenger));
       }
     }
     catch(exe){

       emit(TelaConversaErrortState(errorMessenger: "erro ao carrega lista"));
       emit(TelaConversaLoadedMessangetState(mensagem: listMessenger));
     }
   }

   Future enviarImagem(bool isCamera,Contato contato,String idUsarioLogado) async {
     final  picker = ImagePicker();

     if (isCamera) {
       arquivo = await picker.pickImage(source: ImageSource.camera);
     } else {
       arquivo = await picker.pickImage(source: ImageSource.gallery);
     }

     if(arquivo !=null){
        await salvarImageBd(arquivo!.path,contato,idUsarioLogado);
     }else{
       emit(TelaConversaErrortState(errorMessenger: "Nenhuma imagem selecionada"));
       emit(TelaConversaLoadedMessangetState(mensagem: listMessenger));
     }
   }

   Future<User?> isLogged() async{
    final user  = _reposioryUser.verificarUsuarioLogado();  //_banco.verificarUsuarioLogado();
         if(user != null){
             return user;
         }else{
           return null;
         }
   }


}




