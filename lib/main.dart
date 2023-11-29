
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/GeraRotas.dart';
import 'package:whatsapp/firebase_options.dart';
import 'package:whatsapp/views/Login.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

 final ThemeData ios =ThemeData(
       colorScheme: ColorScheme.fromSwatch().copyWith(onSecondary: Color(0xff25D366)),
       primaryColor:Colors.grey[200],
      buttonTheme:const ButtonThemeData(
          buttonColor: Colors.white
      ), 
  ) ;

  final ThemeData temaPadrao =ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xff25D366)),
      primaryColor: Color(0xff075E54),
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