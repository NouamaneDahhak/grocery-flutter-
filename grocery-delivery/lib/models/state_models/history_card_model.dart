import 'package:flutter/material.dart';

class HistoryCardModel with ChangeNotifier {
  bool isExpended = false;

  ///Expand <--> Collapse widget
  void updateWidget() {
    isExpended = !isExpended;
    notifyListeners();
  }
}
