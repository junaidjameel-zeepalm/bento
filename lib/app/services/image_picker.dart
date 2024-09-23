import 'dart:developer';
import 'dart:io';
import 'package:bento/app/utils/app_utils/app_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:universal_html/html.dart' as html;

class ImagePickerMobileService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      log('Error picking image: $e');
    }
    return null;
  }
}

class ImagePickerServices {
  static final picker = ImagePicker();
  // static Future<File?> getImageFromGallery() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     return File(pickedFile.path);
  //   } else {
  //     return null;
  //   }
  // }
  // static Future<Uint8List?> getImageAsMemory() async {
  //   Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
  //   return bytesFromPicker != null ? bytesFromPicker : null;
  // }
  static Future<html.File?> getImageAsFile() async {
    html.File? bytesFromPicker = await ImagePickerWeb.getImageAsFile();
    if (bytesFromPicker != null) {
      return bytesFromPicker;
    } else {
      return null;
    }
  }

  static Future<Uint8List?> getImageWeb() async {
    var file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      return await file.readAsBytes();
    } else {
      return null;
    }
  }
}

class FirebaseStorageServices {
  static Future<String> uploadToStorage(
      {required File file,
      required String folderName,
      String? imageName}) async {
    try {
      final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
            imageName == null
                ? '$folderName/file${DateTime.now().millisecondsSinceEpoch}'
                : '$folderName/$imageName',
          );
      final UploadTask uploadTask = firebaseStorageRef.putFile(file);
      final TaskSnapshot downloadUrl = await uploadTask;
      String url = await downloadUrl.ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      return "";
    }
  }

  static Future<String?> uploadToStorageFromBytes({
    required Uint8List fileBytes,
    required String folderName,
    bool showLoader = true,
  }) async {
    return await callFutureFunctionWithLoadingOverlay<String>(
        showOverLay: showLoader,
        asyncFunction: () async {
          final Reference firebaseStorageRef = FirebaseStorage.instance
              .ref()
              .child(
                  '$folderName/file${DateTime.now().millisecondsSinceEpoch}');
          final UploadTask uploadTask = firebaseStorageRef.putData(fileBytes);
          final TaskSnapshot downloadUrl = await uploadTask;
          String url = await downloadUrl.ref.getDownloadURL();
          return url;
        });
  }

  static Future<String> uploadToStorageAsHTMLFile(
      {required html.File file,
      required String folderName,
      String? imageName}) async {
    try {
      final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
            imageName == null
                ? '$folderName/file${DateTime.now().millisecondsSinceEpoch}'
                : '$folderName/$imageName',
          );
      final UploadTask uploadTask = firebaseStorageRef.putBlob(file);
      final TaskSnapshot downloadUrl = await uploadTask;
      String url = await downloadUrl.ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      return "";
    }
  }

  static Future<String> uploadToStorageAsData({
    required Uint8List file,
    required String folderName,
    String? imageName,
  }) async {
    try {
      final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
            imageName == null
                ? '$folderName/file${DateTime.now().millisecondsSinceEpoch}.jpg'
                : '$folderName/$imageName',
          );
      final UploadTask uploadTask =
          firebaseStorageRef.putData(file); //try this please
      final TaskSnapshot downloadUrl = await uploadTask;
      String url = await downloadUrl.ref.getDownloadURL();
      return url;
    } on Exception catch (e) {
      return "";
    }
  }

  static Future<String> uploadToStorageAsBlob(
      {required File file, required String folderName}) async {
    try {
      final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
            '$folderName/file${DateTime.now().millisecondsSinceEpoch}',
          );
      html.Blob blob = html.Blob(await file.readAsBytes());
      final UploadTask uploadTask =
          firebaseStorageRef.putBlob(blob); //try this please
      // there is a separte package for storage for web .,. woh to nhi use krna?
      final TaskSnapshot downloadUrl = await uploadTask;
      String url = await downloadUrl.ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      return "";
    }
  }
}
