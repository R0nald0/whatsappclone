import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/GeraRotas.dart';
import 'package:whatsapp/helper/Constants.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:whatsapp/views/pages/configuracao_page/store/configuracao_bloc.dart';
import 'package:whatsapp/views/pages/configuracao_page/store/configuracao_state.dart';


class TelaConfiguracao extends StatefulWidget {
  
  const TelaConfiguracao({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TelaConfiguracaoState();
}

class TelaConfiguracaoState extends State<TelaConfiguracao> {
  final _telaConfiguracaoBloc= ConfiguracaoBloc();
  final TextEditingController _controllerNome = TextEditingController();



  @override
  void initState() {
    super.initState();
    _telaConfiguracaoBloc.getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações"),
        backgroundColor: const Color(0xff075E54),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
                   BlocBuilder<ConfiguracaoBloc,ConfiguracaoState>(
                     bloc: _telaConfiguracaoBloc,
                     builder: (context, state) {
                       if(state is ConfiguracaoLoadingState){
                          return const Center(child: CircularProgressIndicator());
                       }else if (state is ConfiguracaoUpdatedState){
                         return Padding(
                           padding: const EdgeInsets.only(top: 10, bottom: 10),
                           child: CircleAvatar(
                             backgroundColor: Colors.grey,
                             backgroundImage: state.usuario.fotoPerfil.isNotEmpty
                                 ?NetworkImage(state.usuario.fotoPerfil) as ImageProvider
                                 :const AssetImage(Constants.IMGAGE_PATH_USARIO_ADD),
                             radius: 150,
                           ),
                         );
                       }else{
                         return const Center(child: Text("No Image Profile"),);
                       }
                     }
                   ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                     _telaConfiguracaoBloc.recuperarImage(true);
                    },
                    child: const Text(
                      "Camera",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        _telaConfiguracaoBloc.recuperarImage(false);
                      },
                      child: const Text(
                        "Galeria",
                        style: TextStyle(fontSize: 16),
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 16),
                child: BlocBuilder<ConfiguracaoBloc,ConfiguracaoState>(
                  bloc: _telaConfiguracaoBloc,
                  builder: (context, state) {
                      return TextField(
                        controller: _controllerNome,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32)),
                            contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                            labelText: _telaConfiguracaoBloc.nameUser.isNotEmpty
                                   ?_telaConfiguracaoBloc.nameUser
                                   :"Digite seu nome"
                        ),
                      );

                  }
                ),
              ),
              BlocConsumer<ConfiguracaoBloc,ConfiguracaoState>(
                bloc: _telaConfiguracaoBloc,
                  listener: (BuildContext context, ConfiguracaoState state) {
                     if(state is ConfiguracaoErrrolState){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.errorMessenger))
                        );
                     }
                  },
                builder: (context, state) {
                  if(state is ConfiguracaoLoadingState){
                     return const Center(child: CircularProgressIndicator());
                  }else{
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16)),
                        onPressed: () {
                          final usuario = Usuario();
                          usuario.nome = _controllerNome.text;
                          _telaConfiguracaoBloc.validateField(usuario);
                          Navigator.pushNamedAndRemoveUntil(context, GerarRotas.ROUTE_HOME, (route) => false);
                        },
                        child: const Text(
                          "Atualizar",
                          style: TextStyle(fontSize: 17),
                        ),);
                     }
                  },
              )
            ],
          ),
        )),
      ),
    );
  }
}
