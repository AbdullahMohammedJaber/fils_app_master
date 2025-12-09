import 'package:easy_localization/easy_localization.dart';

enum PlaceAds { popup, home_screen, category_screen }

String handleAdPlacement({required String place}) {
  final matchedEnum = PlaceAds.values.firstWhere((e) => e.name == place);

  switch (matchedEnum) {
    case PlaceAds.popup:
      return "Special".tr();
    case PlaceAds.home_screen:
      return "Banners".tr();
    case PlaceAds.category_screen:
      return "Category Section".tr();
  }
}
