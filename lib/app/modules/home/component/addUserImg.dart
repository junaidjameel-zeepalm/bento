import 'package:bento/app/controller/user_controller.dart';
import 'package:bento/app/data/constant/data.dart';
import 'package:bento/app/services/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddImageWidget extends StatefulWidget {
  const AddImageWidget({
    super.key,
  });

  @override
  State<AddImageWidget> createState() => _AddImageWidgetState();
}

class _AddImageWidgetState extends State<AddImageWidget> {
  Uint8List? pickedProfileImageBytes;
  String? pickedProfileImage;

  UserController get uc => Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (controller) {
      // log("controller")/
      return LayoutBuilder(builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 1300;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.kWhite.withOpacity(.8),
              radius: isMobile ? 70 : 80,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: pickedProfileImageBytes != null
                          ? DecorationImage(
                              image: MemoryImage(pickedProfileImageBytes!),
                              fit: BoxFit.cover,
                            )
                          : uc.user!.photoUrl != ''
                              ? DecorationImage(
                                  image: NetworkImage(uc.user!.photoUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.kWhite,
                        child: InkWell(
                          onTap: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles();
                            if (result != null) {
                              Uint8List fileBytes = result.files.first.bytes!;
                              setState(() {
                                pickedProfileImageBytes = fileBytes;
                                pickedProfileImage = result.files.first.name;
                              });

                              if (pickedProfileImageBytes != null) {
                                pickedProfileImage =
                                    await FirebaseStorageServices
                                        .uploadToStorageFromBytes(
                                            fileBytes: pickedProfileImageBytes!,
                                            folderName: 'ProfileImages');
                                await Get.find<UserController>()
                                    .updateUserNameAndProfilePicture(
                                        image: pickedProfileImage);
                              }
                              setState(() {
                                pickedProfileImageBytes = null;
                              });
                            }
                          },
                          child: const Icon(
                            CupertinoIcons.add,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      });
    });
  }

  // Future<void> handleImageSelection() async {
  //   callFutureFunctionWithLoadingOverlay(asyncFunction: () async {
  //     final db = DatabaseService();
  //     var imgData = await ImagePickerServices.getImageAsFile();

  //     if (imgData == null) return;

  //     // showLoadingDialog(message: "Uploading Image");
  //     var tGroupImage = await FirebaseStorageServices.uploadToStorageAsHTMLFile(
  //       file: imgData,
  //       folderName: "UserProfileImage",
  //     );

  //     uc.user!.photoUrl = tGroupImage;
  // await db.userCollection.doc(uc.user!.uid).set(
  //       uc.user!,
  //       SetOptions(merge: true),
  //     );

  //     uc.update();
  //   });
  // }
}
