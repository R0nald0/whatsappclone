import 'package:flutter/material.dart';

class Helper{
    String textoAviso="";

    static  mostrarSnackBar(context){

     final snackBar = SnackBar(
         content:  Text(
           "sucesso",
           style: TextStyle(
               fontSize: 20
           ),
         )
     );
     ScaffoldMessenger.of(context).showSnackBar(snackBar);
   }
}