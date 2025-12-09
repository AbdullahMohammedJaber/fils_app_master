
import 'package:flutter/widgets.dart';

class ClassifiedGeneral extends ChangeNotifier{

  bool showFormFieldSearch = false;
  runAnimation() {
    Future.delayed(const Duration(milliseconds: 100), () {
      showFormFieldSearch = true;
      notifyListeners();
    });
  }
  @override
  void dispose() {
    showFormFieldSearch = false;
    super.dispose();
  }
}