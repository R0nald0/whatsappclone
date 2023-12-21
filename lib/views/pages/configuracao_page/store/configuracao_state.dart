import 'package:flutter/cupertino.dart';
import 'package:whatsapp/model/Usuario.dart';

abstract class ConfiguracaoState{

}
class ConfiguracaoInitialState extends ConfiguracaoState{
   ConfiguracaoInitialState();
}
class ConfiguracaoLoadingState extends ConfiguracaoState{
    ConfiguracaoLoadingState();
}
class ConfiguracaoUpdatedState extends ConfiguracaoState{
   final Usuario usuario ;
   ConfiguracaoUpdatedState({required this.usuario});
}
class ConfiguracaoLoadedState extends ConfiguracaoState {
   final String sucessMenseger;
   ConfiguracaoLoadedState({required this.sucessMenseger});
}
class ConfiguracaoErrrolState extends ConfiguracaoState{
    final errorMessenger ;
    ConfiguracaoErrrolState({required this.errorMessenger});
}
