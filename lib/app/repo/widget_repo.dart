import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:html' as html;

import 'package:bento/app/model/gridItem_model.dart';
import 'package:bento/app/utils/app_utils/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class WidgetRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<GridItem>> fetchUserWidgets(String uid) async {
    QuerySnapshot widgetSnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('widgets')
        .orderBy('position')
        .get();

    return widgetSnapshot.docs.map((doc) {
      return GridItem.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<void> updateWidgetText(
      String uid, String itemId, String newText) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('widgets')
        .doc(itemId)
        .update({'text': newText});
  }

  Future<void> uploadImage(
      String uid, String itemId, String imagePathOrBytes) async {
    try {
      String downloadUrl;
      final storageRef = FirebaseStorage.instance.ref().child(
          'user_images/$uid/$itemId/${DateTime.now().millisecondsSinceEpoch}.jpg');

      if (kIsWeb) {
        // Web-specific logic: Upload from bytes (Uint8List)
        final Uint8List fileBytes = imagePathOrBytes as Uint8List;
        UploadTask uploadTask = storageRef.putData(fileBytes);
        TaskSnapshot snapshot = await uploadTask;
        downloadUrl = await snapshot.ref.getDownloadURL();
      } else {
        // Mobile-specific logic: Upload using file path
        UploadTask uploadTask = storageRef.putFile(File(imagePathOrBytes));
        TaskSnapshot snapshot = await uploadTask;
        downloadUrl = await snapshot.ref.getDownloadURL();
      }

      // Prepare the audit metadata
      Map<String, dynamic> auditData = {
        'imagePath': downloadUrl,
        'uploadedBy': uid,
        'uploadedAt': FieldValue.serverTimestamp(),
      };

      // Update Firestore with the image URL and audit metadata
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('widgets')
          .doc(itemId)
          .update(auditData);

      log('Image uploaded and Firestore updated with audit data successfully');
    } catch (e) {
      log('Error uploading image: $e');
    }
  }

  Future<Uint8List?> fetchBytesFromUrl(String blobUrl) async {
    try {
      // Use the `html.FileReader` API to fetch the Blob URL content
      final html.HttpRequest request = await html.HttpRequest.request(
        blobUrl,
        responseType: 'blob', // Specify that we're dealing with a Blob
      );

      final html.Blob blob = request.response as html.Blob;

      // Create a FileReader to convert the Blob to Uint8List
      final html.FileReader reader = html.FileReader();
      final completer = Completer<Uint8List>();

      reader.onLoadEnd.listen((_) {
        completer.complete(reader.result as Uint8List);
      });

      reader.onError.listen((error) {
        completer.completeError(error);
      });

      reader.readAsArrayBuffer(blob);

      return completer.future;
    } catch (e) {
      log('Error fetching bytes from Blob URL: $e');
      return null;
    }
  }

  Future<String?> uploadToStorageFromBytes({
    required Uint8List fileBytes,
    required String folderName,
    bool showLoader = true,
  }) async {
    return await callFutureFunctionWithLoadingOverlay<String>(
      showOverLay: showLoader,
      asyncFunction: () async {
        final Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('$folderName/file${DateTime.now().millisecondsSinceEpoch}');

        final UploadTask uploadTask = firebaseStorageRef.putData(fileBytes);
        final TaskSnapshot downloadUrl = await uploadTask;
        String url = await downloadUrl.ref.getDownloadURL();
        return url;
      },
    );
  }

  Future<void> updateSectionText(
      String uid, String itemId, String newText) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('widgets')
        .doc(itemId)
        .update({'sectionTile': newText});
  }

  Future<void> reorderWidgets(String uid, List<GridItem> items) async {
    WriteBatch batch = _firestore.batch();
    for (int i = 0; i < items.length; i++) {
      GridItem updatedItem = items[i].copyWith(position: i);
      DocumentReference itemRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('widgets')
          .doc(updatedItem.id);

      batch.update(itemRef, updatedItem.toMap());
    }
    await batch.commit();
  }

  Future<void> addWidget(String uid, GridItem item) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('widgets')
        .doc(item.id)
        .set(item.toMap());
  }

  Future<void> deleteWidget(String uid, String itemId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('widgets')
        .doc(itemId)
        .delete();
  }

  Future<void> updateWidgetShape(
      String uid, String itemId, String shapeName) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('widgets')
        .doc(itemId)
        .update({'shape': shapeName});
  }

  Future<void> changeUserName(String newName) async {
    // Update the user's name in Firestore

    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'name': newName,
    });

    Get.back();
  }
}
