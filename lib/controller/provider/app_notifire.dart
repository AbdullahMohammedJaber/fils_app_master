import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/model/app/chat_bot_model.dart';
import 'package:fils/screen/Seller/wallet/wallet_screen.dart';

import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/route/route.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fils/screen/Buyer/favourite/favourait_screen.dart';
import 'package:fils/screen/Buyer/wallet/funds_wallet.dart';
import 'package:fils/screen/Seller/control_auction/auction_seller_screen.dart';
import 'package:fils/screen/Seller/control_product/product_seller.dart';
import 'package:fils/screen/Seller/order/order_seller.dart';
import 'package:fils/screen/general/home.dart';

import 'package:fils/utils/enum/language_type.dart';
import 'package:fils/utils/global_function/printer.dart';
import 'package:fils/utils/storage/storage.dart';

import '../../screen/Buyer/cart/product_store/cart_screen.dart';
import '../../screen/Buyer/profile/profile_screen.dart';
import '../../screen/Buyer/store/store_screen.dart';
import '../../screen/Seller/profile/profile_seller.dart';
import '../../screen/plugins/maintenance_scren.dart';

class AppNotifire extends ChangeNotifier {
  AppNotifire() {
    runSyncTasksInOrder([clearRoot, checkMaintenanceMode]);
  }

  String currancy = "KWD".tr();

  clearRoot() {
    selectPageRoot = 0; // 4
  }

  List<Widget> screenList = [
    HomeScreen(),
    FundsWalletScreen(),
    CartScreen(),

    ProfileScreen(),
    const FundsWalletScreen(),
  ];
  List<Widget> screenListSeller = [
    HomeScreen(),
    const ProductSellerScreen(),
    const AuctionSellerScreen(isAds: false),
    const OrderSeller(isPop: false),
    const ProfileSeller(),
  ];
  List<Map<String, dynamic>> screenIcons = [
    {"icons": "assets/icons/home_nav.svg", "title": "Home".tr()},
    {"icons": "assets/icons/wallet.svg", "title": "Wallet".tr()},
    {"icons": "assets/icons/cart_nav.svg", "title": "Cart".tr()},
    {"icons": "assets/icons/user_nav.svg", "title": "Profile".tr()},
  ];
  List<Map<String, dynamic>> screenIconsSeller = [
    {"icons": "assets/icons/home_nav.svg", "title": "Home".tr()},
    {"icons": "assets/icons/product.svg", "title": "Product".tr()},
    {"icons": "assets/icons/auction_nav.svg", "title": "Auctions".tr()},
    {"icons": "assets/icons/cart_nav.svg", "title": "Orders".tr()},
    {"icons": "assets/icons/user_nav.svg", "title": "Profile".tr()},
  ];
  dynamic selectPageRoot = 0; // 4
  onClickBottomNavigationBar(dynamic index) {
    selectPageRoot = index;
    notifyListeners();
  }

  Locale _appLocale = const Locale('en');

  Locale get appLocale => _appLocale;

  void changeLanguage(
    BuildContext context, {
    required LanguageType? languageType,
  }) {
    selectLanguage(true);
    if (languageType == LanguageType.ARABIC) {
      _appLocale = const Locale('ar');
      context.setLocale(_appLocale);
      setLang('ar');
      setLocal('sa');
      notifyListeners();
    } else if (languageType == LanguageType.ENGLISH) {
      _appLocale = const Locale('en');
      context.setLocale(_appLocale);
      setLang('en');
      setLocal('en');
      notifyListeners();
    } else if (languageType == LanguageType.Hindi) {
      _appLocale = const Locale('de');
      context.setLocale(_appLocale);
      setLang('en');
      setLocal('in');
      notifyListeners();
    } else if (languageType == LanguageType.Farsi) {
      _appLocale = const Locale('fa');
      context.setLocale(_appLocale);
      setLang('ar');
      setLocal('ir');
      notifyListeners();
    } else if (languageType == LanguageType.Urdu) {
      _appLocale = const Locale('ur');
      context.setLocale(_appLocale);
      setLang('ar');
      setLocal('pk');
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> paymentMethodeList = [
    {
      "id": 1,
      "name": "Cash on Delivery".tr(),
      "select": false,
      "image": "assets/images/cach.png",
    },
    {
      "id": 2,
      "name": "Visa card".tr(),
      "select": false,
      "image": "assets/images/visa.png",
    },
    {
      "id": 3,
      "name": "Paypal".tr(),
      "select": false,
      "image": "assets/images/paypal.png",
    },
    {
      "id": 4,
      "name": "Master card".tr(),
      "select": false,
      "image": "assets/images/mastercard.png",
    },
    {
      "id": 5,
      "name": "Knet".tr(),
      "select": false,
      "image": "assets/images/knet.png",
    },
  ];
  dynamic pageTapBarFav = 1;
  String url = "wishlists?is_auction=0";

  changePageTapBar({required dynamic index}) {
    pageTapBarFav = index;
    notifyListeners();
  }

  changeUrlFav(String urlNew) {
    url = urlNew;
    printGreen(url);
    notifyListeners();
    updateControllerFav!.updateWithNewUrl(url);
  }

  bool sound = true;
  bool notifications = true;
  bool vibration = true;

  changeSound(bool value) {
    sound = value;
    notifyListeners();
  }

  changeVibration(bool value) {
    vibration = value;
    notifyListeners();
  }

  changeNotifications(bool value) {
    notifications = value;
    notifyListeners();
  }

  dynamic selectSubscribe = -1;

  changeIndexSubscribe(dynamic index) {
    selectSubscribe = index;
    notifyListeners();
  }

  Timer? _autoScrollTimer;

  List<Map<String, String>> LanguageList = [
    {'name': 'اللغة العربية', 'type': 'ar'},
    {'name': "English Language", 'type': 'en'},
    {'name': "اردو", 'type': 'ur'},
    {'name': "हिंदी भाषा", 'type': 'hi'},
    {'name': "فارسي", 'type': 'fa'},
  ];
  String? selectedLanguage;

  changeSelectedLanguage(BuildContext context, String value) {
    selectedLanguage = value;

    notifyListeners();
    if (selectedLanguage == 'ar') {
      changeLanguage(context, languageType: LanguageType.ARABIC);
    }
    if (selectedLanguage == 'ur') {
      changeLanguage(context, languageType: LanguageType.Urdu);
    }
    if (selectedLanguage == 'hi') {
      changeLanguage(context, languageType: LanguageType.Hindi);
    }
    if (selectedLanguage == 'fa') {
      changeLanguage(context, languageType: LanguageType.Farsi);
    }
    if (selectedLanguage == 'en') {
      changeLanguage(context, languageType: LanguageType.ENGLISH);
    }
  }

  List<ChatBotModel> chatBotList = [];
  bool isLoadingBot = false;

  sendQuestion(String question) async {
    changeDomain1();
    if (question.isNotEmpty) {
      isLoadingBot = true;
      chatBotList.insert(
        0,
        ChatBotModel(
          id: 1,
          isSeen: false,
          message: question,
          create_at: DateTime.now(),
        ),
      );
      chatBotList.insert(
        0,
        ChatBotModel(
          id: 0,
          isSeen: false,
          message: "",
          create_at: DateTime.now(),
        ),
      );
      notifyListeners();
      final json = await NetworkHelper.sendRequest(
        requestType: RequestType.post,
        endpoint: "chat",
        fields: {"message": question},
      );
      changeDomain2();
      //17
      isLoadingBot = false;
      if (!json.containsKey("errorMessage")) {
        chatBotList[0].isSeen = true;
        chatBotList[0].message = json['data'];
      } else {
        chatBotList.removeAt(0);
      }
      notifyListeners();
    }
  }

  checkMaintenanceMode() async {
    final databaseRef = FirebaseDatabase.instance.ref();
    final snapshot = await databaseRef.child("maintenance").get();

    if (snapshot.exists) {
      final data = snapshot.value as Map;

      bool isUnderMaintenance = data['isUnderMaintenance'] ?? false;
      printGreen(isUnderMaintenance.toString());
      if (isUnderMaintenance) {
        toRemoveAll(
          NavigationService.navigatorKey.currentContext!,
          const MaintenanceScreen(),
        );
      }
    }
  }

  bool isShowConfetti = false;

  changeConfetti(bool value) {
    isShowConfetti = value;
    notifyListeners();
  }

  Future<void> runSyncTasksInOrder(List<Function()> tasks) async {
    for (final task in tasks) {
      task();
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();

    super.dispose();
  }
}
