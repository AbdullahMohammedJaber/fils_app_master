import 'package:flutter/material.dart';

class FloatingButtonController extends ChangeNotifier {
  bool _showButton = true;

  bool get showButton => _showButton;

  void show() {
    _showButton = true;
    notifyListeners();
  }

  void hide() {
    _showButton = false;
    notifyListeners();
  }
}
