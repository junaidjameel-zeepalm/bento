import 'dart:developer';

import 'package:bento/app/controller/home_controller.dart';
import 'package:bento/app/data/constant/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../model/gridItem_model.dart';

class WidgetCreationTile extends StatefulWidget {
  const WidgetCreationTile({super.key});

  @override
  WidgetCreationTileState createState() => WidgetCreationTileState();
}

class WidgetCreationTileState extends State<WidgetCreationTile>
    with SingleTickerProviderStateMixin {
  late final HomeController hc;

  bool _showLinkInput = false;
  final FocusNode _focusNode = FocusNode();

  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    hc = Get.put(HomeController()); // Get existing instance

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(.0, -0.3),
      end: Offset.zero, // End at its normal position
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

  String _selectedImagePath = '';

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
      hc.addItem(type: ItemType.image, content: _selectedImagePath);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No image selected'),
        ),
      );
    }
  }

  Future<void> _onPhotoIconPressed() async {
    await _pickImage(
        ImageSource.gallery); // Open image picker to select from gallery
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
    final List<IconData> icons = [
      Icons.link,
      CupertinoIcons.photo,
      Icons.format_quote,
    ];

    return GestureDetector(
      onTap: () {
        if (_showLinkInput) _toggleLinkInputVisibility();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SlideTransition(
            position: _slideAnimation,
            child: AnimatedOpacity(
              opacity: _showLinkInput ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: _showLinkInput
                  ? LinkInputField(focusNode: _focusNode)
                  : const SizedBox.shrink(),
            ),
          ),
          const SizedBox(height: 12.0),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 85, 222, 90),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Share my Profile',
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 8.0),
                ...icons.map((icon) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.kWhite.withOpacity(.7),
                        borderRadius: BorderRadius.circular(8.0),
                        border:
                            Border.all(color: AppColors.kgrey.withOpacity(.25)),
                      ),
                      child: IconButton(
                        icon: Icon(icon, color: Colors.grey[800]),
                        onPressed: () {
                          if (icon == Icons.link) {
                            _toggleLinkInputVisibility();
                          } else if (icon == CupertinoIcons.photo) {
                            _onPhotoIconPressed(); // Call method to pick image
                          } else {
                            // Handle text item creation
                            hc.addItem(
                                type: ItemType.text, content: 'Sample Text');
                          }
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 12.0),
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.grey[400],
                ),
                const SizedBox(width: 12.0),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(Icons.laptop, color: Colors.white),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.phone_android, color: Colors.grey[800]),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LinkInputField extends StatefulWidget {
  final FocusNode focusNode;

  const LinkInputField({super.key, required this.focusNode});

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

    _hc = Get.find<HomeController>(); // Get existing instance

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
    return Container(
      width: Get.width * .2, // Adjust the width to your needs
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
              focusNode: widget.focusNode,
              decoration: InputDecoration(
                hintText: 'Enter Link',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
              ),
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            onPressed: () {
              if (_hc.linkController.text.isNotEmpty) {
                _hc.addItem(
                    type: ItemType.link, content: _hc.linkController.text);
                _hc.linkController.clear();
              }
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.kBlack,
              backgroundColor: _buttonColor,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              side: BorderSide(
                  color: AppColors.kgrey
                      .withOpacity(.25)), // Set the border color to grey
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
  }
}
