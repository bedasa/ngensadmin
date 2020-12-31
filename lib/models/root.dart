import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ngens/models/organization.dart';
import 'package:ngens/models/user.dart';
import 'package:ngens/models/institute.dart';

abstract class Root<T> {
  final String id;
  final String orgId;
  final String context;
  final String lastUpdatedBy;
  final DateTime lastUpdatedTime;
  final String createdBy;
  final DateTime createdTime;

  String tableName;
  bool exists = false;

  static const String organizaiton = 'Organization';
  static const String user = 'User';
  static const String institute = 'Institute';

  Root(
      {this.id,
      this.orgId,
      this.context,
      this.lastUpdatedBy,
      this.lastUpdatedTime,
      this.createdBy,
      this.createdTime});

  Map<String, dynamic> getData();

  T parse(DocumentSnapshot documentSnapshot);

  Future<T> getById() async {
    var documentSnapshot = await FirebaseFirestore.instance
        .collection(runtimeType.toString().toLowerCase() + 's')
        .doc(id)
        .get();
    if (!documentSnapshot.exists) {
      return this as T;
    } else {
      return parse(documentSnapshot);
    }
  }

  Future<T> upsert() async {
    var firbaseRef = FirebaseFirestore.instance
        .collection(runtimeType.toString().toLowerCase() + 's')
        .doc(id);
    var data = getData();
    await firbaseRef.set(data);
    var documentSnapshot = await firbaseRef.get();
    if (!documentSnapshot.exists) {
      return this as T;
    } else {
      return parse(documentSnapshot);
    }
  }

  Future<bool> delete(Root root) async {
    var firbaseRef = FirebaseFirestore.instance
        .collection(T.toString().toLowerCase() + 's')
        .doc(root.id);

    await firbaseRef.delete();
    return true;
  }

  static List<String> getMastersTitles() {
    return <String>['Organization', 'User', 'Institute'];
  }

  static Map<String, String> getLabels(String title) {
    Map<String, String> obj;
    switch (title) {
      case Root.organizaiton:
        obj = Organization.getLabels();
        break;
      case Root.user:
        obj = User.getLables();
        break;
      case Root.institute:
        obj = Institute.getLabels();
        break;
      default:
        obj = Organization.getLabels();
    }
    return obj;
  }
}
