import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Database {
  Stream<QuerySnapshot> getDataFromCollection(String path, [int length]);

  Future<QuerySnapshot> getFutureCollection(String col);


  Future<QuerySnapshot> getFutureCollectionWithRange(String path,
      {required String orderBy,
        required DocumentSnapshot? startAfter,
        required int length});

  Future<QuerySnapshot> getFutureCollectionGroupWithRange(String path,
      {required String orderBy,
        required String email,
        required DocumentSnapshot? startAfter,
        required int length});



  Future<DocumentSnapshot> getFutureDataFromDocument(String path);

  Stream<QuerySnapshot> getFromCollectionGroup(String collectionName,
      int length,String email, String orderBy,) ;

  Stream<QuerySnapshot> getSearchedDataFromCollection(
      String collection, String searchedData);

  Stream<DocumentSnapshot> getDataFromDocument(String path);

  Future<void> setData(Map<String, dynamic> data, String path);

  Future<void> removeData(String path);

  Future<void> removeCollection(String path);

  Future<void> updateData(Map<String, dynamic> data, String path);
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  final _service = FirebaseFirestore.instance;



  Future<QuerySnapshot> getFutureCollectionWithRange(String path,
      {required String orderBy,
        required DocumentSnapshot? startAfter,
        required int length}) async {
    if (startAfter != null) {
      return await _service
          .collection(path)
          .orderBy(orderBy)
          .startAfterDocument(startAfter)
          .limit(length)
          .get();
    } else {
      return await _service
          .collection(path)
          .orderBy(orderBy)
          .limit(length)
          .get();
    }
  }

   Future<QuerySnapshot> getFutureCollectionGroupWithRange(String path,
      {required String orderBy,
        required String email,
        required DocumentSnapshot? startAfter,
        required int length}) async {
    if (startAfter != null) {
      return await _service
          .collectionGroup(path)
          .where('status', isEqualTo: 'Processing')
          .where('delivery_boy.email',isEqualTo: email)
          .orderBy('shipping_method.price',descending: true)
          .orderBy(orderBy)
          .startAfterDocument(startAfter)
          .limit(length)
          .get();
    } else {
      return await _service
          .collectionGroup(path)
          .where('status', isEqualTo: 'Processing')
          .where('delivery_boy.email',isEqualTo: email)
          .orderBy('shipping_method.price',descending: true)
          .orderBy(orderBy)
          .limit(length)
          .get();
    }
  }

  Future<DocumentSnapshot> getFutureDataFromDocument(String path) {
    return _service.doc(path).get();
  }

  Future<QuerySnapshot> getFutureCollection(String col) {
    return _service.collection(col).get();
  }

  Stream<QuerySnapshot> getFromCollectionGroup(String collectionName,
      int length,String email, String orderBy,) {

      return _service
          .collectionGroup(collectionName)
          .where('status', isEqualTo: 'Processing')
          .where('delivery_boy.email',isEqualTo: email)
          .orderBy('shipping_method.price',descending: true)
          .orderBy(orderBy)
          .limit(length)
          .snapshots();



  }

  Stream<QuerySnapshot> getSearchedDataFromCollection(
      String collection, String searchedData) {
    final snapshots = _service
        .collection(collection)
        .where('keywords', arrayContains: searchedData)
        .snapshots();

    return snapshots;
  }

  Stream<QuerySnapshot> getDataFromCollection(String path, [int? length]) {
    Stream<QuerySnapshot> snapshots;
    if (length == null) {
      snapshots = _service.collection(path).snapshots();
    } else {
      snapshots = _service.collection(path).limit(length).snapshots();
    }
    return snapshots;
  }

  Stream<DocumentSnapshot> getDataFromDocument(String path) {
    final snapshots = _service.doc(path).snapshots();

    return snapshots;
  }

  Future<void> setData(Map<String, dynamic> data, String path) async {
    final snapshots = _service.doc(path);
    await snapshots.set(data);
  }

  Future<void> updateData(Map<String, dynamic> data, String path) async {
    final snapshots = _service.doc(path);
    await snapshots.update(data);
  }

  Future<void> removeData(String path) async {
    final snapshots = _service.doc(path);
    await snapshots.delete();
  }

  Future<void> removeCollection(String path) async {
    await _service.collection(path).get().then((snapshot) async {
      await Future.forEach(snapshot.docs, (DocumentSnapshot doc) async {
        await doc.reference.delete();
      });
    });
  }
}
