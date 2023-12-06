import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:whatsapp/controller/Banco.dart';
import 'package:whatsapp/model/Conversa.dart';
import 'package:whatsapp/model/Mensagem.dart';
import 'package:whatsapp/model/Usuario.dart';
import '../model/Contato.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';

class TelaConversa extends StatefulWidget {
  late Contato contatocv;
  TelaConversa(this.contatocv);

  @override
  State<StatefulWidget> createState() => TelaConversaState();
}

class TelaConversaState extends State<TelaConversa> {
  Mensagem _mensagem = Mensagem();
  final _controller = StreamController<QuerySnapshot>.broadcast();
  final ImagePicker _picker = ImagePicker();
  String idUserLogado = "";
  String idDestinatario = "";
  late XFile imagem;
  bool subindoImagem = false;
  String urlImage = "";

  Banco _db = Banco();
  TextEditingController _controllerTextoMsg = TextEditingController();
  ScrollController _scrollController = ScrollController();

  Future _enviarImagem(bool isCamera) async {
    XFile? arquivo;
    if (isCamera) {
      arquivo = await _picker.pickImage(source: ImageSource.camera);
    } else {
      arquivo = await _picker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      imagem = arquivo!;
    });

    salvarImagembd();
  }

  salvarImagembd() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref();
    Reference caminho = reference
        .child("conversa")
        .child(idUserLogado)
        .child(DateTime.now().toString() + ".jpg");

    UploadTask task = caminho.putFile(File(imagem!.path));

    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      if (snapshot.state == TaskState.running) {
        setState(() {
          subindoImagem = true;
        });
      } else if (snapshot.state == TaskState.success) {
        setState(() {
          subindoImagem = false;
          dowloadImage(snapshot);
        });
      }
    });
  }

  Future dowloadImage(TaskSnapshot snapshot) async {
    String uri = await snapshot.ref.getDownloadURL();
    setState(() {
      urlImage = uri;
    });
    _mensagem.tipo = "imagem";
    _mensagem.msg = " ";
    _mensagem.data = _formatarData(DateTime.now().toString());
    _mensagem.idRemetente = idUserLogado;
    _mensagem.idDestinatario = idDestinatario;
    _mensagem.time = Timestamp.now().toString();
    _mensagem.url = urlImage;

    await _mensagem.salvarMensagem();
    await _db.salvarDestinatarioMensagem(_mensagem);
    salvarConversa(_mensagem);
  }

  _formatarData(String data) {
    initializeDateFormatting("pt_BR");
    DateTime dateTime = DateTime.parse(data);
    String dataConvertida = DateFormat.Hm().format(dateTime);
    print("data " + dataConvertida);

    return dataConvertida;
  }

  _enviarMensagem(String texto, String remtente, String destinatario,
      {url}) async {
    texto = _controllerTextoMsg.text;
    if (texto.isNotEmpty) {
      _mensagem.tipo = "texto";
      _mensagem.msg = texto;
      _mensagem.data = _formatarData(DateTime.now().toString());
      _mensagem.idRemetente = remtente;
      _mensagem.idDestinatario = destinatario;
      _mensagem.time = Timestamp.now().toString();
      _mensagem.url = "";

      _mensagem.salvarMensagem();
      await _db.salvarDestinatarioMensagem(_mensagem);

      salvarConversa(_mensagem);
    }
  }

  Future salvarConversa(Mensagem mensagem) async {
    Usuario usuario = await Usuario().dadosUser(idUserLogado);
    Conversa cRementent = Conversa(
        mensagem.idRemetente,
        mensagem.idDestinatario,
        mensagem.url
    );

    cRementent.data = mensagem.data;
    cRementent.idDestinatario = mensagem.idDestinatario;
    cRementent.idRemetente = mensagem.idRemetente;
    cRementent.urlImagenConversa = mensagem.url;
    cRementent.tipo = mensagem.tipo;
    cRementent.msg = mensagem.msg;
    cRementent.fotoUrl = widget.contatocv.foto;
    cRementent.remetenteNome = widget.contatocv.nome;

    cRementent.salvarConversaBd();

    Conversa cDestinatrio = Conversa(
       mensagem.idRemetente,
        mensagem.idDestinatario,
        mensagem.url
    );
    cDestinatrio.idDestinatario = mensagem.idRemetente;
    cDestinatrio.idRemetente = mensagem.idDestinatario;
    cDestinatrio.tipo = mensagem.tipo;
    cDestinatrio.urlImagenConversa = mensagem.url;
    cDestinatrio.msg = mensagem.msg;
    cDestinatrio.fotoUrl = usuario.fotoPerfil;
    cDestinatrio.remetenteNome = usuario.nome;
    cDestinatrio.data = mensagem.data;

    cDestinatrio.salvarConversaBd();
  }

  Stream<QuerySnapshot> _adicionarListenerMensagens() {
    var stream = _db.firestore
        .collection("mensagen")
        .doc(idUserLogado)
        .collection(idDestinatario)
        .orderBy("time", descending: false)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
      Timer(Duration(seconds: 1),(){
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
    return _controller.stream;
  }

  verificarUsuarioLogado() async {
    User? user = await _db.verificarUsuarioLogado();
    if (user != null) {
      idUserLogado = user.uid.toString();
      idDestinatario = widget.contatocv.idContato;

      _adicionarListenerMensagens();
    } else {
      print("Erro ao recuperar o usuario");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verificarUsuarioLogado();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _controller.close();
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
            Padding(
                padding: EdgeInsets.only(
              left: 15,
            )),
            Text(widget.contatocv.nome)
          ],
        ),
        backgroundColor: Color(0xff075E54),
      ),
      body: Container(
        padding: EdgeInsets.all(3),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bg.png"), fit: BoxFit.cover)),
        child: SafeArea(
            child: Container(
          child: Column(
            children: <Widget>[_stremListMensagen(), campoMsg()],
          ),
        )),
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
            Color cor = Color(0Xff8FBC8F);

            if (idUserLogado == mensagemItem["idRemetente"]) {
              align;
              cor;
            } else {
              align = Alignment.centerLeft;
              cor = Color(0xfff4f7d4);
            }

            return Align(
              alignment: align,
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    width: larguraDoContainer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: cor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 5, 16, 5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: mensagemItem["tipo"] == "texto"
                                  ? Text(
                                      mensagemItem["mensagem"],
                                      style: TextStyle(fontSize: 17),
                                    )
                                  : Image.network(mensagemItem["url"]),
                              trailing: Text(
                                mensagemItem["data"],
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          ]),
                    ),
                  )),
            );
          }),
    );
  }

  campoMsg() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controllerTextoMsg,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  icon: subindoImagem != false
                      ? Center(child: CircularProgressIndicator())
                      : Icon(Icons.camera_alt),
                  onPressed: () {
                    _enviarImagem(true); //ENVIANDO DA CAMERA
                  },
                ),
                hintText: "Digite uma Menssagem...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                contentPadding: EdgeInsets.fromLTRB(16, 15, 16, 15),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 8)),
          Platform.isAndroid
              ? FloatingActionButton(
                  onPressed: () {
                    _enviarMensagem(_controllerTextoMsg.text, idUserLogado,
                        widget.contatocv.idContato);
                    _controllerTextoMsg.clear();
                  },
                  child: Icon(Icons.send),
                  backgroundColor: Color(0xff075E54),
                )
              : CupertinoButton(child: Text("Enviar"), onPressed: () {
            _enviarMensagem(_controllerTextoMsg.text, idUserLogado,
                widget.contatocv.idContato);
            _controllerTextoMsg.clear();
          })
        ],
      ),
    );
  }

  _stremListMensagen() {
    return StreamBuilder(
      stream: _controller.stream,
      builder: (context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasData) {
              QuerySnapshot querySnapshot = snapshot.data;

              return camposListMsg(querySnapshot);
            } else {
              print("dados" + snapshot.hasError.toString());
            }
        }

        return Center(
          child: Text("msg"),
        );
      },
    );
  }
}
