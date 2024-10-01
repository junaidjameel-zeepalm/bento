import 'package:bento/app/controller/home_controller.dart';
import 'package:bento/app/model/gridItem_model.dart';
import 'package:bento/app/modules/home/component/hover_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:get/get.dart';

class GridSectionWidget extends StatefulWidget {
  final bool isMobile;
  const GridSectionWidget({super.key, required this.isMobile});

  @override
  State<GridSectionWidget> createState() => _GridSectionWidgetState();
}

class _GridSectionWidgetState extends State<GridSectionWidget> {
  final HomeController _hc = Get.find<HomeController>();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: EdgeInsets.all(widget.isMobile ? 0 : 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: widget.isMobile ? 550 : null,
              child: widget.isMobile ? _buildMobileGrid() : _buildDesktopGrid(),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileGrid() {
    return Obx(() {
      return ReorderableBuilder(
        automaticScrollExtent: 10,
        dragChildBoxDecoration: const BoxDecoration(color: Colors.transparent),
        enableLongPress: false,
        enableDraggable: _hc.selectedItemId.value != '' ? true : false,
        scrollController: _scrollController,
        onReorder: (List<dynamic> Function(List<dynamic>) reorderFunction) {
          var newItems = reorderFunction(_hc.items).cast<GridItem>();
          _hc.reorderItems(newItems);
        },
        builder: (children) {
          return _hc.items.length > 1
              ? Center(
                  child: Wrap(
                    children: children,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Wrap(
                    children: children,
                  ),
                );
        },
        children: List.generate(
          _hc.items.length,
          (index) {
            final item = _hc.items[index];

            // Use OnHoverButton instead of the previous grid items
            return ReorderableDragStartListener(
              index: index,
              key: ValueKey(item.id),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: OnHoverButton(
                  itemId: item.id,
                  isMobile: widget.isMobile,
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildDesktopGrid() {
    return Obx(() {
      return ReorderableBuilder(
        automaticScrollExtent: 10,
        dragChildBoxDecoration: const BoxDecoration(color: Colors.transparent),
        enableLongPress: false,
        enableDraggable: true,
        scrollController: _scrollController,
        onReorder: (List<dynamic> Function(List<dynamic>) reorderFunction) {
          var newItems = reorderFunction(_hc.items).cast<GridItem>();
          _hc.reorderItems(newItems);
        },
        builder: (children) {
          return Wrap(
            children: children,
          );
        },
        children: List.generate(
          _hc.items.length,
          (index) {
            final item = _hc.items[index];

            return ReorderableDragStartListener(
              index: index,
              key: ValueKey(item.id),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: OnHoverButton(itemId: item.id),
              ),
            );
          },
        ),
      );
    });
  }
}
