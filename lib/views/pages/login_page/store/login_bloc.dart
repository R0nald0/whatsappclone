import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_states.dart';



class LoginBloc extends Cubit<LoginState>{
  LoginBloc() : super(InitialStateLogin());
}

