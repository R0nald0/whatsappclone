import 'package:flutter/material.dart';

class Helper{
    static  mostrarSnackBar(BuildContext context,String messenger){

     var snackBar = SnackBar(
         content: Text(
           messenger,
           style: const TextStyle(
               fontSize: 18
           ),
         )
     );
     ScaffoldMessenger.of(context).showSnackBar(snackBar);
   }
}