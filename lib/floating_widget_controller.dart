import 'package:flutter/material.dart';

class FloatingWidgetController extends ValueNotifier<bool> {
  FloatingWidgetController(bool value) : super(value);

  void show() {
    value = true;
  }

  void hide() {
    value = false;
  }

  void toggle() {
    value = !value;
  }
}
