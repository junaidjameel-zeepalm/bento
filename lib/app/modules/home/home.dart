import 'dart:io';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:bento/app/controller/home_controller.dart';
import 'package:bento/app/data/constant/data.dart';
import 'package:bento/app/data/constant/style.dart';
import 'package:bento/app/modules/home/component/grid_section_widget.dart';
import 'package:bento/app/modules/home/component/widget_creation_tile.dart';
import 'package:bento/app/services/image_picker.dart';
import 'package:bento/app/widget/hover_delete_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/hover_controller.dart';

class BentoHomePage extends StatefulWidget {
  const BentoHomePage({super.key});

  @override
  BentoHomePageState createState() => BentoHomePageState();
}

class BentoHomePageState extends State<BentoHomePage> {
  final HoverController hoverController = Get.put(HoverController());
  File? _selectedImage;
  HomeController get hc => Get.find<HomeController>();
  Future<void> _pickImage() async {
    ImagePickerService imagePicker = ImagePickerService();
    final File? image = await imagePicker.pickImageFromGallery();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Check if the keyboard is visible

    return GestureDetector(
      onTap: () => hc.selectedItemId.value = '',
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: const WidgetCreationTile(),
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 1300;
            return isMobile
                ? _buildMobileLayout(isMobile)
                : _buildDesktopLayout(isMobile);
          },
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(bool isMobile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: Get.width * 0.3,
          child: _buildProfileSection(isMobile),
        ),
        SizedBox(
            width: Get.width * 0.7,
            child: GridSectionWidget(isMobile: isMobile)),
      ],
    );
  }

  Widget _buildMobileLayout(bool isMobile) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            _buildProfileSection(isMobile),
            GridSectionWidget(isMobile: isMobile)
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(bool isMobile) {
    return Padding(
      padding:
          EdgeInsets.only(left: isMobile ? 0.0 : 150, top: isMobile ? 30 : 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          MouseRegion(
            onEnter: (_) => hoverController.onHover(true),
            onExit: (_) => hoverController.onHover(false),
            cursor: SystemMouseCursors.click,
            child: Obx(() => CircleAvatar(
                  radius: isMobile ? 80 : 100,
                  backgroundImage: _selectedImage != null
                      ? NetworkImage(_selectedImage!.path)
                      : const NetworkImage('https://i.imgur.com/BoN9kdC.png')
                          as ImageProvider,
                  backgroundColor: hoverController.isHovered.value
                      ? Colors.blue
                      : Colors.transparent,
                  child: Stack(
                    children: [
                      isMobile
                          ? Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                  style: AppStyles.circleIconButtonStyle,
                                  onPressed: _pickImage,
                                  icon: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: AppColors.kWhite,
                                      child: const Icon(
                                        Icons.add,
                                      ))),
                            )
                          : Align(
                              alignment: Alignment.bottomRight,
                              child: HoverButton(
                                icon: CupertinoIcons.add,
                                isHovered: hoverController.isHovered.value,
                                onPressed: _pickImage,
                              ),
                            ),
                    ],
                  ),
                )),
          ),
          const SizedBox(height: 16),
          const Text(
            'Character',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'CEO, Co-Founder at GTA Sand, LLC.\nSenior Game Engineer.',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class Link extends StatelessWidget {
  const Link({super.key});

  @override
  Widget build(BuildContext context) {
    return AnyLinkPreview(
      link: "https://www.facebook.com/",
      displayDirection: UIDirection.uiDirectionHorizontal,
      showMultimedia: false,

      bodyMaxLines: 5,
      bodyTextOverflow: TextOverflow.ellipsis,
      titleStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      bodyStyle: const TextStyle(color: Colors.grey, fontSize: 12),
      errorBody: 'Show my custom error body',
      errorTitle: 'Show my custom error title',
      errorWidget: Container(
        color: Colors.grey[300],
        child: const Text('Oops!'),
      ),
      errorImage: "https://google.com/",
      cache: const Duration(days: 7),
      backgroundColor: Colors.grey[300],
      borderRadius: 12,
      removeElevation: false,
      boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.grey)],
      onTap: () {}, // This disables tap event
    );
  }
}
