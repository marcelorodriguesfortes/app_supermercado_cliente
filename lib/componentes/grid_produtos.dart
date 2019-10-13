import 'package:app_supermercado/class/produto.dart';
import 'package:app_supermercado/db/favoritoDAO.dart';
import 'package:app_supermercado/widget/itemgrid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_supermercado/pages/detalhe_produto.dart';


class GridProdutos extends StatefulWidget {
  final categoria_produtos;
  //Criando uma lista de produtos que estão no banco de dados
  List<Produto> listProduct = new List();

  GridProdutos({
    this.categoria_produtos,
  });

  @override
  _GridProdutosState createState() => _GridProdutosState();
}

class _GridProdutosState extends State<GridProdutos>{

  FavoritoDAO _favoritoDAO = FavoritoDAO();
  final databaseReference = Firestore.instance;
  String ref_favoritos = 'favoritos';
  String ref_produtos = 'produtos';
  Firestore _firestore = Firestore.instance;
  bool valor = false;
  //Criando uma lista de produtos que estão no banco de dados
  List<Produto> listProduct = new List();
  Produto produto;

  @protected
  @mustCallSuper
  void initState() {
    _firestore.collection(ref_produtos).getDocuments().
    then((snaps){
        snaps.documents.forEach((document) => {
          produto = new Produto(document['id'].toString(), document['descricao'].toString(), double.parse(document['preco'].toString()), document['imagem'].toString(), document['categoria'].toString()),
          listProduct.add(produto),
        });
    });
  }


  @override
  Widget build(BuildContext context) {
    //recebendo dados do banco de dados
        return GridView.builder(
            itemCount: listProduct.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index){

              return ItemGrid(imagem: listProduct[index].imagem, id: listProduct[index].id, usuario: "marcelo@gmail.com", descricao: listProduct[index].descricao, preco: listProduct[index].preco,);
            },
        );
  }

}

