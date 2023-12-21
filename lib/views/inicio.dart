import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class inicio extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>inicioState();
}

class inicioState extends State<inicio>{

  @override
  Widget build(BuildContext context) {

    return Scaffold(
       body: Container( 
          padding: EdgeInsets.all(30),
            child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  Container(
                    padding: const EdgeInsets.only(top:150),
                    child: Image.asset("images/logo.png",height: 250,width: 200),
                  ),
                  const CircularProgressIndicator(
                    color:Colors.green,
                  ),

                ],
              ),
            )
         ),

     );
  }

}
