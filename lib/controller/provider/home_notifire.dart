// ignore_for_file: unused_local_variable
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/store_notofire.dart';
import 'package:fils/model/response/ads_list.dart';
import 'package:fils/model/response/cart_list_response.dart'
    show CartListResponse;
import 'package:fils/screen/Buyer/edit_account/edit_personal_information.dart';
import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/global_function/printer.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/response/balance_response.dart';
import '../../model/response/seller/package_info_response.dart';
import '../../screen/Seller/store/edit_store/screen/edit_store_information.dart';
import '../../screen/banners/integrated_user.dart';
import '../../screen/banners/save_finanicial.dart';
import '../../screen/banners/store_auction_service.dart';
import '../../utils/const.dart';
import '../../utils/enum/request_type.dart';
import '../../utils/http/http_helper.dart';

class HomeNotifire extends ChangeNotifier {
  bool visible = false;
  final databaseRef = FirebaseDatabase.instance.ref();

  Future<void> runSyncTasksInOrder(List<Function()> tasks) async {
    for (final task in tasks) {
      task();
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  HomeNotifire() {
    runSyncTasksInOrder([runAnimation, checkForUpdate, initBannersList]);
  }

  runAnimation() {
    Future.delayed(const Duration(milliseconds: 100), () {
      visible = true;
      notifyListeners();
    });
  }

  Future<void> checkForUpdate() async {
    if (Platform.isAndroid) {
      final snapshot = await databaseRef.child("update").get();

      if (snapshot.exists) {
        final data = snapshot.value as Map;

        bool hasUpdate = data['hasUpdate'] ?? false;
        String currentVersion = data['currentVersion'] ?? '';
        bool isShowAndroid = data['isShowAndroid'];
        printBlue("Has Update: $hasUpdate");
        printBlue("Current Version: $currentVersion");
        printBlue("info Version: $info");
        if (currentVersion != info &&
            hasUpdate == false &&
            isShowAndroid == true) {
          showCupertinoDialog(
            context: NavigationService.navigatorKey.currentContext!,

            builder: (context) {
              return CupertinoAlertDialog(
                title: DefaultText(
                  "Update the app".tr(),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  textAlign: TextAlign.center,
                ),
                content: DefaultText(
                  "There is an update to the application. Download it to benefit from the new features."
                      .tr(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                ),
                actions: [
                  CupertinoButton(
                    child: Center(
                      child: DefaultText(
                        "Update".tr(),
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      launchAppStore();
                    },
                  ),
                ],
              );
            },
          );
        } else if (currentVersion != info &&
            hasUpdate &&
            isShowAndroid == true) {
          launchAppStore();
        }
      }
    }
    if (Platform.isIOS) {
      final snapshot = await databaseRef.child("update").get();

      if (snapshot.exists) {
        final data = snapshot.value as Map;

        bool hasUpdateIos = data['hasUpdate'] ?? false;
        String currentVersionIos = data['currentVersionIos'] ?? '';
        bool isShowIos = data['isShowiOs'];
        printBlue("Has Update: $hasUpdateIos");
        printBlue("Current Version: $currentVersionIos");
        printBlue("info Version: $info");
        if (currentVersionIos != info &&
            hasUpdateIos == false &&
            isShowIos == true) {
          showCupertinoDialog(
            context: NavigationService.navigatorKey.currentContext!,

            builder: (context) {
              return CupertinoAlertDialog(
                title: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                    const Spacer(),
                    DefaultText(
                      "Update the app".tr(),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                  ],
                ),

                content: DefaultText(
                  "There is an update to the application. Download it to benefit from the new features."
                      .tr(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                ),
                actions: [
                  CupertinoButton(
                    child: Center(
                      child: DefaultText(
                        "Update".tr(),
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      launchAppStore();
                    },
                  ),
                ],
              );
            },
          );
        } else if (currentVersionIos != info &&
            hasUpdateIos &&
            isShowIos == true) {
          launchAppStore();
        }
      }
    }
  }

  Future<void> launchAppStore() async {
    const androidUrl =
        'https://play.google.com/store/apps/details?id=com.app.fils';
    const iosUrl = 'https://apps.apple.com/us/app/fils/id6745802326';

    final url = Platform.isAndroid ? androidUrl : iosUrl;

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      exit(0);
    } else {
      throw 'Could not launch store URL';
    }
  }

  getBalance() async {
    if (isLogin()) {
      if (getUser()!.user!.type != "seller") {
        var json = await NetworkHelper.sendRequest(
          requestType: RequestType.get,
          endpoint: "wallet/balance",
        );
        if (json.containsKey("errorMessage")) {
        } else {
          BalanceResponse balanceResponse = BalanceResponse.fromJson(json);
          setBalance(double.parse(balanceResponse.data!.balance!));
        }
      } else {
        changeDomain2();
      }
    }
  }

  List<AdsSubscription> bannersAdsList = [];

  Future<void> getBannersApp() async {
    if (isLogin()) {
      changeDomain2(isCustomerToSeller: true);
      bannersAdsList = [];
      final json = await NetworkHelper.sendRequest(
        requestType: RequestType.get,
        endpoint: "ads-area/active-ads",
      );
      changeDomain1();
      printGreenLong("Json ads-area/active-ads$json");
      AdsListResponse adsListResponse = AdsListResponse.fromJson(json);
      for (var element in adsListResponse.data!.adsSubscriptions!) {
        bannersAdsList.add(element);
      }
      condationAds();
    }
  }

  List<AdsSubscription> popAds = [];
  List<AdsSubscription> banAds = [];
  PageController pageController = PageController(initialPage: 0);

  List<Widget> bannersList = [];

  initBannersList() {
    bannersList = [];
    bannersList.add(const StoreAuctionService());
    bannersList.add(const IntegratedUser());
    bannersList.add(const SaveFinancial());
  }

  void insertWidgetListBanners(Widget value) {
    if (!isAdd) {
      initBannersList();
      bannersList.add(value);
    }

    changeAdd();
  }

  bool isAdd = false;

  changeAdd() {
    isAdd = true;
  }

  bool isAddSeller = false;

  changeAddSeller() {
    isAddSeller = true;
  }

  void insertWidgetListBannersSeller(Widget value) {
    if (!isAddSeller) {
      initBannersList();
      bannersList.insert(0, value);
    }

    changeAddSeller();
  }

  dynamic currentPage = 0;

  void updateCurrentPage(dynamic index) {
    currentPage = index;
    notifyListeners();
  }

  condationAds() {
    popAds = [];
    banAds = [];
    if (bannersAdsList.isNotEmpty) {
      for (var element in bannersAdsList) {
        if (element.adsArea!.place == "popup") {
          popAds.add(element);
        } else if (element.adsArea!.place == "home_screen") {
          banAds.add(element);
        }
      }
    }

    if (popAds.isNotEmpty) {
      final pageController = PageController();

      popupAdsWidget(pageController);
    }
    if (banAds.isNotEmpty) {
      for (var element in banAds) {
        printGreen("app ${banAds.length}");
        bannersList.add(
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(element.coverImage!, fit: BoxFit.cover),
          ),
        );
      }
    }
    notifyListeners();
  }

  Future<dynamic> popupAdsWidget(PageController pageController) {
    return showCupertinoModalPopup(
      context: NavigationService.navigatorKey.currentState!.context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CupertinoActionSheet(
              title: DefaultText(
                "Ads".tr(),
                fontSize: 20,
                textAlign: TextAlign.center,
                color: Colors.black,
              ),
              message: SizedBox(
                height: heigth * 0.7,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: pageController,
                      itemCount: popAds.length,
                      onPageChanged: (index) {},
                      itemBuilder: (context, index) {
                        final ad = popAds[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image:
                                ad.product!.thumbnailImg != null
                                    ? DecorationImage(
                                      image: NetworkImage(
                                        ad.product!.thumbnailImg!,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                    : null,
                            color: CupertinoColors.systemGrey5,
                          ),
                          child: Center(child: DefaultText(ad.product!.name!)),
                        );
                      },
                    ),
                  ],
                ),
              ),
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(context),
                child: DefaultText('Close'.tr()),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> updateFcmToken() async {
    if (isLogin() && getFcmToken() != null) {
      changeDomain1();
      final json = await NetworkHelper.sendRequest(
        requestType: RequestType.post,
        endpoint: "profile/update-device-token",
        fields: {"device_token": getFcmToken(), "user_timezone": getTimeZoon()},
      );
      changeDomain2();
    }
  }

  getRequestByuer() async {
    await getBalance();

    Future.delayed(const Duration(seconds: 3), () {
      updateFcmToken().then((value) {
        getBannersApp();
      });
    });

    if (isLogin()) {
      if (getUser()!.user!.phone!.isEmpty) {
        showCustomFlash(
          message: "Please fill Phone number".tr(),
          messageType: MessageType.Faild,
        );
        To(
          NavigationService.navigatorKey.currentContext!,
          EditPersonalInformationScreen(),
        );
      }
    }
  }

  getRequestSeller(BuildContext context) async {
    Future.delayed(const Duration(seconds: 3), () => updateFcmToken());
    final storeNotifier = Provider.of<StoreNotifire>(context, listen: false);

    if (getAllShop().id != null) {
      await storeNotifier.functionGetDataStore(isGetComplete: false);
      var json = await NetworkHelper.sendRequest(
        requestType: RequestType.get,
        endpoint: "get-current-package/${getUser()!.user!.id}",
      );
      PackageInfoResponse packageInfoResponse = PackageInfoResponse.fromJson(
        json,
      );

      setPackageInfo(packageInfoResponse);
      if (kDebugMode) {
        print("${getUser()!.user!.phone}  ${getShopInfo().data!.description}");
      }
      if (getUser()!.user!.phone!.isEmpty) {
        showCustomFlash(
          message: "Please fill Phone number".tr(),
          messageType: MessageType.Faild,
        );
        To(
          NavigationService.navigatorKey.currentContext!,
          EditPersonalInformationScreen(),
        );
      } else if (getShopInfo().data!.description == "null" ||
          getShopInfo().data!.description == null ||
          getShopInfo().data!.description.toString().isEmpty) {
        ToWithFade(
          NavigationService.navigatorKey.currentContext!,
          EditStoreInformation(),
        );
      }
    }
  }

  @override
  void dispose() {
    visible = false;
    pageController.dispose();
    super.dispose();
  }
}
