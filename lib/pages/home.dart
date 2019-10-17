import 'package:app_supermercado/pages/semconexao.dart';
import 'package:app_supermercado/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:provider/provider.dart';
import 'package:app_supermercado/componentes/lista_horizontal.dart';
import 'package:app_supermercado/componentes/grid_produtos.dart';
import 'package:toast/toast.dart';
import 'busca_produto.dart';
import 'categorias.dart';
import 'favoritos.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_supermercado/pages/detalhe_produto.dart';
import 'package:connectivity/connectivity.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>{

  String _retorno, _value = "";
  Firestore _firestore = Firestore.instance;
  String ref = 'produtos';
  bool conexao;

  /*Realiza a leitura de um código de barras, pesquisa no banco,
  * e chama a route que mostra os detalhes do produto*/
  Future lerCodigoDeBarras() async{
    _retorno = await FlutterBarcodeScanner.scanBarcode("#004297", "Cancelar", true);

    setState((){
      _value = _retorno;
    });

    if(_value != null){
      _firestore.
      collection(ref).
      where('codBarras', isEqualTo: _value).
      getDocuments().
      then((snaps){
        if(snaps.documents.isNotEmpty){
          snaps.documents.forEach((document)=>{
            Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (context) => new DetalheProduto(
                      nome_detalhe_produto: document["descricao"].toString(),
                      preco_detalhe_produto: document["preco"].toString(),
                      figura_detalhe_produto: document["imagem"].toString(),
                    )))
          });
        }else{
          Navigator.pop(context);
        }
      });
    }else{
      Navigator.pop(context);
    }
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  Future testaConexao() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        conexao = true;
      });
    } else {
      setState(() {
        conexao = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    testaConexao();

    Widget image_carousel = Container(
        height: 200.0,
        child: new Carousel(
          boxFit: BoxFit.cover,
          images:[
            AssetImage('assets/image2.jpg'),
            AssetImage('assets/image3.jpg'),
            AssetImage('assets/image.jpg'),
            AssetImage('assets/image4.jpg'),
            AssetImage('assets/image5.jpg'),
          ],
          autoplay: true,
          autoplayDuration: const Duration(seconds: 3),
          dotSize: 4.0,
          indicatorBgPadding: 4.0,
          dotBgColor: Colors.transparent,
          borderRadius: true,
        )
    );

    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Supermercado Reis", style: TextStyle(color: Colors.white ),),
        backgroundColor: Colors.lightBlue,
        actions: <Widget>[
          IconButton(icon: (
              Icon(Icons.search, color: Colors.white)),
            onPressed:(){
                showSearch(context: context, delegate: DataSearch());
            },
          ),
        ],
      ),

      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
//            header
            new UserAccountsDrawerHeader(
              accountName: Text('Marcelo Rodrigues', style: TextStyle(color: Colors.white),),
              accountEmail: Text(user.user.email, style: TextStyle(color: Colors.white)),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white,),
                ),
              ),
              decoration: new BoxDecoration(
                  color: Colors.lightBlue
              ),
            ),

//            body

            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: ListTile(
                title: Text('Início'),
                leading: Icon(Icons.home),
              ),
            ),

            InkWell(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => Categorias()));
              },
              child: ListTile(
                title: Text('Categorias'),
                leading: Icon(Icons.format_list_bulleted),
              ),
            ),

            InkWell(
              onTap: (){

              },
              child: ListTile(
                onTap: (){
                    showSearch(context: context, delegate: DataSearch());
                },
                title: Text('Buscar'),
                leading: Icon(Icons.search),
              ),
            ),

            InkWell(
              onTap: (){

              },
              child: ListTile(
                onTap: (){
                  lerCodigoDeBarras();
                },
                title: Text('Consultar preço'),
                leading: Icon(Icons.camera),
              ),
            ),

            InkWell(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => Favoritos()));
              },
              child: ListTile(
                title: Text('Favoritos'),
                leading: Icon(Icons.favorite),
              ),
            ),

            Divider(),

            InkWell(
              onTap: (){
                user.signOut();
              },
              child: ListTile(
                title: Text('Sair'),
                leading: Icon(Icons.transit_enterexit, color: Colors.grey,),
              ),
            ),

          ],
        ),
      ),

      body:  conexao == false ? SemConexao() : new ListView(
        children: <Widget>[
          //imagens dinâmicas
          image_carousel,

          //categorias
          new Padding(padding: const EdgeInsets.all(8.0),
            child: new Text('Categorias',style: TextStyle(fontSize: 13),),),

          //lista horizontal
          ListaHorizontal(),

          //ofertas
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text('Ofertas',style: TextStyle(fontSize: 13),),
          ),

          //grid view
          Container(
            height: 380.0,
            child: GridProdutos(categoria_produtos: "ofertas"),
          )
        ],
      ),
    );
  }
}


class DataSearch extends SearchDelegate<String>{
  final produtos = ["Linguiça", "Farinha", "Iogurte", "Carne", "Arroz", "Farinha"];
  final recentes = ["Linguiça", "Farinha", "Iogurte", "Carne", "Arroz", "Farinha"];
  
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => Pesquisa(descricao_produto: listaDeSugestao[index], categoria_produto: "Ofertas")));
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

