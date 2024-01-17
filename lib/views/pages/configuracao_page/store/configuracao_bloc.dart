
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/data/repository/irepository_user.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:whatsapp/views/pages/configuracao_page/store/configuracao_state.dart';

class ConfiguracaoBloc extends Cubit<ConfiguracaoState>{
  final IReposioryUser _repositoryUserData ;
  late Usuario usuarioState = Usuario();
  var isDisableButton = false;

  ConfiguracaoBloc(this._repositoryUserData) : super(ConfiguracaoInitialState());

  getDataUser() async{
    try{
      emit(ConfiguracaoLoadingState());
      usuarioState= await _repositoryUserData.getUserData();
      emit(ConfiguracaoUpdatedState(usuario: usuarioState));
    }catch(exeption){
      emit(ConfiguracaoErrrolState(errorMessenger: exeption));
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
      isDisableButton = true;
      emit(ConfiguracaoLoadingState());
      final userId  = await _repositoryUserData.verificarUsuarioLogado()?.uid;
      if(userId !=null ){
        usuarioState.fotoPerfil = await _repositoryUserData.createImage(image.path,userId);
       }
      emit(ConfiguracaoUpdatedState(usuario: usuarioState));
      isDisableButton = false;
    }
  }

  Future updateUser(Usuario usuarioUpdate) async {
    try {
      if(usuarioUpdate.nome.isNotEmpty) {
        usuarioUpdate.fotoPerfil =  usuarioState.fotoPerfil;
        emit(ConfiguracaoLoadingState());
        var result = await _repositoryUserData.upadate(usuarioUpdate);
        if(result !=null){
          emit(ConfiguracaoUpdatedState(usuario: result));
        }else{
          emit(ConfiguracaoErrrolState(errorMessenger: "Algo de errado aconteceu,usuário  não atualizdo"));
        }
      }else{
        usuarioUpdate.nome = usuarioState.nome;
        usuarioUpdate.fotoPerfil = usuarioState.fotoPerfil;
        emit(ConfiguracaoLoadingState());
        var result = await _repositoryUserData.upadate(usuarioUpdate);
        if(result !=null){
          emit(ConfiguracaoUpdatedState(usuario: result));
        }else{
          emit(ConfiguracaoErrrolState(errorMessenger: "Algo de errado aconteceu,usuário  não atualizdo"));
        }
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
    if(usuarioUpdate.nome != usuarioState.nome || usuarioUpdate.fotoPerfil !=  usuarioState.fotoPerfil){
         updateUser(usuarioUpdate);
         return;
    }
  }

}