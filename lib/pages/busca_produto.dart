import 'package:app_supermercado/componentes/grid_produtos.dart';
import 'package:app_supermercado/componentes/produtos_por_nome.dart';
import 'package:flutter/material.dart';

class Pesquisa extends StatefulWidget {
  final descricao_produto;
  final categoria_produto;

  Pesquisa({
    this.descricao_produto,
    this.categoria_produto
  });

  @override
  _PesquisaState createState() => _PesquisaState();
}

class _PesquisaState extends State<Pesquisa> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(widget.descricao_produto, style: TextStyle(color: Colors.white ),),
        backgroundColor: Colors.lightBlue,
      ),


      body: new ListView(
        children: <Widget>[
          Container(
            height: 700.0,
            child: ProdutosPorDescricao(descricao_produto: widget.descricao_produto, categoria_produto: widget.categoria_produto),
          )
        ],
      ),
    );
  }
}
