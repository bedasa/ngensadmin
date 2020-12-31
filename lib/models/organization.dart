import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:ngens/models/root.dart';

class Organization extends Root<Organization> {
  final String name;
  final String email;
  final String logoUrl;
  final String displayName;

  Organization({
    @required String id,
    @required String orgId,
    @required String context,
    @required String lastUpdatedBy,
    @required DateTime lastUpdatedTime,
    @required String createdBy,
    @required DateTime createdTime,
    this.name,
    this.email,
    this.logoUrl,
    this.displayName,
  }) : super(
            id: id,
            orgId: orgId,
            context: context,
            lastUpdatedBy: lastUpdatedBy,
            lastUpdatedTime: lastUpdatedTime,
            createdBy: createdBy,
            createdTime: createdTime);

  factory Organization.fromDocument(DocumentSnapshot doc) {
    var org = Organization(
        id: doc['id'] as String,
        orgId: doc['orgId'] as String,
        context: doc['context'] as String,
        lastUpdatedBy: doc['lastUpdatedBy'] as String,
        lastUpdatedTime: (doc['lastUpdatedTime'] as Timestamp).toDate(),
        createdBy: doc['createdBy'] as String,
        createdTime: (doc['createdTime'] as Timestamp).toDate(),
        email: doc['email'] as String,
        name: doc['name'] as String,
        logoUrl: doc['logoUrl'] as String,
        displayName: doc['displayName'] as String);
    org.exists = true;
    return org;
  }

  @override
  Map<String, dynamic> getData() {
    var data = {
      'id': id,
      'orgId': orgId,
      'context': context,
      'lastUpdatedBy': lastUpdatedBy,
      'lastUpdatedTime': lastUpdatedTime,
      'createdBy': createdBy,
      'createdTime': createdTime,
      'email': email,
      'name': name,
      'logoUrl': logoUrl,
      'displayName': displayName
    };
    return data;
  }

  @override
  Organization parse(DocumentSnapshot documentSnapshot) {
    return Organization.fromDocument(documentSnapshot);
  }

  static Map<String, String> getLabels() {
    return {
      'id': 'id',
      'orgId': 'orgId',
      'context': 'context',
      'lastUpdatedBy': 'lastUpdatedBy',
      'lastUpdatedTime': 'lastUpdatedTime',
      'createdBy': 'createdBy',
      'createdTime': 'createdTime',
      'email': 'email',
      'name': 'name',
      'logoUrl': 'logoUrl',
      'displayName': 'displayName'
    };
  }
}
