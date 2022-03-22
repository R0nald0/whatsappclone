import 'package:flutter/material.dart';
import 'package:whatsapp/model/Conversa.dart';

class AbaConversa extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>AbaConversaState();

}

class AbaConversaState extends State<AbaConversa> {
  List<Conversa> listaCv =[
    Conversa("Margot Robbie ", "Ola","https://i0.wp.com/www.fashionbubbles."
        "com/wp-content/blogs.dir/1/files/2021/01/bill-7-1.png?fit=1256%2C750&ssl=1"),
    Conversa("Gal Gadot", "como vai?","https://i0.wp.com/www.fashionbubbles.com/wp-content/blogs."
        "dir/1/files/2021/01/modelo-israelense.png?w=796&ssl=1"),
    Conversa("Michael B. Jordan","Onde está?","https://assets.papodehomem.com.br"
        "/2019/11/22/14/24/27/ed724cee-8ea2-4b46-abee-161c92d79a1f/michaelbj-jpg"),
    Conversa("Helena Ranaldi", "Foi muito cedo","http://isinglemom.com/wp-content/uploads/2021/10/1-1.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(4),
        child: Expanded(
           child:ListView.builder(
               itemCount: listaCv.length,
               itemBuilder: (context,index){
                            Conversa conversa = listaCv[index];
                 return Card(
                    borderOnForeground: false,
                     margin: EdgeInsets.all(1),
                     child: ListTile(
                      contentPadding: EdgeInsets.fromLTRB(16,8,16,8),
                       leading: CircleAvatar(
                         backgroundImage: NetworkImage(conversa.fotoUrl,),
                         backgroundColor: Colors.grey,
                         maxRadius: 35,
                       ),
                       trailing:Text("1"),

                       title: Text(conversa.remetenteNome,
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 15
                       ),
                           ),
                       subtitle: Text(conversa.msg),
                     ),

                 );
                }
           ) ,
        ),
      ),
    );
  }
}