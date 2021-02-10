import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import 'package:ngens/models/root.dart';

class RUser extends Root<RUser> {
  final String username;
  final String email;
  final String photoUrl;
  final String displayName;
  final String bio;

  RUser({
    @required String id,
    @required String orgId,
    @required String context,
    @required String lastUpdatedBy,
    @required DateTime lastUpdatedTime,
    @required String createdBy,
    @required DateTime createdTime,
    this.username,
    this.email,
    this.photoUrl,
    this.displayName,
    this.bio,
  }) : super(
            id: id,
            orgId: orgId,
            context: context,
            lastUpdatedBy: lastUpdatedBy,
            lastUpdatedTime: lastUpdatedTime,
            createdBy: createdBy,
            createdTime: createdTime);

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
      'username': username,
      'photoUrl': photoUrl,
      'email': email,
      'displayName': displayName,
      'bio': bio,
      'timestamp': DateTime.now()
    };
    return data;
  }

  factory RUser.fromDocument(DocumentSnapshot doc) {
    var user = RUser(
        id: doc['id'] as String,
        orgId: doc['orgId'] as String,
        context: doc['context'] as String,
        lastUpdatedBy: doc['lastUpdatedBy'] as String,
        lastUpdatedTime: (doc['lastUpdatedTime'] as Timestamp).toDate(),
        createdBy: doc['createdBy'] as String,
        createdTime: (doc['createdTime'] as Timestamp).toDate(),
        email: doc['email'] as String,
        username: doc['username'] as String,
        photoUrl: doc['photoUrl'] as String,
        displayName: doc['displayName'] as String,
        bio: doc['bio'] as String);
    user.exists = true;
    return user;
  }

  @override
  RUser parse(DocumentSnapshot documentSnapshot) {
    return RUser.fromDocument(documentSnapshot);
  }

  Map<String, String> getLabels() {
    return {
      'id': 'id',
      'orgId': 'orgId',
      'context': 'context',
      'lastUpdatedBy': 'lastUpdatedBy',
      'lastUpdatedTime': 'lastUpdatedTime',
      'createdBy': 'createdBy',
      'createdTime': 'createdTime',
      'username': 'username',
      'photoUrl': 'photoUrl',
      'email': 'email',
      'displayName': 'displayName',
      'bio': 'bio'
    };
  }

  static Map<String, String> getLables() {}
}
