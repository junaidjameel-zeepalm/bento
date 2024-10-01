import 'package:get/get.dart';

class HoverController extends GetxController {
  var isHovered = false.obs;

  void onHover(bool hover) {
    isHovered.value = hover;
  }

  final _initialView = DeviceView.desktop.obs;
  DeviceView get initialView => _initialView.value;
  void setInitialView(DeviceView view) {
    _initialView.value = view;
    update();
  }

  var showLinkInput = false.obs;

  void toggleLinkInputVisibility() {
    showLinkInput.value = !showLinkInput.value;
  }
}

enum DeviceView { mobile, desktop }
