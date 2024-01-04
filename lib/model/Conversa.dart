import 'package:cloud_firestore/cloud_firestore.dart';


class Conversa {
   String _idDestinatario ="";
   String _idRemetente= "";
   String _remetenteNome ="";
   String _msg ="";
   String _fotoUrl ="";
   String _tipo="";
   String _urlImagenConversa ="";
   String _data ="";

  Conversa(this._idRemetente,this._idDestinatario,this._msg);


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
