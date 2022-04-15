import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TelaConfiguracao extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TelaConfiguracaoState();
}

class TelaConfiguracaoState extends State<TelaConfiguracao> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  final ImagePicker _picker = ImagePicker();
  XFile? _arquivo;
  String UrlimgPerfil ="";
  TextEditingController _controllerNome = TextEditingController();
  late String _idUsuario;
  bool isDownload = false;
  late String _userNome = "";
  late String _fotoPerfil ="";

  Future recuperarImage(bool isCamera) async {
    XFile? image;
    if (isCamera) {
      image = await _picker.pickImage(source: ImageSource.camera);
    } else {
      image = await _picker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      _arquivo = image;
    });

    salvarImgPerfil();
  }

  Future salvarImgPerfil() async {
    FirebaseStorage storage = FirebaseStorage.instance;

    Reference reference = storage.ref();
    Reference caminho =
        reference.child("fotosPerfil").child(" ${_auth.currentUser?.uid}.jpg");

    UploadTask task = caminho.putFile(File(_arquivo!.path));

    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      if (snapshot.state == TaskState.running) {
        setState(() {
          isDownload = true;

        });
      } else if (snapshot.state == TaskState.success) {
        setState(() {
          isDownload = false;
          _dowloadImagem(snapshot);
        });
      }
    });
  }

  Future _dowloadImagem(TaskSnapshot snapshot) async {
    String img = await snapshot.ref.getDownloadURL();
    setState(() {
      UrlimgPerfil = img;
    });
  }

  Future _dadosUser() async {
    FirebaseFirestore bd = FirebaseFirestore.instance;
    DocumentSnapshot _snapshot =
        await bd.collection("usuario").doc(_idUsuario).get();

    setState(() {
      _userNome = _snapshot.get("nome");
      UrlimgPerfil = _snapshot.get("fotoPerfil");
    });
  }

  Future _atulizarImgPerfil() async {
    FirebaseFirestore bd = FirebaseFirestore.instance;

    Map<String, dynamic> img = {
      "fotoPerfil": UrlimgPerfil,
      "nome": _controllerNome.text
    };

     if(img["nome"].toString().length == 0 ){
          img["nome"] = _userNome;
          bd.collection("usuario").doc(_idUsuario).update(img);
         print("NOME " + img["nome"]);
         final snackBar = SnackBar(
             content: Text("Perfil Atualizado")
         );
         ScaffoldMessenger.of(context).showSnackBar(snackBar);
     }else{

       bd.collection("usuario").doc(_idUsuario).update(img);
       final snackBar = SnackBar(
           content: Text("Perfil Atualizado")
       );
       ScaffoldMessenger.of(context).showSnackBar(snackBar);

     }

  }

  Future verificarUSer() async {
    User? user = await _auth.currentUser;
    if (user != null) {

      setState(() {
        _idUsuario = user.uid.toString();
        _dadosUser();
      });
    } else {
      print("dados usuario ivalido");
    }
  }

  @override
  void initState() {

    super.initState();
    verificarUSer();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
        backgroundColor: Color(0xff075E54),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
                     isDownload == true? Center(child: CircularProgressIndicator()):
                   Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: UrlimgPerfil.length == 0?null:NetworkImage(UrlimgPerfil),
                        radius: 150,
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      recuperarImage(true);
                    },
                    child: Text(
                      "Camera",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        recuperarImage(false);
                      },
                      child: Text(
                        "Galeria",
                        style: TextStyle(fontSize: 16),
                      ))
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 16),
                child: TextField(
                  controller: _controllerNome,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32)),
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      labelText: _userNome

                  ),
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16)),
                  onPressed: () {
                    _atulizarImgPerfil();
                  },
                  child: Text(
                    "Salvar",
                    style: TextStyle(fontSize: 17),
                  ))
            ],
          ),
        )),
      ),
    );
  }
}
