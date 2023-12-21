import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';


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

   static String formatarData(String data) {
       initializeDateFormatting("pt-BR");
      DateTime dateTime = DateTime.parse(data);
      print("data time $dateTime" );
      String dataConvertida = DateFormat.Hm().format(dateTime);
      print("data " + dataConvertida);

      return dataConvertida;
    }

}