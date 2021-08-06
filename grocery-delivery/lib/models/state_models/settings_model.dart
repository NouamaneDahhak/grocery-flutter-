import 'package:delivery/services/auth.dart';
import 'package:delivery/services/database.dart';
import 'package:flutter/cupertino.dart';

class SettingsModel with ChangeNotifier {
  final AuthBase auth;
  final Database database;

  SettingsModel({required this.auth, required this.database});

  String get uid => auth.uid;

  ///Sign out function
  Future<void> signOut() async {
    await database.setData({}, 'users/${auth.uid}');

    await auth.signOut();
  }
}
