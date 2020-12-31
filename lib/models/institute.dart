import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ngens/models/root.dart';

class Institute extends Root<Institute> {
  final String name;
  final String email;
  final String logoUrl;
  final String displayName;

  Institute({
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

  factory Institute.fromDocument(DocumentSnapshot doc) {
    return Institute(
        id: doc['id'] as String,
        orgId: doc['orgId'] as String,
        context: doc['context'] as String,
        lastUpdatedBy: doc['lastUpdatedBy'] as String,
        lastUpdatedTime: doc['lastUpdatedTime'] as DateTime,
        createdBy: doc['createdBy'] as String,
        createdTime: doc['createdTime'] as DateTime,
        email: doc['email'] as String,
        name: doc['name'] as String,
        logoUrl: doc['photoUrl'] as String,
        displayName: doc['displayName'] as String);
  }

  @override
  Map<String, dynamic> getData() {
    // TODO: implement getData
    throw UnimplementedError();
  }

  @override
  parse(DocumentSnapshot documentSnapshot) {
    // TODO: implement parse
    throw UnimplementedError();
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
      'logoUrl': 'photoUrl',
      'displayName': 'displayName'
    };
  }

  static Map<String, String> getLables() {}
}
