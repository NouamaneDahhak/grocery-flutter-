import 'package:delivery/helpers/validators.dart';
import 'package:delivery/services/auth.dart';
import 'package:delivery/services/database.dart';
import 'package:delivery/widgets/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInModel with ChangeNotifier {
  final AuthBase auth;
  final Database database;

  bool isLoading = false;
  bool validEmail = true;
  bool validPassword = true;

  bool isSignedIn = true;

  SignInModel({required this.auth, required this.database});

  void changeSignStatus() {
    isSignedIn = !isSignedIn;
    notifyListeners();
  }

  ///Sign in with email function
  Future<void> submit(
      BuildContext context, String email, String password) async {
    try {
      if (verifyInputs(email, password)) {
        isLoading = true;
        notifyListeners();

        if (isSignedIn) {
          await auth.signInWithEmailAndPassword(email, password);
        } else {
          await auth.signUpWithEmailAndPassword(email, password);
        }

        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();

      FirebaseAuthException exception = e as FirebaseAuthException;

      showDialog(
          context: context,
          builder: (context) =>
              Dialogs.error(context, message: exception.message));
    }
  }

  //Check inputs and display errors
  bool verifyInputs(
    String email,
    String password,
  ) {
    if (!Validators.email(email)) {
      validEmail = false;
    } else {
      validEmail = true;
    }

    if (!Validators.password(password)) {
      validPassword = false;
    } else {
      validPassword = true;
    }

    if (!validPassword || !validEmail) {
      notifyListeners();
    }

    return validEmail && validPassword;
  }
}
