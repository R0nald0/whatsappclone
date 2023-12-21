import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/Banco.dart';
import 'home_bloc_state.dart';

class HomeBloc  extends Cubit<HomeBlocState>{
  final _banco = Banco();
  HomeBloc() : super(HomeInitialState());

  getDataActialUser()async{

    try{
      emit(HomeLoadingState());
      final user  = _banco.verificarUsuarioLogado();
      if(user != null){
        final ususario =  await _banco.recuperarUsuario(user);
         emit(HomeSuccssState(user: ususario));
      }else{
        emit(HomeErroState( errorMensager: "Usario não Enconstrado"));
      }
    } catch(ex) {
      print(ex);
      emit(HomeErroState( errorMensager: " Usuario não encontrado"));
    }
  }
}