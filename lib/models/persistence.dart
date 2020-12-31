import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rapido/rapido.dart';

class ModelPersistenceProvider<T> implements PersistenceProvider {
  @override
  Future deleteDocument(Document doc) {
    // TODO: implement deleteDocument
    throw UnimplementedError();
  }

  @override
  Future loadDocuments(DocumentList documentList,
      {Function onChangedListener}) async {
    var collectionName = T.toString().toLowerCase() + 's';
    var documentSnapshots = await FirebaseFirestore.instance
        .collection(collectionName)
        .orderBy('name')
        .limit(25)
        .get();
    log(documentSnapshots.docs[0].data().toString());
    documentSnapshots.docs.forEach((element) {
      documentList.add(Document(initialValues: element.data()),
          saveOnAdd: false);
    });
    log(documentList[0].toString());
  }

  @override
  Future saveDocument(Document doc) async {
    var collectionName = T.toString().toLowerCase() + 's';
    var firbaseRef = FirebaseFirestore.instance
        .collection(collectionName)
        .doc(doc['id'].toString());

    await firbaseRef.set(doc.cast<String, dynamic>());
  }
}

class Pagination {
  int _total;
  DocumentSnapshot _pageIndex;
  int _pageSize;
  String _orderBy;

  String get orderBy => _orderBy;

  set orderBy(String orderBy) {
    _orderBy = orderBy;
  }

  DocumentSnapshot get pageIndex => _pageIndex;

  set pageIndex(DocumentSnapshot pageIndex) {
    _pageIndex = pageIndex;
  }

  int get pageSize => _pageSize;

  set pageSize(int pageSize) {
    _pageSize = pageSize;
  }

  int get total => _total;

  set total(int total) {
    _total = total;
  }
}
