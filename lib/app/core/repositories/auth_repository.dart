import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc_firebase_crud/app/core/models/user_model.dart';
import 'package:flutter_bloc_firebase_crud/app/services/shared_pref.dart';

class AuthRepository {
  FirebaseAuth auth = FirebaseAuth.instance;
  final SharedPreferencesManager _sharedPreferencesManager =
      SharedPreferencesManager();

  Stream<UserModel> retrieveCurrentUser() {
    return auth.authStateChanges().map((User? user) {
      if (user != null) {
        return UserModel(uid: user.uid, email: user.email);
      } else {
        return UserModel(uid: "uid");
      }
    });
  }

  Future<UserCredential?> signUp(UserModel user) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.email!, password: user.password!);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.code);
    }
  }

  Future<UserCredential?> signIn(UserModel user) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: user.email!, password: user.password!);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.code);
    }
  }

  Future<void> signOut() async {
    await _sharedPreferencesManager.clearKey('user_id');
    return await FirebaseAuth.instance.signOut();
  }

  Future<void> saveUID(String uid) async {
    _sharedPreferencesManager.putString('user_id', uid);
  }

  Future<String?> getUserId() async {
    return await _sharedPreferencesManager.getString('user_id');
  }
}
