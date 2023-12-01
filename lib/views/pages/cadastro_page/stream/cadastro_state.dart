abstract class CadastroState{}

class InitialCadastroFieldState extends CadastroState{
    InitialCadastroFieldState();
}
class ValidateCadastroFieldState extends CadastroState{
    final bool isValid;
    ValidateCadastroFieldState({required this.isValid});
}
class LoadingCadastroState extends CadastroState{}

class SuccessCadastroState extends CadastroState{
     final String messenger;
     SuccessCadastroState({required this.messenger});
}

class ErrorCadastroState extends CadastroState{
    final String errorMessenger;
    ErrorCadastroState({required this.errorMessenger});
}