import 'package:flutter/material.dart';

class AppState {
  static final ValueNotifier<bool> isOverlayOpen = ValueNotifier<bool>(false);

  static void setOverlay(bool isOpen) {
    isOverlayOpen.value = isOpen;
  }
}
