import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

extension DeviceCheck on BuildContext {
  bool get isDesktop => ResponsiveBreakpoints.of(this).largerThan(MOBILE);
}
