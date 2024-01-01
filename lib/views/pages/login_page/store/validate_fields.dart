import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/Banco.dart';
import 'package:whatsapp/data/repository/irepository_user.dart';
import 'package:whatsapp/data/repository/repositoryimpl/user_repository_impl.dart';
import 'package:whatsapp/main.dart';

import '../../../../model/Usuario.dart';

class ValidateFieldsBloc extends Cubit<ValidateFiledsState>{
  bool isValideEmail = false;
  bool isValidePassword = false;
  IReposioryUser userRepository ;


  ValidateFieldsBloc(this.userRepository) : super(ValidateInitialState());

  User? verificarUsuraioLogado(){
    return userRepository.verificarUsuarioLogado();
  }

  void validateField(String email ,String password){
        if(email.isEmpty || !email.contains("@")){
           emit(ErrorValidateState(errorMessenger: "Email inválido,campo precisa conter @ e .com"));
           return ;
        }
        if( password.length <= 5){
          emit(ErrorValidateState(errorMessenger: "Senha inválida,campo precisa conter mais de 5 caracteres"));
         return;
        }
        logarUsuario(email,password);
  }

  Future<void> logarUsuario(String email, String senha) async{
       try{
          emit(LoadingState());
          await userRepository.loginUser(email,senha);
          emit(SuccessState());
       }catch(e){
          emit(ErrorValidateState(errorMessenger: "Erro ao logar usuario"));
       }
  }

}

abstract class ValidateFiledsState {}
class ValidateInitialState extends ValidateFiledsState{}
class IsValidateState extends ValidateFiledsState{
     final bool isValidate ;
     IsValidateState({required this.isValidate});
}
class LoadingState extends ValidateFiledsState{
    LoadingState();
}

class SuccessState extends ValidateFiledsState{
    SuccessState();
}
class ErrorValidateState extends ValidateFiledsState{
     final String errorMessenger;
     ErrorValidateState({required this.errorMessenger});
}
