import '../../model/Contato.dart';

abstract class IContactRepository {
  Future<List<Contato>> getAllContacts();

  Future<Contato> getContactData(String contactId);
}
