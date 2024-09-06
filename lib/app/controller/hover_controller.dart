import 'package:get/get.dart';

class HoverController extends GetxController {
  var isHovered = false.obs;

  void onHover(bool hover) {
    isHovered.value = hover;
  }

  var initialView = DeviceView.desktop.obs;

  void setInitialView(DeviceView view) {
    initialView.value = view;
  }
}

enum DeviceView { mobile, desktop }
