import 'package:delivery/services/auth.dart';
import 'package:delivery/services/database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomeModel {
  final PageController pageController = PageController(keepPage: false);

  final Database database;
  final AuthBase auth;

  HomeModel({required this.database, required this.auth});

  int _index = 0;

  void goToPage(int index) {
    if (index != _index) {
      pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );

      _index = index;
    }
  }

  bool onPop() {
    if (_index == 0) {
      return true;
    } else {
      goToPage(0);
      return false;
    }
  }

  ///Add notifications token
  Future<void> checkNotificationToken() async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    String? token = await _firebaseMessaging.getToken();

    if (token != null) {
      database.updateData({
        "token": token,
      }, 'delivery_boys/${auth.email}');
    }
  }
}
