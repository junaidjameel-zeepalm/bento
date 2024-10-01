import 'package:bento/app/controller/home_controller.dart';
import 'package:bento/app/controller/user_controller.dart';
import 'package:bento/app/data/constant/app_colors.dart';
import 'package:bento/app/data/constant/app_typography.dart';
import 'package:bento/app/modules/home/component/addUserImg.dart';
import 'package:bento/app/modules/home/component/grid_section_widget.dart';
import 'package:bento/app/modules/home/component/settings_widget.dart';
import 'package:bento/app/modules/home/component/widget_creation_tile.dart';
import 'package:bento/app/widget/hover_delete_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../controller/hover_controller.dart';
import '../explore/explore.dart';

class BentoHomePage extends StatefulWidget {
  const BentoHomePage({super.key});

  @override
  BentoHomePageState createState() => BentoHomePageState();
}

class BentoHomePageState extends State<BentoHomePage> {
  final HoverController hoverController = Get.find<HoverController>();
  final ScrollController _scrollController =
      ScrollController(); // Add this line

  UserController get uc => Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (hc) {
      return GestureDetector(
          onTap: () {
            hc.selectedItemId.value = '';
            hoverController.showLinkInput.value = false;
          },
          child: Scaffold(
            backgroundColor:
                kIsWeb ? AppColors.kgrey.withOpacity(.3) : Colors.white,
            resizeToAvoidBottomInset: true,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: const WidgetCreationTile(),
            body: Obx(
              () {
                hoverController.initialView;
                return Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        bool isMobile = constraints.maxWidth < 1300;

                        return ScrollbarTheme(
                          data: ScrollbarThemeData(
                            thumbColor: WidgetStateProperty.all(
                                Colors.grey.withOpacity(.8)),
                          ),
                          child: Scrollbar(
                            controller:
                                _scrollController, // Add the controller here
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller:
                                  _scrollController, // Add the controller here
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (hoverController.initialView ==
                                        DeviceView.mobile)
                                      Center(
                                        child: Container(
                                          margin: const EdgeInsets.all(20),
                                          alignment: Alignment.center,
                                          width: 500,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: _buildMobileLayout(
                                              Get.width > 600),
                                        ),
                                      )
                                    else
                                      isMobile
                                          ? _buildMobileLayout(isMobile)
                                          : _buildDesktopLayout(isMobile),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        bool isWeb = constraints.maxWidth > 1300;

                        return isWeb
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, bottom: 20),
                                child: Row(
                                  children: [
                                    const SettingsWidget(),
                                    IconButton(
                                        onPressed: () =>
                                            Get.to(() => const ExploreView()),
                                        icon:
                                            const Icon(Icons.explore_outlined)),
                                    const SizedBox(
                                        height: 30, child: VerticalDivider()),
                                    Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Text('2 Views Yesterday')),
                                  ],
                                ),
                              )
                            : const SizedBox();
                      },
                    ),
                  ],
                );
              },
            ),
          ));
    });
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
          child: GridSectionWidget(isMobile: isMobile),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(bool isMobile) {
    return SingleChildScrollView(
      child: Center(
        child: Stack(
          children: [
            const Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: SettingsWidget(),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Center(child: _buildProfileSection(isMobile)),
                ),
                GridSectionWidget(isMobile: isMobile),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(bool isMobile) {
    return Padding(
      padding: EdgeInsets.only(
        left: isMobile ? 0.0 : 150,
        top: isMobile ? 30 : 60,
        right: isMobile ? 50 : 0,
      ),
      child: Column(
        crossAxisAlignment:
            isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const AddImageWidget(),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(left: isMobile ? 0 : 20.0),
            child: Obx(() => Text(
                  uc.user!.name!.capitalize!,
                  style: AppTypography.kBold28.copyWith(fontSize: 25),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(left: isMobile ? 0 : 20.0),
            child: TextField(
              maxLines: 4,
              textAlign: isMobile ? TextAlign.center : TextAlign.start,
              controller: uc.bioController,
              onChanged: (value) => uc.updateText,
              style: AppTypography.kRegular16.copyWith(fontSize: 20),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Your Bio ...',
                hintStyle: AppTypography.kRegular16.copyWith(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
