import 'package:app_supermercado/class/produto.dart';
import 'package:app_supermercado/db/favoritoDAO.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_supermercado/pages/detalhe_produto.dart';

import '../commons/loading.dart';


class ProdutosPorDescricao extends StatefulWidget {
  final descricao_produto;
  final categoria_produto;

  ProdutosPorDescricao({
    this.descricao_produto,
    this.categoria_produto
  });

  @override
  _ProdutosPorDescricaoState createState() => _ProdutosPorDescricaoState();
}

class _ProdutosPorDescricaoState extends State<ProdutosPorDescricao>{

  FavoritoDAO _favoritoDAO = FavoritoDAO();
  final databaseReference = Firestore.instance;
  String ref = 'favoritos';
  Firestore _firestore = Firestore.instance;
  bool valor = true;


  //Testa se o produto está na tabela Favoritos, e se está associado ao usuário que está logado
  bool contemProduto(String usuario, String descricaoProduto){
    _firestore.
    collection(ref).
    where('usuario', isEqualTo: usuario).
    where('descricao', isEqualTo: descricaoProduto).
    getDocuments().
    then((snaps){
      if(snaps.documents.isNotEmpty) {

        if (this.mounted) {
          setState(() {
            valor = true;
          });
        }
      }else{
        if (this.mounted) {
          setState(() {
            valor = false;
          });
        }
      }
    });
    return valor;
  }


  @override
  Widget build(BuildContext context) {
    //recebendo dados do banco de dados
    return StreamBuilder(
      stream: Firestore.instance.collection('produtos').where('descricao', isEqualTo:  widget.descricao_produto).where('categoria', isEqualTo:  widget.categoria_produto).snapshots(),

      builder: (context, snapshot){
        if(!snapshot.hasData)
          return Loading();

        //Criando uma lista de produtos que estão no banco de dados
        List<Produto> listProduct = new List();

        for (var document in snapshot.data.documents){
          Produto produto = new Produto(document['id'].toString(), document['descricao'].toString(), double.parse(document['preco'].toString()), document['imagem'].toString(), document['categoria'].toString());
          listProduct.add(produto);
        }

        return GridView.builder(
            itemCount: listProduct.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index){
              return Card(
                color: Colors.white,
                child: InkWell(

                  onTap: (){
                    Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (context) => new DetalheProduto(
                              nome_detalhe_produto: listProduct[index].descricao.toString(),
                              preco_detalhe_produto: listProduct[index].preco.toString(),
                              figura_detalhe_produto: listProduct[index].imagem.toString(),
                            )));
                  },

                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
                    child: Stack(children: <Widget>[

                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Expanded(child: Center(child: Image.network(listProduct[index].imagem.toString(), fit: BoxFit.cover,))),

                            Padding(
                              padding: EdgeInsets.all(1.0),
                              child: Center(
                                child: Text(
                                  listProduct[index].descricao.toString(),
                                  maxLines: 1,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.all(1.0),
                              child: Center(
                                child: Text(
                                  "R\$ " + listProduct[index].preco.toString(),
                                  maxLines: 1,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // action button
                      Positioned(
                        left: 90.0,
                        child: IconButton(
                          icon:  Icon(contemProduto("marcelo@gmail.com",listProduct[index].descricao) ? Icons.favorite : Icons.favorite_border, color: Colors.blue,),
                          onPressed: () {
                            if(contemProduto("marcelo@gmail.com",listProduct[index].descricao)){
                              //excluir da tabela de favoritos o produto que foi  clicado
                              _favoritoDAO.excluirProdutoFavorito("marcelo@gmail.com", listProduct[index].id);
                            }
                            else {
                              _favoritoDAO.uploadProdutoFavorito(
                                usuario: 'marcelo@gmail.com',
                                id: listProduct[index].id,
                                descricao: listProduct[index].descricao,
                                preco: listProduct[index].preco,
                                imagem: listProduct[index].imagem,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                    ),
                  ),
                ),
              );
            }
            );

      },
    );
  }

}

