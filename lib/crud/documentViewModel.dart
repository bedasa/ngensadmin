import 'package:ngens/models/root.dart';
import 'package:rapido/rapido.dart';

class DocumentViewModel<T extends Root<T>> {
  DocumentViewModel();
  Future<Document> get getDocument async {}
}
