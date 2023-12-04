
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/GeraRotas.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:whatsapp/views/pages/contato_page/AbaContato.dart';
import 'package:whatsapp/views/pages/conversa_page/AbaConversa.dart';
import 'package:whatsapp/views/pages/login_page/Login.dart';
import 'package:whatsapp/views/pages/status_page/camera.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin{
  FirebaseAuth auth = FirebaseAuth.instance;
  late TabController _tabController ;
  List<String> listaItens =[
    "Configuração",
    "Deslogar"
  ];
  

  _escolhaItem(String itemEscolhido){

      switch(itemEscolhido){
         case "Configuração":
           Navigator.pushNamed(context, GerarRotas.ROUTE_CONFIG);
         break;
        case "Deslogar":
          deslogarUsuario();
          break;
      }
  }

  Future deslogarUsuario() async{
    await auth.signOut();
      Navigator.pushNamedAndRemoveUntil(context, GerarRotas.ROUTE_LOGIN, (route) => false);
  }

  @override
  void initState() {
    super.initState();
    _tabController =TabController(length: 3, vsync: this,initialIndex: 1 );

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("WhatsApp"),
        backgroundColor: const Color(0xff075E54),
        bottom:TabBar(
          indicatorWeight:Platform.isIOS ?0 :4,
            indicatorColor: Colors.white,
            controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.camera_alt),
              iconMargin: EdgeInsets.only(left: 1),
            ),
            Tab(
              child: Text('Converses'),
            ),
            Tab(
              child: Text("Contacts"),
            )
          ],
        ),
        actions: [
          ///MENU POPUP
          PopupMenuButton<String>(
              onSelected: _escolhaItem,
              itemBuilder: (context){
                  return listaItens.map((String item){
                    return PopupMenuItem<String>(
                         value: item,
                         child: Text(item),
                    );
              }).toList();
            }
          )
        ],
      ),

      body:TabBarView(
        controller: _tabController,
        children: <Widget>[
           Camera(),
           AbaConversa(),
           AbaContato()
        ],
      )
    );
  }
}
