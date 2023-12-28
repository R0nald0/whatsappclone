
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/Banco.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:whatsapp/views/pages/cadastro_page/stream/cadastro_state.dart';

import '../../../../data/repository/irepository_user.dart';
import '../../../../main.dart';

class CadastroBloc extends Cubit<CadastroState>{
     final bdUser = getIt.get<Banco>();
     final IReposioryUser _repositoryUser;
   CadastroBloc(this._repositoryUser) : super(InitialCadastroFieldState());

   var isValidName = false;
   void validateNameUser(String name){
     print("name ${name}");
       if(name.length <= 4){
         isValidName =false;
         emit(ValidateCadastroFieldState(isValid: false));
         return;
       }
       isValidName =true;
       emit(ValidateCadastroFieldState(isValid: isValidName));
   }

   void cadastrarUsuario(Usuario user) async{
          try{
                emit(LoadingCadastroState());
                var result  = await  _repositoryUser.cadastrarUsuario(user); //bdUser.cadastrarUsuario(user);
                if(result != null){
                  emit(SuccessCadastroState(messenger:  result));
                }else{
                  emit(ErrorCadastroState(errorMessenger: "erro ao criaro usuário"));
                }
          }catch(e){
            print(e);
            emit(ErrorCadastroState(errorMessenger: e.toString()));
          }
   }
}