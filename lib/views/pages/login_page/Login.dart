import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/GeraRotas.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/views/pages/login_page/stream/validate_fields.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}
class LoginState extends State<Login> {

  final TextEditingController _controllerEmail =TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();
  final validateFields = ValidateFieldsBloc();

  Future vericarUsuarioLogado()  async{
    FirebaseAuth auth =FirebaseAuth.instance;
    User user =  await auth.currentUser!;
    if(user != null){
       Navigator.pushNamedAndRemoveUntil(context, GerarRotas.ROUTE_HOME,(route) => false);
    }
  }

  @override
  void initState() {
      super.initState();
      vericarUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: Color(0xff075E54),
        ),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
              children: <Widget>[
                Image.asset(
                  "images/logo.png",height: 200, width: 150,
                ),
                campoTxtField(),
                campoBotoes(),
              ]),
        )),
      ),
    );
  }

  campoTxtField() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: BlocBuilder<ValidateFieldsBloc,ValidateFiledsState>(
            bloc: validateFields,
            builder: (context, state) {
              return TextField(
                controller: _controllerEmail,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: "Email",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    )
                  ,errorText: validateFields.isValideEmail ? "Verificar o campo" : null,
                   suffixIcon: validateFields.isValideEmail ? const Icon(Icons.error_outline,color: Color.fromRGBO(
                      238, 19, 19, 1.0)):null
                  ),

              );
            }
          ),
        ),
        TextField(
          controller: _controllerSenha,
          obscureText: true,
          keyboardType: TextInputType.text,
          style: const TextStyle(
            fontSize: 20
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: "Senha",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
            contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),

          ),
        ),
      ],
    );
  }

  campoBotoes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: BlocConsumer<ValidateFieldsBloc,ValidateFiledsState>(
            bloc: validateFields,
            buildWhen: (previous ,current)=> previous != current,
            listener: (BuildContext context, ValidateFiledsState state) {
                if(state is ErrorValidateState){
                     mostrarSnackBar(state.errorMessenger);
                }
                if(state is SuccessState){
                  Navigator.pushNamedAndRemoveUntil(context, GerarRotas.ROUTE_HOME, (route) => false);
                }
            },
            builder: (context, snapshot) {
               if(snapshot is LoadingState){
                 return const Center(child: CircularProgressIndicator());
               }else{
                 return ElevatedButton(
                     onPressed: () {
                       validateFields.validateField(_controllerEmail.text,_controllerSenha.text);
                       FocusScope.of(context).requestFocus(FocusNode());
                     },
                     style: ElevatedButton.styleFrom(
                         primary: Colors.green,
                         shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(32)),
                         padding: const EdgeInsets.fromLTRB(32, 16, 32, 16)),
                     child: const Text(
                       "Entrar",
                       style: TextStyle(
                         fontSize: 20,
                       ),
                     ));
               }
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Não tem Conta ?",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),

            TextButton(
                onPressed: () {
                   Navigator.pushNamed(context,GerarRotas.ROUTE_CADASTRO);
                },
                child: const Text("Cadastre-se!",
                    style: TextStyle(fontSize: 15, color: Colors.white)))
          ],
        )
      ],
    );
  }


  mostrarSnackBar(String msg){

    final snackBar = SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
            fontSize: 14
          ),
        )
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    validateFields.close();
    super.dispose();
  }
}
