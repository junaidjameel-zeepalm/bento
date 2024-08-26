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
              },
              builder: (children) {
                return Wrap(
                  children: children,
                );
              },
              children: List.generate(
                _hc.items.length,
                (index) {
                  return ReorderableDragStartListener(
                    index: index,
                    key: ValueKey(_hc.items[index]),
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

// class CustomWrap extends Wrap {
//   const CustomWrap({
//     required super.children,
//     super.direction,
//     super.alignment,
//     super.spacing,
//     super.runAlignment,
//     super.runSpacing,
//     super.crossAxisAlignment,
//     super.textDirection,
//     super.verticalDirection,
//     Clip clip = Clip.none,
//     String? key,
//   }) : super(
//           clipBehavior: clip,
//           key: key,
//         );
// }
