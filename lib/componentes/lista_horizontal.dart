import 'package:app_supermercado/pages/lista_produto.dart';
import 'package:flutter/material.dart';

class ListaHorizontal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Category(
            url_imagem: 'assets/farinaceos.jpeg',
            categoria_produto: 'Farináceos',
          ),
          Category(
            url_imagem: 'assets/padaria.jpeg',
            categoria_produto: 'Padaria',
          ),
          Category(
            url_imagem: 'assets/verduras.jpeg',
            categoria_produto: 'Vegetais',
          ),
          Category(
            url_imagem: 'assets/bebidas.png',
            categoria_produto: 'Bebidas',
          ),
          Category(
            url_imagem: 'assets/carne.jpg',
            categoria_produto: 'Carnes e Frios',
          ),
          Category(
            url_imagem: 'assets/limpeza.jpeg',
            categoria_produto: 'Limpeza',
          ),
          Category(
            url_imagem: 'assets/utilidades.jpeg',
            categoria_produto: 'Utilidades',
          ),

        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String url_imagem;
  final String categoria_produto;

  //construtor
  Category({this.categoria_produto, this.url_imagem});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(1.0),
        child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProdutosPorCategoria(categoria_produto: categoria_produto)));
            },
            child: Container(
                width: 100.0,
                height: 100.0,
                color: Colors.white,
                child: ListTile(
                  title: Image.asset(
                    url_imagem,
                    width: 50.0,
                    height: 80.0,
                  ),
                  subtitle: Container(
                    alignment: Alignment.topCenter,
                    child: Text(categoria_produto, style: TextStyle(fontSize: 12.0),),
                  ),
                ))));
  }
}
