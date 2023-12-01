
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/GeraRotas.dart';
import 'package:whatsapp/firebase_options.dart';
import 'package:whatsapp/views/pages/login_page/Login.dart';

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

  runApp(MaterialApp(
        home: Login(),
            theme:Platform.isIOS?ios :temaPadrao,
          initialRoute: "/",
           onGenerateRoute: GerarRotas.inicializarRotas,
      ));
}