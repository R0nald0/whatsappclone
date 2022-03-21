import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:whatsapp/views/Home.dart';
import 'package:whatsapp/views/cadastro.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}
class LoginState extends State<Login> {

  TextEditingController _controllerEmail =TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _aviso = "";

  ValidarCampos(){
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if(email.isNotEmpty && email.contains("@") && senha.length >= 6){
          Usuario usuario =Usuario();
          usuario.email =email;
          usuario.senha = senha;
          _loginUser(usuario);

    }else{
        mostrarSnackBar("E-mail ou Senha inválido,verifique os campos ");
    }

  }


  _loginUser(Usuario user){

    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.senha
    ).then((firebaseUser){

         Navigator.pushReplacement(
             context,
             MaterialPageRoute(builder: (context) => Home())
         );
    }).catchError((erro){
          mostrarSnackBar("E-mail ou Senha inválido,verifique os campos ");
    });
  }


  Future vericarUsuarioLogado()  async{
    FirebaseAuth auth =FirebaseAuth.instance;
    User user =  await auth.currentUser!;
    if(user != null){
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context)=>Home()), (route) => false);
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
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Color(0xff075E54),
        ),
        child: Center(
            child: SingleChildScrollView(
          child: Column(

              children: <Widget>[
                Image.asset(
                  "images/logo.png",
                  height: 200,
                  width: 150,
                ),
                campoTxtField(),
                campoBotoes(),
              ]),
        )),
      ),
    );
  }

  campoTxtField() {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: TextField(
              controller: _controllerEmail,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  hintText: "Email",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                  )),
            ),
          ),
          TextField(
            controller: _controllerSenha,
            obscureText: true,
            keyboardType: TextInputType.text,
            style: TextStyle(
              fontSize: 20
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "Senha",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
              contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
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
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: ElevatedButton(
                onPressed: () {
                  ValidarCampos();
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16)),
                child: Text(
                  "Entrar",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Não tem Conta ?",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),

              TextButton(
                  onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder:(context) => cadastro())
                      );
                  },
                  child: Text("Cadastre-se!",
                      style: TextStyle(fontSize: 15, color: Colors.white)))
            ],
          )
        ],
      ),
    );
  }


  mostrarSnackBar(String msg){

    final snackBar = SnackBar(
        content: Text(
          msg,
          style: TextStyle(
            fontSize: 20
          ),
        )
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
