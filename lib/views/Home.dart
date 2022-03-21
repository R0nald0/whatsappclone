import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:whatsapp/views/Login.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future deslogarUsuario() async{
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context)=>Login()), (route) => false);
     await auth.signOut();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("WhatsApp"),
        backgroundColor: Color(0xff075E54),
      ),

      body: Container(
        child: Center(
            child: Column(
          children: <Widget>[

             ElevatedButton(onPressed: (){
                 deslogarUsuario();
             },
                 child: Text("SAIR"))
          ],
        )),
      ),
    );
  }
}
