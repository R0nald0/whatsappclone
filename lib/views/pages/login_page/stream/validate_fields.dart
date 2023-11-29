import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/Banco.dart';

import '../../../../model/Usuario.dart';

class ValidateFieldsBloc extends Cubit<ValidateFiledsState>{
  final repositoryLogin = Banco();
  bool isValideEmail = false;
  bool isValidePassword = false;

  ValidateFieldsBloc() : super(ValidateInitialState());

  void validateField(String email ,String password){
    print("name ${email}");
    print("senha ${password}");
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
          await repositoryLogin.login(email,senha);
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
