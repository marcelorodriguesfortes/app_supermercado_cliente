import 'package:app_supermercado/componentes/grid_produtos.dart';
import 'package:flutter/material.dart';

import 'busca_produto.dart';

class ProdutosPorCategoria extends StatefulWidget {
  final categoria_produto;

  ProdutosPorCategoria({
    this.categoria_produto,
  });

  @override
  _ProdutosPorCategoriaState createState() => _ProdutosPorCategoriaState();
}

class _ProdutosPorCategoriaState extends State<ProdutosPorCategoria> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(widget.categoria_produto, style: TextStyle(color: Colors.white ),),
        backgroundColor: Colors.lightBlue,
        actions: <Widget>[
          IconButton(
            icon: (Icon(Icons.search, color: Colors.white)), onPressed: () {
            showSearch(context: context, delegate: DataSearch(widget.categoria_produto));
          },
          ),
        ],
      ),


      body: new ListView(
        children: <Widget>[
          Container(
            height: 700.0,
            child: GridProdutos(categoria_produtos: widget.categoria_produto),
          )
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String>{

  final categoria_produto;


  final produtos = ["Linguiça", "Farinha", "Iogurte", "Carne", "Arroz", "Farinha", "Iogurte", "Carne", "Arroz", "Farinha", "Iogurte", "Carne", "Arroz", "Farinha", "Iogurte", "Carne"];
  final recentes = ["Linguiça", "Farinha", "Iogurte", "Carne", "Arroz", "Farinha", "Iogurte", "Carne", "Arroz", "Farinha", "Iogurte", "Carne", "Arroz", "Farinha", "Iogurte", "Carne"];

  DataSearch(this.categoria_produto);

  @override
  List<Widget> buildActions(BuildContext context) {
    //actions for app bar
    return[
      IconButton(icon: Icon(Icons.clear), onPressed: (){
        query = "";
      })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow,
            progress: transitionAnimation),
        onPressed: (){
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final listaDeSugestao = query.isEmpty ? recentes : produtos.where((p)=>p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index)=>ListTile(
        onTap: (){
          //BuscaProdutos(descricao_produto: listaDeSugestao[index].substring(query.length));
          //showResults(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => Pesquisa(descricao_produto: listaDeSugestao[index], categoria_produto: categoria_produto,)));
          //Navigator.push(context, MaterialPageRoute(builder: (context) => Favoritos()));
        },
        leading: Icon(Icons.access_time),
        title: RichText(text: TextSpan(
            text: listaDeSugestao[index].substring(0,query.length),
            style: TextStyle(color: Colors.black, fontWeight:FontWeight.bold),
            children: [TextSpan(text: listaDeSugestao[index].substring(query.length),style: TextStyle(color: Colors.grey))
            ]
        )),),
      itemCount: listaDeSugestao.length,
    );
  }
}
