import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import '../../helper/Constants.dart';

class StorageService{
   final FirebaseStorage _storageFirebase ;


    StorageService(this._storageFirebase);


   Future<UploadTask> salvarImagembd(String imagePath,String idLoggedUser) async {

    Reference reference = _storageFirebase.ref();
    Reference caminho = reference
        .child(Constants.COLLECTION_CONVERSA_BD_NAME)
        .child(idLoggedUser)
        .child(DateTime.now().toString() + ".jpg");

    UploadTask task = caminho.putFile(File(imagePath));

    return task;
  }

   Future<String> dowloadImage(TaskSnapshot snapshot) async {
      try{
         return await snapshot.ref.getDownloadURL();
       }catch(exeption){
         rethrow;
      }
   }

   Future<String> saveImage(String pathImage,String idUser) async{
    try{
      final uploadTask  =  await salvarImagembd(pathImage, idUser);
      return  await dowloadImage(uploadTask.snapshot);
    }catch(ex){
      rethrow;
    }
   }
}
