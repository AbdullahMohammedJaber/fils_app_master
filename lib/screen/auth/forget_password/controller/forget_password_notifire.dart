// ignore_for_file: unused_local_variable

import 'package:fils/screen/auth/login/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../utils/NavigatorObserver/Navigator_observe.dart';
import '../../../../utils/enum/request_type.dart';
import '../../../../utils/global_function/loading_widget.dart';
import '../../../../utils/http/http_helper.dart';
import '../../../../utils/http/service.dart';
import '../../../../utils/route/route.dart';
import '../../../../utils/theme/color_manager.dart';
import '../../item_buttomsheet.dart';
import '../screen/virefy_reset_password.dart';

class ForgetPasswordNotifire extends ChangeNotifier {
  TextEditingController mobileForgetPassword = TextEditingController();
  TextEditingController emailForgetPassword = TextEditingController();
  bool visiblePasswordForReset = true;
  final keyForChangePassword = GlobalKey<FormState>();
  final newPasswordControllerForChangePassword = TextEditingController();

  changeVisabiltyPasswordForReset() {
    visiblePasswordForReset = !visiblePasswordForReset;
    notifyListeners();
  }

  changePassword(BuildContext context, String code) async {
    showBoatToast();
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "auth/password/confirm_reset",
      fields: {
        "verification_code": code,
        "password": newPasswordControllerForChangePassword.text,
      },
    );
    closeAllLoading();
    if (!json.containsKey("errorMessage")) {
      toRemoveAll(context, const LoginScreen());
    }
  }

  forgetPasswordRequest(String zipCode) async {
    showBoatToast();
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: forget_request,
      fields: {
        "email_or_phone":
            emailForgetPassword.text.isNotEmpty
                ? emailForgetPassword.text
                : zipCode+mobileForgetPassword.text,
        "send_code_by": emailForgetPassword.text.isNotEmpty ? "email" : "phone",
      },
    );
    closeAllLoading();

    if (json.containsKey("errorMessage")) {
    } else {
      String email = emailForgetPassword.text;
      String phone = mobileForgetPassword.text;

      TowithTrans(
        NavigationService.navigatorKey.currentContext!,
        PinInputCodeScreen(email: email.isNotEmpty ? email : phone),
        PageTransitionType.rightToLeft,
      );
    }
  }

  resendCodeForgetPasswordRequest() async {
    showBoatToast();
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: resend_code_password,
      fields: {
        "email_or_phone":
            emailForgetPassword.text.isNotEmpty
                ? emailForgetPassword.text
                : mobileForgetPassword.text,
        "send_code_by": emailForgetPassword.text.isNotEmpty ? "email" : "phone",
      },
    );

    closeAllLoading();
  }

  verifyCodeForgetPasswordRequest(String code) async {
    showBoatToast();
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: verify_reset_code,
      fields: {"verification_code": code},
    );
    closeAllLoading();
    if (json.containsKey("errorMessage")) {
    } else {
      showModalBottomSheet(
        context: NavigationService.navigatorKey.currentContext!,
        elevation: 1,
        isDismissible: true,
        backgroundColor: white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        builder: (context) {
          return buttomWidget(code: code);
        },
      );
    }
  }
}
