import 'package:flutter/material.dart';

import 'lista_produto.dart';

class Categorias extends StatefulWidget {
  @override
  _CategoriasState createState() => _CategoriasState();
}

class _CategoriasState extends State<Categorias> {

  var categorias = [
    {
      "name": "Limpeza",
      "picture" : "assets/limpeza.jpeg",
    },
    {
      "name": "Utilidades",
      "picture" : "assets/utilidades.jpeg",
    },
    {
      "name": "Padaria",
      "picture" : "assets/padaria.jpeg",
    },
    {
      "name": "Bebidas",
      "picture" : "assets/bebidas.png",
    },
    {
      "name": "Vegetais",
      "picture" : "assets/verduras.jpeg",
    },
    {
      "name": "Farináceos",
      "picture" : "assets/farinaceos.jpeg",
    },
    {
      "name": "Carnes e Frios",
      "picture" : "assets/carne.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {

   return Scaffold(
        appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Categorias", style: TextStyle(color: Colors.white ),),
        backgroundColor: Colors.lightBlue,
       ),

        body: new ListView.builder(
            itemCount: categorias.length,
            itemBuilder: (context, index){
              return produtos(
                nome_grupo_produto: categorias[index]["name"],
                imagem_produto: categorias[index]["picture"],
              );
            }),
    );
  }
}

class produtos extends StatelessWidget {
  final nome_grupo_produto;
  final imagem_produto;


  produtos({
    this.nome_grupo_produto,
    this.imagem_produto,
  });


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProdutosPorCategoria(categoria_produto: nome_grupo_produto)));
        },
        //====== figura do produto======
        leading: new Image.asset(imagem_produto,
          width: 60.0,
          height: 100.0,
        ),

        //======= titulo da seção =============
        title: new Text(nome_grupo_produto),
      ),
    );
  }

}

