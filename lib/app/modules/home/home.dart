import 'dart:io';
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.find<HomeController>().selectedItemId.value = '',
      child: Scaffold(
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
