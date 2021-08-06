import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBase {
  Stream<User?> get onAuthStateChanged;

  String get uid;

  String get email;



  Future<void> signInWithEmailAndPassword(String email, String password);

  Future<void> signUpWithEmailAndPassword(String email, String password);

  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  String get uid => _firebaseAuth.currentUser!.uid;

  @override
  String get email => _firebaseAuth.currentUser!.email ?? "";


  @override
  Stream<User?> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges();
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
