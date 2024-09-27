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

  var showLinkInput = false.obs;

  void toggleLinkInputVisibility() {
    showLinkInput.value = !showLinkInput.value;
  }
}

enum DeviceView { mobile, desktop }
