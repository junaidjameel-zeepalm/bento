import 'package:bento/app/controller/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    _currentUser.close();
    super.onClose();
  }
}
