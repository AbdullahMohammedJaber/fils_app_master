// ignore_for_file: avoid_print, unused_local_variable

import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/model/response/user_response.dart';
import 'package:fils/screen/splash_screen/splash_screen.dart';
import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/http/service.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:provider/provider.dart';

import '../../screen/general/edit_crob_filter_image.dart';
import '../../utils/const.dart';
import '../../utils/enum/request_type.dart';
import '../../utils/global_function/unit8list.dart';
import '../../utils/http/http_helper.dart';

extension UserExt on BuildContext {
  UserResponse? get userL => watch<UserNotifier>().user;

  UserResponse? get userR => read<UserNotifier>().user;

  bool? get isLogin => read<UserNotifier>().isLoginC;

  get userUpdate => read<UserNotifier>();

  set setUser(UserResponse user) {
    read<UserNotifier>().setUser(user);
  }

  get removeUser => read<UserNotifier>().removeUserR();
}

class UserNotifier extends ChangeNotifier {
  UserResponse? user;
  bool isLoginC = false;

  setUser(UserResponse user) {
    isLoginC = true;
    this.user = user;
    notifyListeners();
  }

  removeUserR() {
    isLoginC = false;
    user = null;
    print("Done remode Notefire");

    notifyListeners();
  }

  UserNotifier() {
    _startRealtimeUpdate();
    user = getUser();
    isLoginC = isLogin();
  }

  String _greeting = 'Hello 👋';
  Timer? _timer;

  String get greeting => _greeting;

  void _startRealtimeUpdate() {
    _updateGreeting();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _updateGreeting();
    });
  }

  void _updateGreeting() {
    final now = DateTime.now().toLocal();
    final hour = now.hour;
    print(now);
    if (hour >= 5 && hour < 12) {
      _greeting = 'Good Morning 👋'.tr();
    } else if (hour >= 12 && hour < 18) {
      _greeting = 'Good Afternoon 🌞'.tr();
    } else if (hour >= 18 && hour < 21) {
      _greeting = 'Good Evening 🌅'.tr();
    } else {
      _greeting = 'Good Night 🌙'.tr();
    }

    notifyListeners();
  }

  logoutUser() async {
    showBoatToast();

    changeDomain1();
    final json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: logout,
    );
    closeAllLoading();
    removeUserR();
    removeUser();
    GetStorage().remove("shops");
    GetStorage().remove("PackageInfoResponse");
    GetStorage().remove("checkShop");
    Provider.of<AppNotifire>(
      NavigationService.navigatorKey.currentContext!,
      listen: false,
    ).onClickBottomNavigationBar(0);
    toRemoveAll(NavigationService.navigatorKey.currentContext!, SplashScreen());
  }

  deleteUser() async {
    showBoatToast();

    changeDomain1();
    final json = await NetworkHelper.sendRequest(
      requestType: RequestType.delete,
      endpoint: "delete-my-account",
    );
    closeAllLoading();
    if (!json.containsKey("errorMessage")) {
      removeUserR();
      removeUser();
      GetStorage().remove("shops");
      GetStorage().remove("user");
      GetStorage().remove("PackageInfoResponse");
      GetStorage().remove("checkShop");
      Provider.of<AppNotifire>(
        NavigationService.navigatorKey.currentContext!,
        listen: false,
      ).onClickBottomNavigationBar(0);
      toRemoveAll(
        NavigationService.navigatorKey.currentContext!,
        SplashScreen(),
      );
    } else {
      showCustomFlash(
        message: json['errorMessage'],
        messageType: MessageType.Faild,
      );
    }
  }

  File? imageFile;
  String? idImageLogo;

  void selectAndUploadImage() async {
    imageFile = await uploadImage();

    if (imageFile != null) {
      notifyListeners();
      final edited = await Navigator.push(
        NavigationService.navigatorKey.currentContext!,
        MaterialPageRoute(
          builder:
              (_) =>
                  FullImageEditorScreen(imageFile: imageFile!, isProfile: true),
        ),
      );
      imageFile = await uint8ListToFile(edited, "${DateTime.now()}.png");
      if (edited != null) {
        uploadImageServer(imageFile!);
      }
    } else {}
    notifyListeners();
  }

  uploadImageServer(File file) async {
    Future.delayed(const Duration(seconds: 1), () async {
      showBoatToast();
      final json = await NetworkHelper.sendRequest(
        requestType: RequestType.post,
        endpoint: "file/upload",
        files: {"aiz_file": file},
      );
      print(json.toString());

      closeAllLoading();
      if (json.containsKey("errorMessage")) {
      } else {
        idImageLogo = json['data']['id'].toString();
        changeDomain1();
        var json2 = await NetworkHelper.sendRequest(
          requestType: RequestType.post,
          endpoint: "profile/update",
          fields: {
            "name": getUser()!.user!.name,
            "email": getUser()!.user!.email,
            "phone": getUser()!.user!.phone,
            "avatar_original": idImageLogo,
          },
        );
        changeDomain2();
        print(json2.toString());
        UserResponse userResponse = UserResponse.fromJson(json2);
        setUserStorage(userResponse);
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
