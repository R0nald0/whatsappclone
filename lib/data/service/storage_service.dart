import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import '../../helper/Constants.dart';

class StorageService{
   final FirebaseStorage _storageFirebase ;


    StorageService(this._storageFirebase);


   Future<UploadTask> salvarImagembd(String collectioPath,String imagePath,String idLoggedUser) async {
     if( collectioPath == Constants.COLLECTION_STORAGE_FOTO_PERFIL){
       Reference reference = _storageFirebase.ref();
       Reference caminho = reference
           .child(Constants.COLLECTION_STORAGE_FOTO_PERFIL)
           .child(" $idLoggedUser.jpg");
       UploadTask task = caminho.putFile(File(imagePath));

       return task;
     }else{
       Reference reference = _storageFirebase.ref();
       Reference caminho = reference
           .child(Constants.COLLECTION_CONVERSA_BD_NAME)
           .child(idLoggedUser)
           .child(DateTime.now().toString() + ".jpg");

       UploadTask task = caminho.putFile(File(imagePath));

       return task;
     }
  }

   Future<String> dowloadImage(TaskSnapshot snapshot) async {
      try{
         return await snapshot.ref.getDownloadURL();
       }catch(exeption){
         rethrow;
      }
   }

   Future<String> saveAndReturnImage( String collectioPath,String pathImage,String idUser) async{
    try{
      final uploadTask  =  await salvarImagembd(collectioPath ,pathImage, idUser);
      return  await dowloadImage(uploadTask.snapshot);
    }catch(ex){
      rethrow;
    }
   }
}
