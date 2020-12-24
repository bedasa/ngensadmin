import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import 'package:ngens/models/root.dart';

class User extends Root {
  final String username;
  final String email;
  final String photoUrl;
  final String displayName;
  final String bio;

  User({
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

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'] as String,
      orgId: doc['orgId'] as String,
      context: doc['context'] as String,
      lastUpdatedBy: doc['lastUpdatedBy'] as String,
      lastUpdatedTime: doc['lastUpdatedTime'] as DateTime,
      createdBy: doc['createdBy'] as String,
      createdTime: doc['createdTime'] as DateTime,
      email: doc['email'] as String,
      username: doc['username'] as String,
      photoUrl: doc['photoUrl'] as String,
      displayName: doc['displayName'] as String,
      bio: doc['bio'] as String,
    );
  }
}
