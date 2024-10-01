import 'dart:developer';

import 'package:bento/app/controller/user_controller.dart';
import 'package:bento/app/model/user_model.dart';
import 'package:bento/app/utils/app_utils/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/auth_wrapper.dart';
import '../services/db.dart';
import '../widget/dialogs/loading_dialog.dart';

class AuthRepo {
  final DatabaseService _db = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUp({
    required String userName,
    required String email,
    required String password,
  }) async {
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
      Get.back();
      Get.put(UserController(), permanent: true);
      // Get.offAll(AuthWrapper());
    } on FirebaseAuthException catch (e) {
      hideLoadingDialog();
      // Get.snackbar('Error', e.message ?? 'Error signing up');
      throw Exception(e.message);
    } catch (e) {
      hideLoadingDialog();
      log('This is exception in signup: $e');
      throw Exception('Error signing up: $e');
    }
  }

  Future<void> createUserInFs({
    required String userName,
    required String email,
    required String uid,
    String? photoUrl,
  }) async {
    try {
      UserModel userModel = UserModel(
        uid: uid,
        name: userName,
        bio: '',
        email: email,
        photoUrl: photoUrl,
      );
      await _db.usersCollection
          .doc(uid)
          .set(userModel.toMap(), SetOptions(merge: true));
      log('User data created');
    } catch (e) {
      log('Error creating user data: $e');
      Get.snackbar('Error', 'Failed to create user data');
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
    required String userName,
  }) async {
    try {
      await callFutureFunctionWithLoadingOverlay(
        asyncFunction: () async {
          await _auth.signInWithEmailAndPassword(
              email: email, password: password);
          Get.put(UserController(), permanent: true);
        },
      );
    } on FirebaseAuthException catch (e) {
      hideLoadingDialog();
      log('Sign-in error: $e');
      Get.snackbar('Error', e.message ?? 'Error signing in');
    } catch (e) {
      hideLoadingDialog();
      log('Error signing in: $e');
      Get.snackbar('Error', 'An unexpected error occurred');
    }
  }

  // Future<void> signInWithGoogle() async {
  //   try {
  //     // Create a new instance of GoogleAuthProvider
  //     final GoogleAuthProvider provider = GoogleAuthProvider();

  //     // Use signInWithPopup for web sign-in
  //     UserCredential result = await _auth.signInWithPopup(provider);
  //     final user = result.user;

  //     if (user != null) {
  //       String userName = user.displayName ?? 'No name';
  //       String email = user.email ?? '';
  //       String uid = user.uid;
  //       String photoUrl = user.photoURL ?? '';

  //       // Check if the user already exists in Firestore
  //       final userDoc = await _db.usersCollection.doc(uid).get();

  //       if (userDoc.exists) {
  //         log('User already exists in Firestore');
  //       } else {
  // await createUserInFs(
  //   userName: userName,
  //   email: email,
  //   uid: uid,
  //   photoUrl: photoUrl,
  // );
  //       }

  //       Get.offAll(AuthWrapper());
  //     } else {
  //       log('Google sign-in aborted by user.');
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     //log('Error signing in with Google: $e');
  //     Get.snackbar('Error', e.message ?? 'Error signing in with Google');
  //   } catch (err) {
  //     log('Error signing in with Google: $err');
  //     Get.snackbar('Error', 'An unexpected error occurred');
  //   }
  // }
  Future<void> signInWithGoogle({bool isFromSignIn = true}) async {
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      try {
        UserCredential result = await _auth.signInWithPopup(googleProvider);
        User? user = result.user;
        if (user != null) {
          String userName = user.displayName ?? 'No name';
          String email = user.email ?? '';
          String uid = user.uid;
          String photoUrl = user.photoURL ?? '';
          if (result.additionalUserInfo!.isNewUser) {
            await createUserInFs(
              userName: userName,
              email: email,
              uid: uid,
              photoUrl: photoUrl,
            );
          }
          if (!isFromSignIn) {
            Get.back();
          }
          Get.put(UserController(), permanent: true);
        } else {
          Fluttertoast.showToast(msg: "Something went wrong, please try again");
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    } else {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        try {
          UserCredential result = await _auth.signInWithCredential(credential);
          User? user = result.user;

          if (user != null) {
            String userName = user.displayName ?? 'No name';
            String email = user.email ?? '';
            String uid = user.uid;
            String photoUrl = user.photoURL ?? '';
            if (result.additionalUserInfo!.isNewUser) {
              await createUserInFs(
                userName: userName,
                email: email,
                uid: uid,
                photoUrl: photoUrl,
              );
            }
          }
          if (!isFromSignIn) {
            Get.back();
          }
          Get.put(UserController(), permanent: true);
        } catch (e) {
          Fluttertoast.showToast(msg: e.toString());
        }
      }
    }
  }

  Future<void> signOut() async {
    callFutureFunctionWithLoadingOverlay(
      asyncFunction: () async {
        await _auth.signOut();
        GoogleSignIn().signOut();
        await Get.delete<UserController>(force: true);
      },
    );
  }

  Future<void> updateBioInFs(String bio) async {
    try {
      await _db.usersCollection
          .doc(_auth.currentUser!.uid)
          .update({'bio': bio});
    } catch (e) {
      log('Error updating bio: $e');
      Get.snackbar('Error', 'Failed to update bio');
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required BuildContext context,
  }) async {
    if (oldPassword.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields')),
      );
      return;
    }

    try {
      // Reauthenticate user with old password
      User? user = _auth.currentUser;
      String email = user?.email ?? '';

      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: oldPassword,
      );

      await user?.reauthenticateWithCredential(credential);

      // Change to the new password
      await user?.updatePassword(newPassword);

      // Show success snack bar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );
      Navigator.of(context).pop(); // Close dialog after success
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    }
  }

  Future<void> changeEmail(
      String newEmail, String currentPassword, BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      String currentEmail = user?.email ?? '';

      // Check if the new email is the same as the current email
      if (currentEmail == newEmail) {
        Get.snackbar('Error', 'New email is the same as the current email');
        return;
      }

      // Check if the new email already exists in the database
      var emailCheck =
          await _db.usersCollection.where('email', isEqualTo: newEmail).get();

      if (emailCheck.docs.isNotEmpty) {
        Get.snackbar('Error', 'This email is already registered');
        return;
      }

      // Re-authenticate the user
      AuthCredential credential = EmailAuthProvider.credential(
          email: currentEmail, password: currentPassword);

      await user?.reauthenticateWithCredential(credential);

      // Send verification email for the new email address
      await user?.verifyBeforeUpdateEmail(newEmail).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Verification email sent to new email. Please verify before proceeding.'),
          ),
        );
      });

      // Wait for the user to verify the new email
      await user?.reload(); // Reload user data
      user = _auth.currentUser; // Get the updated user information

      // Check if the email is verified and matches the new email
      if (user != null && user.email == newEmail && user.emailVerified) {
        // Update the email in Firestore if it's verified
        await _db.usersCollection.doc(_auth.currentUser!.uid).update({
          'email': newEmail, // Update Firestore with the new verified email
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Email changed successfully after verification')),
        );
        Navigator.of(context).pop(); // Optionally close the dialog
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Please verify the new email to complete the process.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuth exceptions
      if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect password')),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email is already in use')),
        );
      } else if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please re-authenticate and try again')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Failed to change email')),
        );
      }
    } catch (e) {
      // Catch any other unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    }
  }
}
