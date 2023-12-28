
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/GeraRotas.dart';
import 'package:whatsapp/helper/Constants.dart';
import 'package:whatsapp/main.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:whatsapp/views/pages/cadastro_page/stream/cadastro_bloc.dart';
import 'package:whatsapp/views/pages/cadastro_page/stream/cadastro_state.dart';
import 'package:whatsapp/views/pages/login_page/stream/validate_fields.dart';

class cadastro extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => cadastroState();
}

class cadastroState extends State<cadastro> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  final _forkey = GlobalKey<FormState>();
  final _cadastroBloc = getIt.get<CadastroBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro"),
        backgroundColor: const Color(0xff075E54),
      ),
      body: Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Color(0xff075E54),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Image.asset(
                 Constants.IMGAGE_PATH_USARIO_ADD,
                  height: 200,
                  width: 150,
                ),
                campoTextField(),
                campoBotoes(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  campoTextField() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _forkey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 18),
            child: TextFormField(
                  validator: (value){
                   if(value ==null  || value.length <=4){
                     print(value);
                    return "Preencha até 5 caracteres";
                   }
                   return null;
                },
                  controller: _controllerNome,
                  keyboardType: TextInputType.name,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    errorStyle: const TextStyle(color: Colors.redAccent),
                    contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: "Nome",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),),
                ),
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: _controllerEmail,
            style: const TextStyle(
              fontSize: 20,
            ),
            decoration: InputDecoration(
              errorStyle: const TextStyle(color: Colors.redAccent),
              hintText: "E-mail",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            ),
            validator: (value){
              if(value ==null  || !value.contains("@")){
                print(value);
                return "Email inválido";
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 9),
            child: TextFormField(
              controller: _controllerSenha,
              obscureText: true,
              keyboardType: TextInputType.text,
              style: const TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                hintText: "Senha",
                errorStyle: const TextStyle(color: Colors.redAccent),
              ),

                validator: (value){
                  if(value ==null  || value.length <=5){
                    print(value);
                    return "Senha precisa conter mais de 5 caracteres";
                  }
                  return null;
                }
            ),
          ),
        ],
      ),
    );
  }

  campoBotoes() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          BlocConsumer<CadastroBloc,CadastroState>(
            bloc: _cadastroBloc,
            listener: (BuildContext context, CadastroState state) {
                if(state is ErrorCadastroState){
                  _mostrarSnackBar(state.errorMessenger);
                }
                if(state is SuccessCadastroState){
                  _mostrarSnackBar(state.messenger);
                  Navigator.pushNamedAndRemoveUntil(context, GerarRotas.ROUTE_LOGIN, (route) => false);
                }
            },
            builder: (context, state) {
              if(state is LoadingState){
                 return const Center(child: CircularProgressIndicator());
              }else{
                return ElevatedButton(
                onPressed: () {
                if(_forkey.currentState!.validate()){
                // validarCampo();
                  final usuario  =Usuario();
                  usuario.email = _controllerEmail.text;
                  usuario.nome =  _controllerNome.text;
                  usuario.senha = _controllerSenha.text;
                   _cadastroBloc.cadastrarUsuario(usuario);
                  }
                },
                style: ElevatedButton.styleFrom(
                primary: Colors.green,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32)),
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 16)),
                child: const Text("Cadastrar", style: TextStyle(fontSize: 20)));
                }
              }
          )
        ],
      ),
    );
  }

  _mostrarSnackBar(String msg) {
    final snackBar = SnackBar(
        content: Text(
      msg,
      style: const TextStyle(
        fontSize: 15,
      ),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  @override
  void dispose() {
    _cadastroBloc.close();
    super.dispose();
  }
}
