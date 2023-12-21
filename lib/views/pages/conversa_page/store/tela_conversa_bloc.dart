import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/controller/Banco.dart';
import 'package:whatsapp/model/Contato.dart';
import 'package:whatsapp/model/Mensagem.dart';

import '../../../../helper/Helper.dart';
import '../../../../model/Conversa.dart';
import '../../../../model/Usuario.dart';
import 'tela_conversa_bloc_state.dart';

class TelaConversaBloc extends Cubit<TelaConversaBlocState> {
   final _banco = Banco();
   XFile? arquivo;

  TelaConversaBloc() : super(TelaConversaInitState());

   salvarUltimaMensagemConversa(Mensagem mensagem,Contato contato) async{
   final user = _banco.verificarUsuarioLogado();
    if(user !=null){
      Usuario usuario = await Usuario().dadosUser(user.uid);
      Conversa cRementent = Conversa(
          mensagem.idRemetente,
          mensagem.idDestinatario,
          mensagem.url
      );

      cRementent.data = mensagem.data;
      cRementent.idDestinatario = mensagem.idDestinatario;
      cRementent.idRemetente = mensagem.idRemetente;
      cRementent.urlImagenConversa = mensagem.url;
      cRementent.tipo = mensagem.tipo;
      cRementent.msg = mensagem.msg;
      cRementent.fotoUrl =contato.foto;
      cRementent.remetenteNome = contato.nome;

      await _banco.salvarUltimaMensagemBd(cRementent);

      Conversa cDestinatrio = Conversa(
          mensagem.idRemetente,
          mensagem.idDestinatario,
          mensagem.url
      );
      cDestinatrio.idDestinatario = mensagem.idRemetente;
      cDestinatrio.idRemetente = mensagem.idDestinatario;
      cDestinatrio.tipo = mensagem.tipo;
      cDestinatrio.urlImagenConversa = mensagem.url;
      cDestinatrio.msg = mensagem.msg;
      cDestinatrio.fotoUrl = usuario.fotoPerfil;
      cDestinatrio.remetenteNome = usuario.nome;
      cDestinatrio.data = mensagem.data;
      await _banco.salvarUltimaMensagemBd(cDestinatrio);
    }


  }

   enviarMensagem( String textoMensagem,String idRemetente,Contato destinatario, {url})  async{
    try{
      if (textoMensagem.isNotEmpty) {
         final mensagem = Mensagem();
         mensagem.tipo = "texto";
         mensagem.msg = textoMensagem;
         mensagem.data = Helper.formatarData(DateTime.now().toString());
         mensagem.idRemetente = idRemetente;
         mensagem.idDestinatario = destinatario.idContato;
         mensagem.time = Timestamp.now().toString();
         mensagem.url = "";

        await _banco.salvarRemetenteMensagem(mensagem);
        await _banco.salvarDestinatarioMensagem(mensagem);

       salvarUltimaMensagemConversa(mensagem,destinatario);
      }
    }catch(e){
       emit(TelaConversaErrortState(errorMessenger: "Não conseguimos enviar a msg"));
    }
  }

   listenerMenssagens(String idDestinatario){
    final user  = _banco.verificarUsuarioLogado();
    return _banco.adicionarListenerMensagens(user!.uid, idDestinatario);
  }

   destroyListener(){
       _banco.destroyListen();
   }

   salvarImageBd(String imagePath,Contato contato) async{
     final task =  await _banco.salvarImagembd(imagePath);
     task.snapshotEvents.listen((TaskSnapshot snapshot) {
       if (snapshot.state == TaskState.running) {
            emit(TelaConversaLoadingState());
       } else if (snapshot.state == TaskState.success) {
            dowloadImage(snapshot,contato);
       }
     });
   }

   Future dowloadImage(TaskSnapshot snapshot,Contato contato) async {
     String uri = await snapshot.ref.getDownloadURL();

    final mensagem = Mensagem();
     mensagem.tipo = "imagem";
     mensagem.msg = "";
     mensagem.data =Helper.formatarData(DateTime.now().toString());
     mensagem.idRemetente = _banco.verificarUsuarioLogado()!.uid;
     mensagem.idDestinatario = contato.idContato;
     mensagem.time = Timestamp.now().toString();
     mensagem.url = uri;

     await _banco.salvarRemetenteMensagem(mensagem);
     await _banco.salvarDestinatarioMensagem(mensagem);
     salvarUltimaMensagemConversa(mensagem,contato);
     emit(TelaConversaLoadedState(mensagem:mensagem));

     // telaConversaBloc.saveMessenger(_mensagem, widget.contatocv);
   }

   Future enviarImagem(bool isCamera,Contato contato) async {
     final  picker = ImagePicker();

     if (isCamera) {
       arquivo = await picker.pickImage(source: ImageSource.camera);
     } else {
       arquivo = await picker.pickImage(source: ImageSource.gallery);
     }

     if(arquivo !=null){
       emit(TelaConversaLoadingState());
        await salvarImageBd(arquivo!.path,contato);
     }else{
       emit(TelaConversaErrortState(errorMessenger: "Nenhuma imagem selecionada"));
     }
   }

   Future<User?> isLogged() async{
    final user  = _banco.verificarUsuarioLogado();
         if(user != null){
             return user!;
         }else{
           return null;
         }
   }
}



