import 'package:flutter/foundation.dart';
import 'dart:ui' as ui;

class ScreenSize {
  static double get width {
    if (kIsWeb) {
      return ui.PlatformDispatcher.instance.views.first.physicalSize.width /
          ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
    }

    return ui.PlatformDispatcher.instance.views.first.physicalSize.width /
        ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
  }

  static double get height {
    if (kIsWeb) {
      return ui.PlatformDispatcher.instance.views.first.physicalSize.height /
          ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
    }

    return ui.PlatformDispatcher.instance.views.first.physicalSize.height /
        ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
  }

  static bool get isMobile {
    return width < 768;
  }

  static bool get isTablet {
    return width >= 768 && width < 1200;
  }

  static bool get isDesktop {
    return width >= 1200;
  }
}
