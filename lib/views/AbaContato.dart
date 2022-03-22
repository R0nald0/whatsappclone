import 'package:flutter/material.dart';
import 'package:whatsapp/model/Contato.dart';

class AbaContato extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>AbaContatoState();

}

class AbaContatoState extends State<AbaContato> {
  List<Contato> listaCt =[
    Contato("Margot Robbie ", "MargotRobbie@gmail.com ", "https://i0.wp.com/www.fashionbubbles."
        "com/wp-content/blogs.dir/1/files/2021/01/bill-7-1.png?fit=1256%2C750&ssl=1"),
    Contato("Gal Gadot", "GalGado@hotmail.com","https://i0.wp.com/www.fashionbubbles.com/wp-content/blogs."
        "dir/1/files/2021/01/modelo-israelense.png?w=796&ssl=1"),
    Contato("Michael B. Jordan","MichaelBJordan@hotmail.com","https://assets.papodehomem.com.br"
        "/2019/11/22/14/24/27/ed724cee-8ea2-4b46-abee-161c92d79a1f/michaelbj-jpg"),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(10),
         child: Expanded(
           child: ListView.builder(
               itemCount: listaCt.length,
               itemBuilder: (context,index){
                    Contato contato = listaCt[index];

                 return ListTile(
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                   leading: CircleAvatar(
                     backgroundImage:NetworkImage(contato.foto),
                     maxRadius: 30,
                     backgroundColor: Colors.green,
                   ),
                   trailing: Icon(Icons.message_rounded,color: Colors.green),
                   title: Text(contato.nome),
                   subtitle: Text(contato.email),
                 );
               }
           
           ),
         ),

      ),
    );
  }
}