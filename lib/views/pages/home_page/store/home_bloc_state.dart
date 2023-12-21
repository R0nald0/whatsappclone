import 'package:whatsapp/model/Usuario.dart';

abstract class HomeBlocState{
  Usuario? usuario ;
  HomeBlocState({this.usuario});
}

class HomeInitialState extends HomeBlocState{
   HomeInitialState():super(usuario: null);
}


class HomeLoadingState extends HomeBlocState{
  HomeLoadingState():super(usuario: null);
}


class HomeSuccssState extends HomeBlocState{
    final Usuario user;
   HomeSuccssState({required this.user}):super(usuario: user);
}


class HomeErroState extends HomeBlocState{
  final String errorMensager;
  HomeErroState({required this.errorMensager}):super(usuario: null);
}

