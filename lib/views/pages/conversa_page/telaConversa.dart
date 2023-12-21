import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/views/pages/conversa_page/store/tela_conversa_bloc_state.dart';
import 'package:whatsapp/views/pages/conversa_page/store/tela_conversa_bloc.dart';
import '../../../GeraRotas.dart';
import '../../../model/Contato.dart';
import '../../../model/Mensagem.dart';


class TelaConversa extends StatefulWidget {
  late Contato contatocv;
  TelaConversa(this.contatocv);

  @override
  State<StatefulWidget> createState() => TelaConversaState();
}
class TelaConversaState extends State<TelaConversa> {
  final telaConversaBloc = TelaConversaBloc();

  final Mensagem _mensagem = Mensagem();

  String idUserLogado = "";
  String idDestinatario = "";
  final user = User;

  final TextEditingController _controllerTextoMsg = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  verificarUsuarioLogado() async {

    final user = await telaConversaBloc.isLogged();
    if (user != null) {
       idUserLogado = user.uid.toString();
       idDestinatario = widget.contatocv.idContato;
    } else {
      print("Erro ao recuperar o usuario");
      Navigator.pushNamedAndRemoveUntil(context, GerarRotas.ROUTE_LOGIN,(route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    verificarUsuarioLogado() ;
    }

  @override
  void dispose() {
    telaConversaBloc.destroyListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -12,
        toolbarHeight: 70,
        title: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(widget.contatocv.foto),
              maxRadius: 25,
            ),
            const Padding(padding: EdgeInsets.only(left: 15,)),
            Text(widget.contatocv.nome)
          ],
        ),
        backgroundColor: const Color(0xff075E54),
      ),
      body: Container(
        padding: const EdgeInsets.all(3),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bg.png"), fit: BoxFit.cover)),
        child: SafeArea(
            child: Container(
          child: Column(
            children: <Widget>[
              _stremListMensagen(),
               campoMsg()
            ],
          ),
        ),),
      ),
    );
  }

  camposListMsg(QuerySnapshot query) {
    return Expanded(
      child: ListView.builder(

          controller: _scrollController,
          itemCount: query.docs.length,
          itemBuilder: (context, index) {
            List<DocumentSnapshot> mensagensList = query.docs.toList();
            DocumentSnapshot mensagemItem = mensagensList[index];

            //obtendo largura do container e ultilizando 80% para as msgs
            double larguraDoContainer = MediaQuery.of(context).size.width * 0.8;
            Alignment align = Alignment.centerRight;
            Color cor = const Color(0Xff8FBC8F);


            if ( idUserLogado == mensagemItem["idRemetente"]) {
               align;
               cor;
            } else {
               align = Alignment.centerLeft;
               cor = const Color(0xfff4f7d4);
            }

            return Align(
              alignment: align,
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    width: larguraDoContainer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: cor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: mensagemItem["tipo"] == "texto"
                                  ? Text(
                                      mensagemItem["mensagem"],
                                      style: const TextStyle(fontSize: 17),
                                    )
                                  : Image.network(mensagemItem["url"]),
                              trailing: Text(
                                mensagemItem["data"],
                                style: const TextStyle(fontSize: 16),
                              ),
                            )
                          ]),
                    ),
                  )),
            );
          }),
    );
  }

 Widget campoMsg() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controllerTextoMsg,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon:
                 BlocBuilder<TelaConversaBloc,TelaConversaBlocState>(
                   bloc: telaConversaBloc,
                   builder: (context, state) {
                     if(state is TelaConversaLoadingState){
                         return const Center(child: CircularProgressIndicator());
                     }else{
                       return IconButton(
                         icon :const Icon(Icons.camera_alt),
                         onPressed: () {
                          telaConversaBloc.enviarImagem(true, widget.contatocv); //ENVIANDO DA CAMERA
                         },
                       );
                     }
                   }
                 ),
                hintText: "Digite uma Menssagem...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                contentPadding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 8)),
          Platform.isAndroid
              ? FloatingActionButton(
                  onPressed: () {
                    if(_controllerTextoMsg.text.isNotEmpty){
                       telaConversaBloc.enviarMensagem(_controllerTextoMsg.text,idUserLogado,widget.contatocv);
                       _controllerTextoMsg.clear();
                    }
                  },
                  child: const Icon(Icons.send),
                  backgroundColor: const Color(0xff075E54),
                )
              : CupertinoButton(child: const Text("Enviar"), onPressed: () {
            if(_controllerTextoMsg.text.isNotEmpty){
              telaConversaBloc.enviarMensagem(_controllerTextoMsg.text,idUserLogado,widget.contatocv);
              _controllerTextoMsg.clear();
            }
          })
        ],
      ),
    );
  }

  _stremListMensagen(){
    return StreamBuilder(
      stream: telaConversaBloc.listenerMenssagens(widget.contatocv.idContato),
      builder: (context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasData) {

              Timer(const Duration(seconds: 1),(){
                _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
              });
              QuerySnapshot querySnapshot = snapshot.data;
              return camposListMsg(querySnapshot);
            } else {
              print("dados" + snapshot.hasError.toString());
            }
        }

        return const Center(
          child: Text("msg"),
        );
      },
    );
  }
}
