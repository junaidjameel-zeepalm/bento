import 'dart:developer';

import 'package:bento/app/controller/home_controller.dart';
import 'package:bento/app/data/constant/data.dart';
import 'package:bento/app/data/constant/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/enums/shape_enum.dart';
import '../../../model/gridItem_model.dart';
import '../../../widget/hover_delete_btn.dart';
import 'custom_shapes_tile.dart';

class OnHoverButton extends StatefulWidget {
  final String itemId;
  final bool isMobile;
  const OnHoverButton({super.key, required this.itemId, this.isMobile = false});

  @override
  State<OnHoverButton> createState() => _OnHoverButtonState();
}

class _OnHoverButtonState extends State<OnHoverButton> {
  final HomeController _hc = Get.find<HomeController>();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    _textController.text = _hc.getItem(widget.itemId).text ?? '';

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  Widget build(BuildContext context) {
    return widget.isMobile ? _hoverMobile(context) : _hoverDesktop(context);
  }

  Widget _hoverDesktop(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final scalingFactor =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? screenWidth / 500
            : screenHeight / 900;

    final shapeSizes = {
      ShapeType.square: Size(200 * scalingFactor, 250 * scalingFactor),
      ShapeType.smallRectangle: Size(400 * scalingFactor, 250 * scalingFactor),
      ShapeType.mediumRectangle: Size(200 * scalingFactor, 460 * scalingFactor),
      ShapeType.largeSquare: Size(430 * scalingFactor, 460 * scalingFactor),
    };

    return Obx(() {
      final selectedShape = _hc.getItemShape(widget.itemId);
      final item = _hc.getItem(widget.itemId);
      final containerSize = shapeSizes[selectedShape]!;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              log('Item ID: ${item.id}, Type: ${item.type}, Shape: $selectedShape');
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.grab,
              onEnter: (_) => setState(() => isHovered = true),
              onExit: (_) => setState(() => isHovered = false),
              child: Stack(
                children: [
                  AnimatedContainer(
                    width: containerSize.width,
                    height: containerSize.height,
                    duration: const Duration(milliseconds: 200),
                    transform: isHovered
                        ? Matrix4.translationValues(0, -10, 0)
                        : Matrix4.identity(),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 50),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              border: Border.all(color: Colors.grey[300]!),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: _buildContentWidget(item, containerSize),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: isHovered ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 250),
                          child: SizedBox(
                            width: 200,
                            child: CustomShapeButton(
                              onShapeSelected: (ShapeType shape) {
                                _hc.updateItemShape(widget.itemId, shape);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  HoverButton(
                    isHovered: isHovered,
                    onPressed: () => _hc.deleteItem(widget.itemId),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _hoverMobile(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final scalingFactor =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? screenWidth / 500
            : screenHeight / 900;

    final shapeSizes = {
      ShapeType.square: Size(200 * scalingFactor, 250 * scalingFactor),
      ShapeType.smallRectangle: Size(400 * scalingFactor, 250 * scalingFactor),
      ShapeType.mediumRectangle: Size(200 * scalingFactor, 460 * scalingFactor),
      ShapeType.largeSquare: Size(430 * scalingFactor, 460 * scalingFactor),
    };

    return Obx(() {
      final selectedShape = _hc.getItemShape(widget.itemId);
      final item = _hc.getItem(widget.itemId);
      final containerSize = shapeSizes[selectedShape]!;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              AnimatedContainer(
                width: containerSize.width,
                height: containerSize.height,
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: () => _hc.setSelectedItem(widget.itemId),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 50),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            border: Border.all(
                              color: _hc.selectedItemId.value == widget.itemId
                                  ? Colors.blue[800]!
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: _buildContentWidget(item, containerSize),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _hc.selectedItemId.value == widget.itemId
                  ? Container(
                      transform: Matrix4.translationValues(-10, -15, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: IconButton(
                          style: AppStyles.circleIconButtonStyle,
                          onPressed: () {
                            _hc.deleteItem(widget.itemId);
                            _hc.selectedItemId.value = '';
                          },
                          icon: const Icon(
                            CupertinoIcons.delete,
                            size: 16,
                          )),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ],
      );
    });
  }

  Widget _buildContentWidget(GridItem item, Size containerSize) {
    switch (item.type) {
      case ItemType.link:
        return _buildLinkWidget(item.link);
      case ItemType.image:
        return _buildImageWidget(item.imagePath, containerSize);
      case ItemType.text:
        return _buildTextWidget(isHovered, containerSize);
      default:
        return Container();
    }
  }

  Widget _buildLinkWidget(String? link) {
    return Center(
      child: Text(
        link ?? '',
        style: const TextStyle(color: Colors.blue),
      ),
    );
  }

  Widget _buildImageWidget(String? imagePath, Size containerSize) {
    return imagePath != null
        ? Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                imagePath,
                width: containerSize.width,
                height: containerSize.height,
                fit: BoxFit.cover,
              ),
            ),
          )
        : Container();
  }

  Widget _buildTextWidget(isHovered, Size containerSize) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(12),
        height: containerSize.height,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color:
              isHovered ? AppColors.kgrey.withOpacity(.4) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          maxLines: null,
          cursorColor: AppColors.kBlack,
          focusNode: _focusNode,
          controller: _textController,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            hintText: 'Add note...',
            hintStyle:
                AppTypography.kRegular16.copyWith(fontWeight: FontWeight.w600),
            border: InputBorder.none,
          ),
          onChanged: (newValue) {
            _hc.updateItemText(widget.itemId, newValue);
          },
        ),
      ),
    );
  }
}
