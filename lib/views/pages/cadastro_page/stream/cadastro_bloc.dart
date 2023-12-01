import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/Banco.dart';
import 'package:whatsapp/views/pages/cadastro_page/stream/cadastro_state.dart';

class CadastroBloc extends Cubit<CadastroState>{
     final repositoryUSer = Banco();
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

   void cadastrarUsuario(String name,String email,String password) async{
          try{
                emit(LoadingCadastroState());
               var result  = await  repositoryUSer.cadastrarUsuario(name, email, password);
                emit(SuccessCadastroState(messenger:  result));
          }catch(e){
            print(e);
            emit(ErrorCadastroState(errorMessenger: e.toString()));
          }
   }
}