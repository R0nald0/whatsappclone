import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/GeraRotas.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:whatsapp/views/Home.dart';

class cadastro extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => cadastroState();
}

class cadastroState extends State<cadastro> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  validarCampo() {
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;
    String _aviso = "";

    if (nome.isNotEmpty && nome.length > 3) {
      if (email.isNotEmpty && email.contains("@")) {
        if (senha.length >= 6) {
          Usuario usuario = Usuario();

          usuario.nome = nome;
          usuario.email = email;
          usuario.senha = senha;

          CadastrarUsuario(usuario);


        } else {
          _aviso = "Senha priecisa conter 6 ou mais caracteres !!!";
          _mostrarSnackBar(_aviso);
        }
      } else {
        _aviso = "Insira um E-mail válido";
        _mostrarSnackBar(_aviso);
      }
    } else {
      _aviso = "Nome precisa ter mais que letras 4 ";
      _mostrarSnackBar(_aviso);
    }
  }

  Future CadastrarUsuario(Usuario userr) async {
     await _auth.createUserWithEmailAndPassword(
            email: userr.email, 
            password: userr.senha
    
    ).then((firebaseUser) {
     
      FirebaseFirestore db = FirebaseFirestore.instance;
      db.collection("usuario")
          .doc(firebaseUser.user!.uid.toString())
          .set(userr.toMap());

      Navigator.pushNamedAndRemoveUntil(context, GerarRotas.ROUTE_HOME, (route) => false);

    })
        .catchError((erro) {
      if (erro.toString().isEmpty) {
        _mostrarSnackBar("Usuário Cadastrado");
      } else {
        _mostrarSnackBar("Erro ao Cadastrar,Verifique os campos!!!");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
        backgroundColor: Color(0xff075E54),
      ),
      body: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Color(0xff075E54),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Image.asset(
                  "images/usuario.png",
                  height: 200,
                  width: 150,
                ),
                campoTextFild(),
                campoBotoes(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  campoTextFild() {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8, top: 18),
            child: TextField(
              controller: _controllerNome,
              keyboardType: TextInputType.name,
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                hintText: "Nome",
                filled: true,
                fillColor: Colors.white,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
              ),
            ),
          ),
          TextField(
            keyboardType: TextInputType.emailAddress,
            controller: _controllerEmail,
            style: TextStyle(
              fontSize: 20,
            ),
            decoration: InputDecoration(
              hintText: "E-mail",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 9),
            child: TextField(
              controller: _controllerSenha,
              obscureText: true,
              keyboardType: TextInputType.text,
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                hintText: "Senha",
              ),
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
          ElevatedButton(
              onPressed: () {
                validarCampo();
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16)),
              child: Text("Cadastrar", style: TextStyle(fontSize: 20)))
        ],
      ),
    );
  }

  _mostrarSnackBar(String msg) {
    final snackBar = SnackBar(
        content: Text(
      msg,
      style: TextStyle(
        fontSize: 15,
      ),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
