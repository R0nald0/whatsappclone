
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/Banco.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:whatsapp/views/pages/cadastro_page/stream/cadastro_state.dart';

class CadastroBloc extends Cubit<CadastroState>{
     final repositoryUser = Banco();
   CadastroBloc() : super(InitialCadastroFieldState());
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
                var result  = await  repositoryUser.cadastrarUsuario(user);
                emit(SuccessCadastroState(messenger:  result));
          }catch(e){
            print(e);
            emit(ErrorCadastroState(errorMessenger: e.toString()));
          }
   }
}