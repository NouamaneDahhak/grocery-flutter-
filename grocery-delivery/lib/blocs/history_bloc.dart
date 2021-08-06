import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/models/data_models/history_item.dart';
import 'package:delivery/services/auth.dart';
import 'package:delivery/services/database.dart';
import 'package:rxdart/rxdart.dart';

class HistoryBloc {
  final Database database;
  final AuthBase auth;

  HistoryBloc({required this.database, required this.auth});

  // ignore: close_sinks
  StreamController<List<HistoryItem>> historyController = BehaviorSubject();

  Stream<List<HistoryItem>> get historyStream => historyController.stream;

  bool _canLoadMore = true;

  List<DocumentSnapshot> _lastDocuments = [];

  List<HistoryItem> savedHistory = [];

  Future<void> loadHistory(int length) async {
    if (_canLoadMore) {
      _canLoadMore = false;

      List<HistoryItem> newOrders = (await _getHistory(length))
          .map((e) => HistoryItem.fromMap(e.data() as Map<String, dynamic>))
          .toList();

      savedHistory.addAll(newOrders);

      historyController.add(savedHistory.toSet().toList());

      if (newOrders.length < length) {
        _canLoadMore = false;
      } else {
        _canLoadMore = true;
      }
    }
  }

  Future<List<DocumentSnapshot>> _getHistory(int length) async {
    final collection = await (database.getFutureCollectionWithRange(
      "delivery_boys/${auth.email}/history",
      startAfter: _lastDocuments.isEmpty ? null : _lastDocuments.last,
      length: length,
      orderBy: 'date',
    ));

    if (collection.docs.isNotEmpty) {
      _lastDocuments.add(collection.docs.last);
    }

    return collection.docs;
  }
}
