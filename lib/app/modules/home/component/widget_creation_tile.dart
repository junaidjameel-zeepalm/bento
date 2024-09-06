import 'dart:developer';
import 'package:bento/app/controller/hover_controller.dart';
import 'package:bento/app/data/constant/app_typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controller/home_controller.dart';
import '../../../data/constant/app_colors.dart';
import '../../../data/enums/shape_enum.dart';

import 'custom_shapes_tile.dart';

class WidgetCreationTile extends StatefulWidget {
  const WidgetCreationTile({super.key});

  @override
  WidgetCreationTileState createState() => WidgetCreationTileState();
}

class WidgetCreationTileState extends State<WidgetCreationTile>
    with SingleTickerProviderStateMixin {
  bool _showLinkInput = false;
  final FocusNode _focusNode = FocusNode();
  late final HomeController hc;

  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;
  String _selectedImagePath = '';

  @override
  void initState() {
    super.initState();

    hc = Get.find<HomeController>();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus && _showLinkInput) {
      _toggleLinkInputVisibility();
    }
  }

  void _toggleLinkInputVisibility() {
    setState(() {
      _showLinkInput = !_showLinkInput;
      if (_showLinkInput) {
        _animationController.forward();
        _focusNode.requestFocus();
      } else {
        _animationController.reverse();
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
      hc.addItem(type: ItemType.image, content: _selectedImagePath);
    } else {
      log('Image not Selected');
    }
  }

  Future<void> _onPhotoIconPressed() async {
    await _pickImage(ImageSource.gallery);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Get.width < 1300;

    return Obx(() {
      final selectedItem = hc.selectedItemId.value.isNotEmpty
          ? hc.getItem(hc.selectedItemId.value)
          : null;

      final isSectionTileShape =
          selectedItem?.shape != ShapeType.sectionTileShape;

      return selectedItem != null && isMobile && isSectionTileShape
          ? SizedBox(
              width: Get.width * 0.65,
              child: CustomShapeButton(
                onShapeSelected: (ShapeType shape) {
                  hc.updateItemShape(hc.selectedItemId.value, shape);
                },
              ),
            )
          : GestureDetector(
              onTap: () {
                if (_showLinkInput) _toggleLinkInputVisibility();
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: _showLinkInput,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: AnimatedOpacity(
                        opacity: _showLinkInput ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: _showLinkInput
                            ? LinkInputField(onHide: _toggleLinkInputVisibility)
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 8)
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildIcons(),
                        if (!isMobile) const SizedBox(width: 12.0),
                        if (!isMobile) _divider(),
                        if (!isMobile) _buildDeviceIcons(),
                      ],
                    ),
                  ),
                ],
              ),
            );
    });
  }

  Widget _buildIcons() {
    final List<IconData> icons = [
      Icons.link,
      CupertinoIcons.photo,
      Icons.format_quote,
      CupertinoIcons.selection_pin_in_out,
    ];

    return Row(
      children: List.generate(icons.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: _buildIconButton(icons[index], index),
        );
      }),
    );
  }

  Widget _buildIconButton(IconData icon, int index) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kWhite.withOpacity(.7),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AppColors.kgrey.withOpacity(.25)),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.grey[800]),
        onPressed: () {
          if (index == 0) {
            _toggleLinkInputVisibility();
          } else if (index == 1) {
            _onPhotoIconPressed();
          } else if (index == 2) {
            hc.addItem(type: ItemType.text, content: '');
          } else if (index == 3) {
            hc.addItem(type: ItemType.sectionTile, content: 'section tile');
          }
        },
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 24,
      color: Colors.grey[400],
    );
  }

  Widget _buildDeviceIcons() {
    return Row(
      children: [
        Container(
          //   padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: IconButton(
              onPressed: () => Get.find<HoverController>()
                  .setInitialView(DeviceView.desktop),
              icon: const Icon(Icons.laptop, color: Colors.white)),
        ),
        const SizedBox(width: 8.0),
        IconButton(
          icon: Icon(Icons.phone_android, color: Colors.grey[800]),
          onPressed: () =>
              Get.find<HoverController>().setInitialView(DeviceView.mobile),
        ),
      ],
    );
  }
}

class LinkInputField extends StatefulWidget {
  final VoidCallback onHide;

  const LinkInputField({super.key, required this.onHide});

  @override
  LinkInputFieldState createState() => LinkInputFieldState();
}

class LinkInputFieldState extends State<LinkInputField> {
  late final HomeController _hc;
  String _buttonText = 'Paste';
  Color _buttonColor = AppColors.kPrimary;

  @override
  void initState() {
    super.initState();

    _hc = Get.find<HomeController>(); // Use Get.find to get the instance

    // Listen for changes in the text field
    _hc.linkController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      if (_hc.linkController.text.isEmpty) {
        _buttonText = 'Paste';
        _buttonColor = AppColors.kPrimary;
      } else {
        _buttonText = 'Add';
        _buttonColor = const Color.fromARGB(255, 85, 222, 90);
      }
    });
  }

  @override
  void dispose() {
    _hc.linkController.removeListener(_updateButtonState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isMobile = constraints.maxWidth < 1300;
      return Container(
        width: isMobile ? Get.width * .5 : Get.width * .17,
        padding: const EdgeInsets.only(right: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _hc.linkController,
                decoration: InputDecoration(
                  hintText: 'Enter Link',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 15.0),
                ),
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: () {
                log('Link: ${_hc.linkController.text}, isNotEmpty: ${_hc.linkController.text.isNotEmpty}');
                if (_hc.linkController.text.isNotEmpty) {
                  _hc.addItem(
                      type: ItemType.link, content: _hc.linkController.text);
                  _hc.linkController.clear();
                  widget.onHide(); // Hide the LinkInputField
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.kBlack,
                backgroundColor: _buttonColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                side: BorderSide(color: AppColors.kgrey.withOpacity(.25)),
              ),
              child: Text(
                _buttonText,
                style: AppTypography.kSemiBold16.copyWith(
                    fontSize: 13,
                    color: _buttonText == 'Add'
                        ? AppColors.kWhite
                        : AppColors.kBlack),
              ),
            ),
          ],
        ),
      );
    });
  }
}
