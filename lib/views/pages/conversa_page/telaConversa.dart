import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/helper/Constants.dart';
import 'package:whatsapp/main.dart';
import 'package:whatsapp/model/Conversa.dart';
import 'package:whatsapp/views/pages/conversa_page/store/tela_conversa_bloc_state.dart';
import 'package:whatsapp/views/pages/conversa_page/store/tela_conversa_bloc.dart';
import '../../../GeraRotas.dart';
import '../../../helper/Helper.dart';
import '../../../model/Contato.dart';
import '../../../model/Mensagem.dart';


class TelaConversa extends StatefulWidget {
  late Contato contato;
  TelaConversa({Key? key, required this.contato}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TelaConversaState();
}
class TelaConversaState extends State<TelaConversa> {
  final telaConversaBloc = getIt.get<TelaConversaBloc>();
  String idUserLogado = "";
  final TextEditingController _controllerTextoMsg = TextEditingController();
  final ScrollController _scrollController = ScrollController();


   getDataContact() async{
     await verificarUsuarioLogado();
   }

  verificarUsuarioLogado() async {
    final user = await telaConversaBloc.isLogged();
    if (user != null) {
       idUserLogado = user.uid.toString();
       await telaConversaBloc.listenerMenssagens(
           idUserLogado,
           widget.contato.idContato
       );
    } else {
      print("Erro ao recuperar o usuario");
      Navigator.pushNamedAndRemoveUntil(context, GerarRotas.ROUTE_LOGIN,(route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
      getDataContact();

    }

  @override
  void dispose() {
    telaConversaBloc.destroyListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
            appBar: AppBar(
              titleSpacing: -12,
              toolbarHeight: 70,
              title: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: widget.contato.foto.isEmpty
                        ?const AssetImage(Constants.IMGAGE_PATH_USARIO_ADD) as ImageProvider
                        :NetworkImage(widget.contato.foto),

                    maxRadius: 25,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 15,)),
                  Text(widget.contato.nome)
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
                child: Column(
                  children: <Widget>[
                    _blocListMensagen(widget.contato),
                     fieldSendMessage(widget.contato)
                  ],
                ),),
            ),
          );
  }

 Widget fieldSendMessage(Contato contato) {
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
                  IconButton(
                         icon:BlocBuilder<TelaConversaBloc,TelaConversaBlocState>(
                           bloc: telaConversaBloc,
                           builder: (context, state) {
                            return state is TelaConversaLoadingImageState
                              ?const Center(child: CircularProgressIndicator())
                              : const Icon(Icons.camera_alt);
                           }
                         ),
                         onPressed: () {
                          telaConversaBloc.enviarImagem(true,contato!,idUserLogado); //ENVIANDO DA CAMERA
                         },
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
                      final mensagem = Mensagem();
                      mensagem.tipo = "texto";
                      mensagem.msg = _controllerTextoMsg.text;
                      mensagem.data = Helper.formatarData(DateTime.now().toString());
                      mensagem.idRemetente = idUserLogado;
                      mensagem.idDestinatario =widget.contato.idContato;
                      mensagem.time = Timestamp.now().toString();
                      mensagem.url = "";

                        telaConversaBloc.enviarMensagem(mensagem,contato);
                       _controllerTextoMsg.clear();
                    }
                  },
                  child: const Icon(Icons.send),
                  backgroundColor: const Color(0xff075E54),
                )
              : CupertinoButton(child: const Text("Enviar"), onPressed: () {
                  if(_controllerTextoMsg.text.isNotEmpty){
                    final mensagem = Mensagem();
                    mensagem.tipo = "texto";
                    mensagem.msg = _controllerTextoMsg.text;
                    mensagem.data = Helper.formatarData(DateTime.now().toString());
                    mensagem.idRemetente = idUserLogado;
                    mensagem.idDestinatario =widget.contato.idContato;
                    mensagem.time = Timestamp.now().toString();
                    mensagem.url = "";

                    telaConversaBloc.enviarMensagem(mensagem,contato);
                    _controllerTextoMsg.clear();
            }
          })
        ],
      ),
    );
  }

  camposListMsg(List<Mensagem> mensgens) {
    return Expanded(
      child: ListView.builder(
          controller: _scrollController,
          itemCount: mensgens.length,
          itemBuilder: (context, index) {
            Mensagem mensagemItem = mensgens[index];

            //obtendo largura do container e ultilizando 80% para as msgs
            double larguraDoContainer = MediaQuery.of(context).size.width * 0.8;
            Alignment align = Alignment.centerRight;
            Color cor = const Color(0Xff8FBC8F);


            if ( idUserLogado == mensagemItem.idRemetente) {
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
                              title: mensagemItem.tipo == "texto"
                                  ? Text(
                                      mensagemItem.msg,
                                      style: const TextStyle(fontSize: 17),
                                    )
                                  : Image.network(mensagemItem.url),
                              trailing: Text(
                                mensagemItem.data,
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

/*  _stremListMensagen(Contato contato){
    return StreamBuilder(
      stream: telaConversaBloc.listenerMenssagens(widget.dataConversation.idRemetente,widget.dataConversation.idDestinatario),
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
  }*/
  _blocListMensagen(Contato contato) {

    return BlocConsumer(
      bloc: telaConversaBloc,
        listener: (BuildContext context,  state) {
            if(state is TelaConversaErrortState){

            }
        },
      builder: (context, state) {
          if(state is TelaConversaLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
            if (state is TelaConversaLoadedMessangetState) {
              Timer(const Duration(seconds: 1),(){
                _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
              });
              return camposListMsg(state.mensagem.isEmpty
                   ?[]
                   :state.mensagem
              );
            } else {
              return const Center(
                child: Text("msg"),
              );
            }
      },
    );
  }
}
