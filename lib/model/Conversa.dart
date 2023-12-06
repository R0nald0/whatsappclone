import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:whatsapp/controller/Banco.dart';
import 'package:whatsapp/helper/Constants.dart';


class Conversa {
   String _idDestinatario ="";
   String _idRemetente= "";
   String _remetenteNome ="";
   String _msg ="";
   String _fotoUrl ="";
   String _tipo="";
   String _urlImagenConversa ="";
   String _data ="";

  Conversa(this._remetenteNome,this._idDestinatario,this._msg);


  Future salvarConversaBd() async {
    Banco bd = Banco();
    await bd.firestore
        .collection(Constants.COLLECTION_CONVERSA_BD_NAME)
        .doc(this.idRemetente)
        .collection(Constants.COLLECTION_ULTIMA_CONVERSA_BD_NAME)
        .doc(this.idDestinatario)
        .set(this.toMap());
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "remetenteNome": this.remetenteNome,
      "UltimaMsg": this.msg,
      "fotoUrlRemetente": this.fotoUrl,
      "idRemetente": this.idRemetente,
      "idDestinatario": this.idDestinatario,
      "tipo": this.tipo,
      "_urlImagenConversa": this.urlImagenConversa
    };
    return map;
  }

   Conversa.fromMap(DocumentSnapshot<Map<String,dynamic>> map){
     remetenteNome= map["remetenteNome"];
     msg= map["UltimaMsg"];
     _idRemetente= map["idRemetente"];
     idDestinatario= map["idDestinatario"];
     tipo= map["tipo"];
     urlImagenConversa= map["_urlImagenConversa"];

  }



  String get data => _data;

  set data(String value) {
    _data = value;
  }

  String get urlImagenConversa => _urlImagenConversa;

  set urlImagenConversa(String value) {
    _urlImagenConversa = value;
  }

  String get idDestinatario => _idDestinatario;

  set idDestinatario(String value) {
    _idDestinatario = value;
  }

  String get fotoUrl => _fotoUrl;

  set fotoUrl(String value) {
    _fotoUrl = value;
  }

  String get msg => _msg;

  set msg(String value) {
    _msg = value;
  }

  String get remetenteNome => _remetenteNome;

  set remetenteNome(String value) {
    _remetenteNome = value;
  }

  String get idRemetente => _idRemetente;

  set idRemetente(String value) {
    _idRemetente = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }
}
