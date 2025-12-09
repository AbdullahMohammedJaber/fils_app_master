// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/main.dart';
import 'package:fils/model/app/banners_model.dart';
import 'package:fils/screen/splash_screen/splash_screen.dart';
import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import 'package:fils/utils/global_function/printer.dart';
import 'package:fils/utils/http/service.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../model/response/base_response.dart';
import '../model/response/switch_account_response.dart';
import '../model/response/user_response.dart';
import '../screen/Seller/store/create_store/screen/add_store.dart';
import '../screen/general/root_app.dart';
import '../widget/defulat_text.dart';
import 'enum/message_type.dart';
import 'enum/request_type.dart';
import 'global_function/loading_widget.dart';
import 'http/http_helper.dart';
import 'message_app/show_flash_message.dart';

double width = 0.0;
double heigth = 0.0;
String info = "";

SystemUiOverlayStyle getSystemUiOverlayStyleDark() {
  return const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
}

SystemUiOverlayStyle getSystemUiOverlayStyle() {
  return const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.light,
  );
}

bool isTest = false;

changeDomain2({bool isCustomerToSeller = false}) {
  if (isLogin()) {
    if (getUser()!.user!.type == "customer" && isCustomerToSeller == false) {
      changeDomain1();
    } else {
      if (isTest) {
        domain = 'https://stage.fils.app/api/v2/seller';
      } else {
        domain = 'https://dashboard.fils.app/api/v2/seller';
      }
    }
  } else {
    changeDomain1();
  }
}

changeDomain1() {
  if (isTest) {
    domain = 'https://stage.fils.app/api/v1';
  } else {
    domain = 'https://dashboard.fils.app/api/v1';
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<File?> uploadImage() async {
  final picker = ImagePicker();

  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    return File(pickedFile.path);
  } else {
    return null;
  }
}

Future<File?> uploadFile() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }
  }
  return null;
}

Widget shimmerBox({required double height, required double width}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}

Widget shimmerTitle({required double width}) {
  return shimmerBox(height: 16, width: width);
}

Widget shimmerCircle({required double size}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    ),
  );
}

loginFaceBook(BuildContext context, {required String userType}) async {
  OAuthCredential? user = await NetworkHelper.signInWithFacebook();
  showBoatToast();
  var json = await NetworkHelper.sendRequest(
    requestType: RequestType.post,
    endpoint: "auth/social-login",
    fields: {
      "provider": user!.providerId,
      "social_provider": "facebook",
      "access_token": user.accessToken,
      "access_secret": user.secret,
      "user_type": userType,
    },
  );
  closeAllLoading();
  if (json.containsKey('errorMessage')) {
    showCustomFlash(
      message: json['errorMessage'],
      messageType: MessageType.Faild,
    );
  } else {
    UserResponse userResponse = UserResponse.fromJson(json);
    setUserStorage(userResponse);
    NavigationService.navigatorKey.currentContext!
        .read<AppNotifire>()
        .onClickBottomNavigationBar(0);
    toRemoveAll(context, const RootAppScreen());
  }
}

Future<void> loginGoogle(BuildContext context, {
  required String userType,
}) async {
  try {
    changeDomain1();
    showBoatToast();

    final user = await NetworkHelper.signInWithGoogle();

    if (user == null) {
      printBlue(user!.providerId.toString());
      printBlue(user.signInMethod);
      printBlue(user.token.toString());
      printBlue(user.accessToken.toString());
      printBlue(user.toString());
      throw Exception("تم إلغاء تسجيل الدخول باستخدام Google أو حدث خطأ");
    }

    // 📡 إرسال البيانات إلى الخادم
    final response = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "auth/social-login",
      fields: {
        "provider": user.providerId,
        "social_provider": "google",
        "access_token": user.accessToken ?? "",
        "access_secret": user.secret,
        "user_type": userType,
      },
    );

    closeAllLoading();

    if (response['errorMessage'] != null) {
      showCustomFlash(
        message: response['errorMessage'],
        messageType: MessageType.Faild,
      );
      return;
    }

    final userResponse = UserResponse.fromJson(response);
    await setUserStorage(userResponse);

    final appNotifier =
    NavigationService.navigatorKey.currentContext!.read<AppNotifire>();
    appNotifier.onClickBottomNavigationBar(0);

    toRemoveAll(context, const RootAppScreen());
  } catch (e, stack) {
    closeAllLoading();

    showCustomFlash(
      message: e.toString().replaceAll("Exception: ", ""),
      messageType: MessageType.Faild,
    );

    debugPrint("🔴 Google Login Error: $e\n$stack");
  }
}

loginApple(BuildContext context, {required String userType}) async {
  changeDomain1();
  showBoatToast();
  AuthorizationCredentialAppleID? user = await NetworkHelper.signInWithApple();
  if (user == null) {
    closeAllLoading();
    showCustomFlash(
      message: "تم إلغاء تسجيل الدخول باستخدام Apple أو حدث خطأ",
      messageType: MessageType.Faild,
    );
    return;
  }

  var json = await NetworkHelper.sendRequest(
    requestType: RequestType.post,
    endpoint: "auth/social-login",
    fields: {
      "provider": "apple.com",
      "social_provider": "apple",
      "access_token": user.userIdentifier,
      "access_secret": null,
      "user_type": userType,
    },
  );
  closeAllLoading();
  if (json.containsKey('errorMessage')) {
    showCustomFlash(
      message: json['errorMessage'],
      messageType: MessageType.Faild,
    );
  } else {
    UserResponse userResponse = UserResponse.fromJson(json);
    setUserStorage(userResponse);
    NavigationService.navigatorKey.currentContext!
        .read<AppNotifire>()
        .onClickBottomNavigationBar(0);
    toRemoveAll(context, const RootAppScreen());
  }
}

resendCodeSignup(BuildContext context, String email) async {
  showBoatToast();
  final json = await NetworkHelper.sendRequest(
    requestType: RequestType.post,
    endpoint: resend_code,
    fields: {"email": email},
  );
  if (json.containsKey("errorMessage")) {
    closeAllLoading();
  } else {
    BaseResponse baseResponse = BaseResponse.fromJson(json);
    showCustomFlash(
      message: baseResponse.message,
      messageType: MessageType.Success,
    );
    closeAllLoading();
  }
}

confirmCodeSignup(BuildContext context,
    String code, {
      String? password,
      String? name,
      String? mobile,
      String? userType,
      String? email,
    }) async {
  showBoatToast();
  final json = await NetworkHelper.sendRequest(
    requestType: RequestType.post,
    endpoint: confirm_code,
    fields: {
      "verification_code": code,
      if (email != null) "email": email,
      if (password != null) "password": password,
      if (password != null) "password_confirmation": password,
      if (mobile != null) "phone": mobile,
      if (name != null) "name": name,
      if (userType != null) "user_type": userType,
    },
  );
  closeAllLoading();

  if (json.containsKey("errorMessage")) {} else {
    UserResponse userResponse = UserResponse.fromJson(json);
    showCustomFlash(
      message: userResponse.message,
      messageType: MessageType.Success,
    );
    setUserStorage(userResponse);
    NavigationService.navigatorKey.currentContext!
        .read<AppNotifire>()
        .onClickBottomNavigationBar(0);
    GetStorage().remove("shops");
    GetStorage().remove("PackageInfoResponse");
    GetStorage().remove("checkShop");
    GetStorage().remove("shopInfo");
    if (userType == "seller") {
      toRemoveAll(
        NavigationService.navigatorKey.currentContext!,
        AddStoreSeller(isComeSignup: true),
      );
    } else {
      toRemoveAll(
        NavigationService.navigatorKey.currentContext!,
        const RootAppScreen(),
      );
    }
  }
}



switchAccount(BuildContext context, String userType) async {
  showBoatToast();
  changeDomain1();
  final json = await NetworkHelper.sendRequest(
    requestType: RequestType.post,
    endpoint: "profile/switch-account",
    fields: {"user_type": userType},
  );
  closeAllLoading();
  GetStorage().remove("shops");
  GetStorage().remove("PackageInfoResponse");
  GetStorage().remove("checkShop");
  GetStorage().remove("shopInfo");

  if (!json.containsKey("errorMessage")) {
    SwitchAccountResponse switchAccountResponse =
    SwitchAccountResponse.fromJson(json);
    printGreenLong(switchAccountResponse.toJson().toString());
    setUserStorage(
      UserResponse(
        accessToken: switchAccountResponse.token!,
        code: 200,
        expiresAt: null,
        message: switchAccountResponse.message!,
        result: switchAccountResponse.result!,
        tokenType: "",
        user: switchAccountResponse.user!,
      ),
    );
    NavigationService.navigatorKey.currentContext!
        .read<AppNotifire>()
        .onClickBottomNavigationBar(0);
    toRemoveAll(NavigationService.navigatorKey.currentContext!, SplashScreen());
  }
}

List<String> bankList = [
  "بنك الأهلي الكويتي - Ahli United Bank Kuwait",
  "بنك الكويت الوطني (NBK) - National Bank of Kuwait",
  "بنك بوبيان - Burgan Bank",
  "بنك الخليج الكويتي - Gulf Bank",
  "بنك الراجحي الكويتي - Al Rajhi Bank Kuwait",
  "بنك بوبلكس - Boubyan Bank",
  "بنك الكويت الدولي - Kuwait International Bank",
  "بنك وربة - Warba Bank",
  "بنك برقان - Al Tijari Bank",
  "بنك بريطانيا - Bank of Bahrain and Kuwait (BBK)",
  "البنك الصناعي الكويتي (Industrial Bank of Kuwait – IBK)",
  "بنك التجاري الكويتي (Commercial Bank of Kuwait)",
  "بي إن بي باريبا (BNP Paribas)",
  "إتش إس بي سي (HSBC)",
  "فيرست أبوظبي (FAB)",
  "سيتي بنك (Citibank)",
  "بنك قطر الوطني (QNB)",
  "بنك الدوحة (Doha Bank)",
  "بنك المشرق (Mashreq Bank)",
  "البنك السعودي الراجحي (Al‑Rajhi Bank)",
  "بنك مسقط (Bank Muscat)",
  "البنك الصناعي والتجاري الصيني (ICBC)",
  "بنك البحرين والكويت (BBK)",
];

Future selectStringDialog(BuildContext context, {
  required List<dynamic> list,
  required String title,
}) {
  return showCupertinoDialog(
    context: context,
    barrierDismissible: true,

    builder: (context) {
      return CupertinoAlertDialog(
        title: DefaultText(title, fontSize: 20, fontWeight: FontWeight.w600),
        insetAnimationDuration: const Duration(seconds: 5),
        content: SizedBox(
          height: heigth * 0.45,
          child: ListView(
            children:
            list.map((e) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context, e);
                  },
                  child: DefaultText(
                    e,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.start,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    },
  );
}

showDialogActiveShop() {
  showCupertinoDialog(
    context: NavigationService.navigatorKey.currentContext!,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(NavigationService.navigatorKey.currentContext!);
              },
              icon: const Icon(Icons.close),
            ),

            DefaultText(
              "Active Store".tr(),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            const Spacer(),
          ],
        ),
        content: Column(
          children: [
            SizedBox(
              width: width * 0.9,
              child: DefaultText(
                "Your store is in review awaiting verification for support."
                    .tr(),
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),
            ),
            GestureDetector(
              onTap: () async {
                String message = Uri.encodeComponent("");
                String phoneNumber = "+96569055541";

                String androidUrl =
                    "whatsapp://send?phone=$phoneNumber&text=$message";
                String iosUrl = "https://wa.me/$phoneNumber?text=$message";

                if (Platform.isIOS) {
                  await launchUrlString(iosUrl);
                } else {
                  await launchUrlString(androidUrl);
                }
              },
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: DefaultText(
                    "Click here".tr(),
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void shareStoreLink(dynamic storeId) {
  final link = "https://dashboard.fils.app/open/store.html?id=$storeId";
  Share.share(
    "قم بزيارة متجري :  $link",
    subject: "مشاركة رابط المتجر الخاص بك",
  );
}

void shareProductLink(dynamic productId) {
  final link = "https://dashboard.fils.app/open/product.html?id=$productId";
  Share.share(
    "قم بزيارة منتجي :  $link",
    subject: "مشاركة رابط المنتج الخاص بك",
  );
}
