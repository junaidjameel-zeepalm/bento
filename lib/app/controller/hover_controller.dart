import 'package:get/get.dart';

class HoverController extends GetxController {
  var isHovered = false.obs;

  void onHover(bool hover) {
    isHovered.value = hover;
  }
}
