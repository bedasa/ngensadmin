import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import 'package:ngens/models/root.dart';

abstract class Repository<T extends Root<T>> {
  Future<List<T>> getAll();

  Future<T> getByID(String id);
  Future<T> upsert<T>(T customer);
  Future<bool> delete<T>(int customerId);
}
