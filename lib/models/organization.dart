import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:ngens/models/root.dart';

class Organization extends Root {
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
    return Organization(
        id: doc['id'] as String,
        orgId: doc['orgId'] as String,
        context: doc['context'] as String,
        lastUpdatedBy: doc['lastUpdatedBy'] as String,
        lastUpdatedTime: doc['lastUpdatedTime'] as DateTime,
        createdBy: doc['createdBy'] as String,
        createdTime: doc['createdTime'] as DateTime,
        email: doc['email'] as String,
        name: doc['name'] as String,
        logoUrl: doc['logoUrl'] as String,
        displayName: doc['displayName'] as String);
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
}
