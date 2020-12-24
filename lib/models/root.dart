import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Root {
  final String id;
  final String orgId;
  final String context;
  final String lastUpdatedBy;
  final DateTime lastUpdatedTime;
  final String createdBy;
  final DateTime createdTime;

  Root({
    this.id,
    this.orgId,
    this.context,
    this.lastUpdatedBy,
    this.lastUpdatedTime,
    this.createdBy,
    this.createdTime,
  });

  Map<String, dynamic> getData();

  Future<T> getById<T>(String id) async {
    return await FirebaseFirestore.instance
        .collection(T.toString().toLowerCase() + 's')
        .doc(id)
        .get() as T;
  }

  Future<T> upsert<T>(Root root) async {
    var firbaseRef = FirebaseFirestore.instance
        .collection(T.toString().toLowerCase() + 's')
        .doc(root.id);
    var data = root.getData();
    await firbaseRef.set(data);
    return await firbaseRef.get() as T;
  }

  Future<bool> delete<T>(Root root) async {
    var firbaseRef = FirebaseFirestore.instance
        .collection(T.toString().toLowerCase() + 's')
        .doc(root.id);

    await firbaseRef.delete();
    return true;
  }
}

