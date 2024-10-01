import 'dart:async';

import 'package:bento/app/controller/auth_controller.dart';
import 'package:bento/app/repo/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/user_model.dart';
import '../services/db.dart';
import '../utils/app_utils/app_utils.dart';

class UserController extends GetxController {
  final authController = Get.find<AuthController>();
  final db = DatabaseService();
  final _currentUser = Rxn<UserModel>();
  UserModel? get user => _currentUser.value;

  String get currentUid => FirebaseAuth.instance.currentUser!.uid;

  final RxBool _isAccountStatusCompleted = false.obs;

  RxBool get isAccountStatusCompletedObs => _isAccountStatusCompleted;

  bool get isAccountStatusCompleted => _isAccountStatusCompleted.value;

  DocumentReference get currentUserReference =>
      db.userCollection.doc(currentUid);

  Stream<UserModel?> get _currentUserStream {
    if (authController.user == null) {
      return const Stream<UserModel?>.empty();
    } else {
      return db.userCollection.doc(currentUid).snapshots().map((event) {
        return event.data();
      });
    }
  }

  var text = ''.obs;

  // Method to update the text value
  void updateText(String newText) {
    text.value = newText;
  }

  @override
  void onInit() {
    _currentUser.bindStream(_currentUserStream);
    ever(_currentUser, (user) {
      if (user != null) {
        AppUtils.putAllControllers();
        bioController.text = user.bio ?? '';

        bioController.addListener(() => onBioTextChanged());
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    _currentUser.close();
    bioController.dispose();
    AppUtils.removeAllControllers();
    super.onClose();
  }

  Timer? _debounce;
  final bioController = TextEditingController();

  void onBioTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 5000), () {
      // Use Get.focusScope to unfocus the text field
      Get.focusScope?.unfocus();

      // Check if the bio has changed
      if (bioController.text != user?.bio) {
        AuthRepo().updateBioInFs(bioController.text);
      }
    });
  }

  Future<void> updateUserNameAndProfilePicture({required String? image}) async {
    callFutureFunctionWithLoadingOverlay(asyncFunction: () async {
      final uid = user!.uid ?? FirebaseAuth.instance.currentUser!.uid;

      user!.photoUrl = image;

      await db.userCollection.doc(uid).set(user!, SetOptions(merge: true));
    });
  }
}
