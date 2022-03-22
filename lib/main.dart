
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/views/Login.dart';
import 'package:whatsapp/views/inicio.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
        home: Login(),
            theme:ThemeData(
              accentColor: Colors.red,
              primaryColor: Colors.green
            ) ,
      ));
}