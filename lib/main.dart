
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:whatsapp/GeraRotas.dart';
import 'package:whatsapp/controller/Banco.dart';
import 'package:whatsapp/data/repository/IContactRepository.dart';
import 'package:whatsapp/data/repository/I_message_repository.dart';
import 'package:whatsapp/data/repository/i_conversa_repository.dart';
import 'package:whatsapp/data/repository/irepository_user.dart';
import 'package:whatsapp/data/repository/repositoryimpl/contacts_repository.dart';
import 'package:whatsapp/data/repository/repositoryimpl/conversar_repository.dart';
import 'package:whatsapp/data/repository/repositoryimpl/messager_repository.dart';
import 'package:whatsapp/data/service/authentication_service.dart';
import 'package:whatsapp/data/service/database_service.dart';
import 'package:whatsapp/data/service/storage_service.dart';
import 'package:whatsapp/firebase_options.dart';
import 'package:whatsapp/views/pages/aba_conversa_page/store/conversa_bloc.dart';
import 'package:whatsapp/views/pages/cadastro_page/stream/cadastro_bloc.dart';
import 'package:whatsapp/views/pages/configuracao_page/store/configuracao_bloc.dart';
import 'package:whatsapp/views/pages/conversa_page/store/tela_conversa_bloc.dart';
import 'package:whatsapp/views/pages/login_page/Login.dart';
import 'package:whatsapp/views/pages/login_page/store/validate_fields.dart';
import 'data/repository/repositoryimpl/user_repository_impl.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  getIt.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);
  getIt.registerSingleton<AuthenticationService>(AuthenticationService( getIt.get<FirebaseAuth>()));
  getIt.registerSingleton<DatabaseService>(DatabaseService( getIt.get<FirebaseFirestore>()));
  getIt.registerSingleton<StorageService>(StorageService(getIt.get<FirebaseStorage>()));

  getIt.registerSingleton<Banco>(Banco(
      getIt.get<FirebaseAuth>(),
      getIt.get<FirebaseFirestore>(),
      getIt.get<FirebaseStorage>()
  ));
  getIt.registerSingleton<IReposioryUser>(UserRepositoryImpl(
      getIt.get<AuthenticationService>(),
      getIt.get<DatabaseService>(),
      getIt.get<StorageService>()
  ));

  getIt.registerSingleton<IConversaRepository>(ConversaRepository(
      getIt.get<Banco>(),
      getIt.get<AuthenticationService>(),
      getIt.get<DatabaseService>(),
  ));
  getIt.registerSingleton<IContactRepository>(ContactRepository(
    getIt.get<DatabaseService>(),
    getIt.get<AuthenticationService>(),
  ));

  getIt.registerSingleton<IMessageRepository>(MessengerRepository(
    getIt.get<DatabaseService>(),
    getIt.get<StorageService>()
  ));


  getIt.registerSingleton<ValidateFieldsBloc>(ValidateFieldsBloc(getIt.get<IReposioryUser>()));
  getIt.registerSingleton<CadastroBloc>(CadastroBloc(getIt.get<IReposioryUser>()));
  getIt.registerSingleton<ConversaBloc>(ConversaBloc(
      getIt.get<IConversaRepository>(),
      getIt.get<IContactRepository>()
  ));
  getIt.registerSingleton<TelaConversaBloc>(TelaConversaBloc(
      getIt.get<IContactRepository>(),
      getIt.get<IMessageRepository>(),
      getIt.get<IReposioryUser>()
  ));

  getIt.registerSingleton(ConfiguracaoBloc(
    getIt.get<IReposioryUser>()
  ));


}
void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  final ThemeData ios =ThemeData(
       colorScheme: ColorScheme.fromSwatch().copyWith(onSecondary: const Color(0xff25D366)),
       primaryColor:Colors.grey[200],
      buttonTheme:const ButtonThemeData(
          buttonColor: Colors.white
      ),
  ) ;

  final ThemeData temaPadrao =ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xff25D366)),
      primaryColor: const Color(0xff075E54),
      buttonTheme:const ButtonThemeData(
          buttonColor: Colors.white
      )
  ) ;

  setupGetIt();
  runApp(MaterialApp(
        home: Login(),
            theme:Platform.isIOS?ios :temaPadrao,
          initialRoute: "/",
           onGenerateRoute: GerarRotas.inicializarRotas,
      ));
}