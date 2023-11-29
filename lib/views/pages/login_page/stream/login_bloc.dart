import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/views/pages/login_page/stream/login_states.dart';



class LoginBloc extends Cubit<LoginState>{
  LoginBloc() : super(InitialStateLogin());
}

