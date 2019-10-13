import 'package:flutter/material.dart';
import 'home.dart';


class DetalheProduto extends StatefulWidget {
  //toda vez que eu chamar esse widget, precisarei passar esses itens
  final nome_detalhe_produto;
  final preco_detalhe_produto;
  final figura_detalhe_produto;

  DetalheProduto({
    this.figura_detalhe_produto,
    this.nome_detalhe_produto,
    this.preco_detalhe_produto
  });

  @override
  _DetalheProdutoState createState() => _DetalheProdutoState();
}

class _DetalheProdutoState extends State<DetalheProduto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.lightBlue,
        title: InkWell(child: Text(widget.nome_detalhe_produto,style: TextStyle(color: Colors.white),),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => new HomePage()));
          },
        ),
              ),

      body: new ListView(
        children: <Widget>[
          new Container(
            height: 300.0,
            child:GridTile(
              child: Container(
              color: Colors.white,
              child: Image.network(widget.figura_detalhe_produto),
              ),
            )
          ),

          new Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.nome_detalhe_produto, style: TextStyle(fontSize: 20),),
                ),

                  Text("R\$" + widget.preco_detalhe_produto.toString(), style: TextStyle(fontSize: 25),),

              ],
            ),
          ),
          Divider(),
          new ListTile(
            title: new Text("Detalhes do produto"),
            subtitle: new Text("Lorem Ipsum é simplesmente uma simulação de "
                "texto da indústria tipográfica e de impressos, e vem sendo "
                "utilizado desde o século XVI, quando um impressor "
                "desconhecido pegou uma bandeja de tipos e os embaralhou "
                "para fazer um livro de modelos de tipos. Lorem Ipsum sobreviveu "
                "não só a cinco séculos, como também ao salto para a editoração "
                "eletrônica, permanecendo essencialmente inalterado."),
          ),
          Divider(),
        ],
      ),
    );
  }
}