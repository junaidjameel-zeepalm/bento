import 'package:bento/app/controller/home_controller.dart';
import 'package:bento/app/modules/home/component/hover_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class GridSectionWidget extends StatefulWidget {
  final bool isMobile;
  const GridSectionWidget({super.key, required this.isMobile});

  @override
  State<GridSectionWidget> createState() => _GridSectionWidgetState();
}

class _GridSectionWidgetState extends State<GridSectionWidget> {
  final HomeController _hc = Get.put(HomeController());
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: EdgeInsets.all(widget.isMobile ? 0 : 60),
          child: SizedBox(
            width: widget.isMobile ? 410 : null,
            child: ReorderableBuilder(
              dragChildBoxDecoration:
                  const BoxDecoration(color: Colors.transparent),
              enableLongPress: false,
              enableDraggable: true,
              scrollController: _scrollController,
              onReorder:
                  (List<dynamic> Function(List<dynamic>) reorderFunction) {
                var newItems = reorderFunction(_hc.items).cast<String>();
                _hc.reorderItems(newItems);

                // No need to update itemShapes explicitly, as it uses item IDs as keys, which remain consistent
              },
              builder: (children) {
                return MasonryGridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.isMobile ? 2 : 4,
                  ),
                  children: children,
                );
              },
              children: List.generate(
                _hc.items.length,
                (index) {
                  return SizedBox(
                    key: ValueKey(
                        _hc.items[index]), // Use the item identifier as the key
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: OnHoverButton(
                          itemId: _hc.items[index]), // Pass the item identifier
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}
