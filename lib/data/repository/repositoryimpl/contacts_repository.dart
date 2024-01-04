import 'package:whatsapp/data/repository/IContactRepository.dart';
import 'package:whatsapp/data/service/authentication_service.dart';
import 'package:whatsapp/data/service/database_service.dart';
import 'package:whatsapp/model/Contato.dart';


class ContactRepository implements IContactRepository{
   final DatabaseService databaseService;
   final AuthenticationService authenticationService;
   ContactRepository(this.databaseService,this.authenticationService);

  @override
  Future<List<Contato>> getAllContacts()async{
     try{
       final user = authenticationService.verificarUsuarioLogado();
       final usuario = await databaseService.recuperarUsuario(user!);
       final listAllContact = await databaseService.recuperarContatos(usuario.email);

       return listAllContact.isEmpty
              ?[]
              :listAllContact;

     }catch(exceptions){
        rethrow ;
     }
  }

  Future<Contato> getContactData(String contactId) async{
      try{
         final contact = await databaseService.recuperarDadoContato(contactId);
         return contact;
      }catch(exeption){
        rethrow;
      }
  }
}