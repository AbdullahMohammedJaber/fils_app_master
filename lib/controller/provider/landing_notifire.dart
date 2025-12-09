import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LandingPageNotifire extends ChangeNotifier {
  dynamic pageInit = 0;
  PageController pageController = PageController(initialPage: 0);
  List<Map<String, dynamic>> landingList = [];

  LandingPageNotifire() {
    passedListIntro();
  }

  passedListIntro() {
    landingList = [
      {
        "title": "public auction.".tr(),
        "des": "The application provides a public auction for products offered by their owners and sold by visitors at the highest price, according to the available item.".tr(),
        "image": "assets/images/landing1.png",
      },
      {
        "title": "Online store".tr(),
        "des": "The application provides electronic products, where products are purchased from the application at prices suitable for all categories.".tr(),
        "image": "assets/images/landing2.png",
      },
      {
        "title": "Reels".tr(),
        "des": "The application provides videos showing products, their prices, and their materials, as well as auction products, for example, for advertisements.".tr(),
        "image": "assets/images/landing3.png",
      },
    ];

    notifyListeners();
  }

  nextPage() {
    if (pageInit != landingList.length - 1) {
      pageInit++;
      pageController.animateToPage(pageInit,
          duration: const Duration(milliseconds: 180), curve: Curves.easeIn);
    }

    notifyListeners();
  }

  backPage() {
    if (pageInit <= landingList.length - 1) {
      pageInit--;
      pageController.animateToPage(pageInit,
          duration: const Duration(milliseconds: 180), curve: Curves.easeIn);
    }
    notifyListeners();
  }

  onPageChange(dynamic index) {
    pageInit = index;
    pageController.animateToPage(pageInit,
        duration: const Duration(milliseconds: 180), curve: Curves.ease);
    notifyListeners();
  }
}
