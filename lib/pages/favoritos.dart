import 'package:app_supermercado/class/produto.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_supermercado/pages/detalhe_produto.dart';
import '../commons/loading.dart';


class Favoritos extends StatefulWidget {
  @override
  _FavoritosState createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {

  //Criando uma lista de produtos que estão no banco de dados
  List<Produto> listProduct = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Favoritos", style: TextStyle(color: Colors.white ),),
        backgroundColor: Colors.lightBlue,
      ),

      body: StreamBuilder(
        stream: Firestore.instance.collection('favoritos').where('usuario', isEqualTo: 'marcelo@gmail.com').snapshots(),

        builder: (context, snapshot){
          if(!snapshot.hasData) return Loading();

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
                      padding:
                      EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
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
                      ],
                      ),
                    ),
                  ),
                );
              }
          );
        },
      ),
    );
  }
}
