import 'package:flutter/material.dart';

class Cart_products extends StatefulWidget {
  @override
  _Cart_productsState createState() => _Cart_productsState();
}

class _Cart_productsState extends State<Cart_products> {
  var products_on_the_cart = [
    {
      "name": "Blazer",
      "picture" : "assets/blazer1.jpeg",
      "price" : 25,
      "size" : "M",
      "color" : "Red",
      "quantity": 1,
    },
    {
      "name": "Dress",
      "picture" : "assets/dress1.jpeg",
      "price" : 12,
      "size" : "P",
      "color" : "Blue",
      "quantity": 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index){
          return Single_cart_product(
            cart_nome_produto: products_on_the_cart[index]["name"],
            cart_cor_produto: products_on_the_cart[index]["color"],
            cart_qtd_produto: products_on_the_cart[index]["quantity"],
            cart_tamanho_produto: products_on_the_cart[index]["size"],
            cart_preco_atual: products_on_the_cart[index]["price"],
            cart_imagem_produto: products_on_the_cart[index]["picture"],
          );
        });
  }
}

class Single_cart_product extends StatelessWidget {
  final cart_nome_produto;
  final cart_imagem_produto;
  final cart_preco_atual;
  final cart_tamanho_produto;
  final cart_cor_produto;
  final cart_qtd_produto;

  Single_cart_product({
    this.cart_nome_produto,
    this.cart_imagem_produto,
    this.cart_preco_atual,
    this.cart_tamanho_produto,
    this.cart_qtd_produto,
    this.cart_cor_produto
  });



  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        //====== figura do produto======
        leading: new Image.asset(cart_imagem_produto,
          width: 50.0,
          height: 80.0,
        ),

        //======= titulo da seção =============
        title: new Text(cart_nome_produto),

        //==========  elementos da lista =============
        subtitle: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
               //====this section is for the size of the product===
                Padding(
                 padding: const EdgeInsets.all(0.0),
                 child: new Text("Size: "),
               ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: new Text(cart_tamanho_produto,
                  style: TextStyle(color: Colors.lightBlue),),
                ),


                //========== this section is for the product color ================
                new Padding(padding: const EdgeInsets.fromLTRB(5.0, 2.0, 4.0, 4.0),
                child:  new Text("Color: "),),

                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: new Text(cart_cor_produto,
                    style: TextStyle(color: Colors.lightBlue),)
                ),
              ],
            ),

            //============this section is for the product price================
            new Container(
              alignment: Alignment.topLeft,
              child: new Text("\$${cart_preco_atual}",
                style: TextStyle(fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue),
              ),
            ),
          ],
        ),

        trailing: new Column(
          children: <Widget>[
            //new IconButton(icon: Icon(Icons.arrow_drop_up), onPressed: (){},),
            //new IconButton(icon: Icon(Icons.arrow_drop_up), onPressed: (){},),
            new Text("Corrigir"),
            new Text("$cart_qtd_produto"),
            new Text("Corrigir"),
            //new IconButton(icon: Icon(Icons.arrow_drop_down), onPressed: (){})
          ],
        ),
      ),
    );
  }

}

