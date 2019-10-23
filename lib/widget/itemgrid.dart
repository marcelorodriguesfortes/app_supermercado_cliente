import 'package:app_supermercado/class/produto.dart';
import 'package:app_supermercado/db/favoritoDAO.dart';
import 'package:app_supermercado/pages/detalhe_produto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';

class ItemGrid extends StatefulWidget {
  final String imagem;
  final String id;
  final String usuario;
  final String descricao;
  final double preco;

  ItemGrid({
    this.imagem,
    this.id,
    this.usuario,
    this.descricao,
    this.preco
  });

  @override
  _ItemGridState createState() => _ItemGridState();
}

class _ItemGridState extends State<ItemGrid> {
  final FlareControls flareControls = FlareControls();
  bool isLiked = true;
  FavoritoDAO _favoritoDAO = FavoritoDAO();
  final databaseReference = Firestore.instance;
  String ref_favoritos = 'favoritos';
  String ref_produtos = 'produtos';
  Firestore _firestore = Firestore.instance;

  @override
  void initState() {
    contemProduto(widget.usuario, widget.id);
  }


  //Testa se o produto está na tabela Favoritos, e se está associado ao usuário que está logado
  void contemProduto(String usuario, String id){
    _firestore.
    collection(ref_favoritos).
    where('usuario', isEqualTo: usuario).
    where('idProduto', isEqualTo: id).
    getDocuments().
    then((snaps){
      if(snaps.documents.isNotEmpty) {
        if (this.mounted) {
          setState(() {
            isLiked = true;
          });
        }
      }else{
        if (this.mounted) {
          setState(() {
            isLiked = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: Colors.white,
      child: InkWell(
        onDoubleTap: (){
            if(isLiked){
              _favoritoDAO.excluirProdutoFavorito(widget.usuario, widget.id);
              setState(() {
                isLiked = !isLiked;
              });
              flareControls.play("like");
            }else{
              _favoritoDAO.uploadProdutoFavorito(
                usuario: widget.usuario,
                id: widget.id,
                descricao: widget.descricao,
                preco: widget.preco,
                imagem: widget.imagem,
              );
              setState(() {
                isLiked = !isLiked;
              });
              flareControls.play("like");
            }
        },
        onTap: (){
          Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (context) => new DetalheProduto(
                    nome_detalhe_produto: widget.descricao,
                    preco_detalhe_produto: widget.preco,
                    figura_detalhe_produto: widget.imagem,
                  )));
        },
        child: Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      Expanded(child: Center(child: Image.network(widget.imagem, fit: BoxFit.cover,))),

                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  iconSize: 30,
                                  icon: Icon(isLiked ? Icons.shopping_cart : Icons.add_shopping_cart, color: Colors.blue, size: 20.0,),
                                  onPressed: () {
                                    if(isLiked){
                                      _favoritoDAO.excluirProdutoFavorito(widget.usuario, widget.id);
                                      setState(() {
                                        isLiked = !isLiked;
                                      });
                                      flareControls.play("like");
                                    }else{
                                      _favoritoDAO.uploadProdutoFavorito(
                                        usuario: widget.usuario,
                                        id: widget.id,
                                        descricao: widget.descricao,
                                        preco: widget.preco,
                                        imagem: widget.imagem,
                                      );
                                      setState(() {
                                        isLiked = !isLiked;
                                      });
                                      flareControls.play("like");
                                    }

                                  },
                                ),
                                Text(widget.descricao)
                              ],
                            ),
                          ),

                        ],
                      ),


                      Text("R\$ " + widget.preco.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 18), ),

                    ],
                  ),
                ),

                Container(
                  width: double.infinity,
                  height: 250,
                  child: Center(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: FlareActor(
                        'assets/instagram_like.flr',
                        controller: flareControls,
                        animation: 'idle',
                      ),
                    ),
                  ),
                ),

              ],
            ),

        ),
      ),
    );





    /*Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onDoubleTap: () {
            setState(() {
              isLiked = !isLiked;
            });
            flareControls.play("like");
          },
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/arroz.jpg'))),
                    ),
                  ),
                ],
              ),

              Container(
                width: double.infinity,
                height: 250,
                child: Center(
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: FlareActor(
                      'assets/instagram_like.flr',
                      controller: flareControls,
                      animation: 'idle',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  IconButton(
                    iconSize: 30,
                    icon:
                        Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                    onPressed: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                      flareControls.play("like");
                    },
                  ),
                  IconButton(
                    iconSize: 30,
                    icon: Icon(Icons.comment),
                    onPressed: () {},
                  )
                ],
              ),
            ),

          ],
        )
      ],
    );*/
  }
}
