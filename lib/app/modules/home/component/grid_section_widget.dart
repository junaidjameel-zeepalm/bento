import 'package:bento/app/controller/home_controller.dart';
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
  final HomeController _hc = Get.put(HomeController());
  final _scrollController = ScrollController();
  int? _draggedIndex; // Track the index of the dragged item

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
            width: widget.isMobile ? 550 : null,
            child: ReorderableBuilder(
              automaticScrollExtent: 10,
              dragChildBoxDecoration:
                  const BoxDecoration(color: Colors.transparent),
              enableLongPress: false,
              enableDraggable: true,
              scrollController: _scrollController,
              onReorder:
                  (List<dynamic> Function(List<dynamic>) reorderFunction) {
                var newItems = reorderFunction(_hc.items).cast<String>();
                _hc.reorderItems(newItems);
                setState(() {
                  _draggedIndex = null; // Clear the dragged index after reorder
                });
              },
              builder: (children) {
                return Wrap(
                  children: children,
                );
              },
              children: List.generate(
                _hc.items.length,
                (index) {
                  // Use a unique key for every child based on item identifier and index
                  return ReorderableDragStartListener(
                    index: index,
                    key: ValueKey('${_hc.items[index]}_$index'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Stack(
                        children: [
                          OnHoverButton(
                            key: ValueKey(
                                'hover_${_hc.items[index]}'), // Unique key for OnHoverButton
                            itemId:
                                _hc.items[index], // Pass the item identifier
                          ),
                          if (_draggedIndex ==
                              index) // Show placeholder if dragging
                            Positioned.fill(
                              child: Container(
                                height: 20,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.blue, width: 2),
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.red,
                                ),
                              ),
                            ),
                        ],
                      ),
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
