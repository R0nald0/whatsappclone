import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/controller/Banco.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:whatsapp/views/pages/configuracao_page/store/configuracao_state.dart';

import '../../../../main.dart';


class ConfiguracaoBloc extends Cubit<ConfiguracaoState>{
  final  _banco = getIt.get<Banco>();
  String uriImage = "";
  String nameUser = "";

  ConfiguracaoBloc() : super(ConfiguracaoInitialState());

  getDataUser() async{
    final user =  _banco.verificarUsuarioLogado();
    if(user != null){
      emit(ConfiguracaoLoadingState());
      final usuario  = await Usuario().dadosUser(user.uid);
       uriImage = usuario.fotoPerfil;
       nameUser = usuario.nome;

      emit(ConfiguracaoUpdatedState(usuario: usuario));
    }
  }

  Future recuperarImage(bool isCamera) async {
    XFile? image;
    final picker =ImagePicker();
    if (isCamera) {
      image = await picker.pickImage(source: ImageSource.camera);
    } else {
      image = await picker.pickImage(source: ImageSource.gallery);
    }
    if(image != null){
      emit(ConfiguracaoLoadingState());
      salvarImagemBd(image.path);
    }

  }
  
  salvarImagemBd(String arquivoPath) async{
  final task  =  await _banco.salvarImgPerfil(arquivoPath);
    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      if (snapshot.state == TaskState.running) {
         emit(ConfiguracaoLoadingState());
      } else if (snapshot.state == TaskState.success) {
          _dowloadImagem(snapshot);
      }
    });
  }
  Future _dowloadImagem(TaskSnapshot snapshot) async {
      uriImage = await snapshot.ref.getDownloadURL();
     final user =  _banco.verificarUsuarioLogado();
     final usuario  = await Usuario().dadosUser(user!.uid);
     usuario.fotoPerfil = uriImage;
     emit(ConfiguracaoUpdatedState(usuario: usuario));
  }

  Future updateUser(Usuario usuarioUpdate) async {
    try {
      if(usuarioUpdate.nome.isNotEmpty) {
        usuarioUpdate.fotoPerfil = uriImage;
        emit(ConfiguracaoLoadingState());
        await _banco.updateUser(usuarioUpdate);
        emit(ConfiguracaoUpdatedState(usuario: usuarioUpdate));
      }else{
        usuarioUpdate.nome = nameUser;
        usuarioUpdate.fotoPerfil = uriImage;
        emit(ConfiguracaoLoadingState());
        await _banco.updateUser(usuarioUpdate);
        emit(ConfiguracaoUpdatedState(usuario: usuarioUpdate));
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(ConfiguracaoErrrolState(errorMessenger: "Campo nome não pode ser vazio"));
    }
  }

  void validateField(Usuario usuarioUpdate){
    if(usuarioUpdate.nome != nameUser || usuarioUpdate.fotoPerfil != uriImage){
         updateUser(usuarioUpdate);
        return;
    }
  }

}