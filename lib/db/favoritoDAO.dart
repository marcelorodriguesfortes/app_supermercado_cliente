import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FavoritoDAO{
  Firestore _firestore = Firestore.instance;
  String ref = 'favoritos';

  void uploadProdutoFavorito({String usuario, String id, String descricao, double preco, String imagem}){
    //var id = Uuid();
    String idProduto = id;//id.v1();
    _firestore.collection(ref).
    document(idProduto).
    setData({'usuario': usuario,
             'idProduto': idProduto,
            'descricao': descricao,
            'preco': preco,
            'imagem': imagem
            });
  }

  void excluirProdutoFavorito(String usuario, String idProduto){
      try {
        _firestore
            .collection(ref)
            .document(idProduto)
            .delete();
      } catch (e) {
        print(e.toString());
      }
  }

  bool contemProduto(String usuario, String descricaoProduto){
    //Testa se o produto está na tabela Favoritos, e se está associado ao usuário que está logado
    bool valor = true;

    _firestore.
    collection(ref).
    where('usuario', isEqualTo: usuario).
    where('descricao', isEqualTo: descricaoProduto).
    getDocuments().
    then((snaps){
      if(snaps.documents.isNotEmpty) {
        valor = true;
        print('no documents found');
      }else
        valor = false;
    });

    return valor;
  }


  /*static Future<List<AustinFeedsMeEvent>> _getEventsFromFirestore() async {
    CollectionReference ref = Firestore.instance.collection('events');
    QuerySnapshot eventsQuery = await ref
        .where("time", isGreaterThan: new DateTime.now().millisecondsSinceEpoch)
        .where("food", isEqualTo: true)
        .getDocuments();

    HashMap<String, AustinFeedsMeEvent> eventsHashMap = new HashMap<String, AustinFeedsMeEvent>();

    eventsQuery.documents.forEach((document) {
      eventsHashMap.putIfAbsent(document['id'], () => new AustinFeedsMeEvent(
          name: document['name'],
          time: document['time'],
          description: document['description'],
          url: document['event_url'],
          photoUrl: _getEventPhotoUrl(document['group']),
          latLng: _getLatLng(document)));
    });

    return eventsHashMap.values.toList();
  }*/

  Future<List<DocumentSnapshot>> obterListaProdutosFavoritos(String usuario){
    _firestore.collection(ref).where('usuario', isEqualTo: usuario).getDocuments().then((snaps){return snaps.documents;});
  }

}