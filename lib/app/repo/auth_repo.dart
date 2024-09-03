import 'dart:developer';

import 'package:bento/app/model/user_model.dart';
import 'package:bento/app/utils/app_utils/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../services/auth_wrapper.dart';
import '../services/db.dart';
import '../widget/dialogs/loading_dialog.dart';

class AuthRepo {
  final DatabaseService _db = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _validatePasswords(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  Future<void> signUp({
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (!_validatePasswords(password, confirmPassword)) {
      throw Exception('Passwords do not match');
    }

    try {
      showLoadingDialog(message: 'Signing Up...');
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await createUserInFs(
          userName: userName,
          email: email,
          uid: _auth.currentUser!.uid,
          photoUrl: '');
      hideLoadingDialog();
      Get.offAll(AuthWrapper());
    } on FirebaseAuthException catch (e) {
      hideLoadingDialog();

      throw Exception(e.message);
    } catch (e) {
      hideLoadingDialog();

      log('This is exception in signup E');

      throw Exception('Error signing up: $e');
    }
  }

  Future<void> createUserInFs({
    required String userName,
    required String email,
    required String uid,
    required String photoUrl,
  }) async {
    try {
      UserModel userModel = UserModel(
        uid: uid,
        email: email,
        photoUrl: photoUrl,
      );

      await _db.usersCollection
          .doc(uid)
          .set(userModel.toMap(), SetOptions(merge: true));
      log('User data created');
      return;
    } catch (e) {
      log('Error creating user data: $e');
    }
  }

  Future<void> signIn(
      {required String email,
      required String password,
      required String userName}) async {
    try {
      showLoadingDialog(message: 'Signing In');
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await createUserInFs(
          userName: userName,
          email: email,
          uid: _auth.currentUser!.uid,
          photoUrl: '');
      hideLoadingDialog();
      Get.offAll(AuthWrapper());
    } on FirebaseAuthException catch (e) {
      hideLoadingDialog();
      log('sign In Error $e');
    } catch (e) {
      hideLoadingDialog();
      // Handle other errors
      throw Exception('Error signing in: $e');
    }
  }

  Future<void> signOut() async {
    showLoadingDialog(message: 'Signing Out');
    await _auth.signOut();
    AppUtils.removeAllControllers();
    // await GoogleSignIn().signOut();
    hideLoadingDialog();
  }
}
