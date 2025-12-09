import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../utils/enum/message_type.dart';
import '../../../../utils/enum/request_type.dart';
import '../../../../utils/global_function/loading_widget.dart';
import '../../../../utils/http/http_helper.dart';
import '../../../../utils/http/service.dart';
import '../../../../utils/message_app/show_flash_message.dart';
import '../../../../utils/route/route.dart';
import '../../virefy_code_signup.dart';

class SignupNotifire extends ChangeNotifier {
  final keyForSignup = GlobalKey<FormState>();
  final mobileControllerForSignup = TextEditingController();
  final passwordControllerForSignup = TextEditingController();
  final passwordConfirmControllerForSignup = TextEditingController();

  final nameControllerForSignup = TextEditingController();
  final emailControllerForSignup = TextEditingController();
  bool visiblePasswordForSignup = true;
  bool checkP = false;
  changeCheckP() {
    if (checkP == false) {
      checkP = true;
    } else {
      checkP = false;
    }

    notifyListeners();
  }

  changeVisabiltyPasswordForSignup() {
    visiblePasswordForSignup = !visiblePasswordForSignup;
    notifyListeners();
  }

  String userType = "customer";

  changeUserType(String type) {
    userType = type;
    notifyListeners();
  }

  signUp(BuildContext context, String zipCode) async {
    showBoatToast(title: "");
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: register,
      fields: {
        "email": emailControllerForSignup.text,

        "phone": "$zipCode${mobileControllerForSignup.text}",

        "user_type": userType,
      },
    );
    if (json.containsKey("errorMessage")) {
      closeAllLoading();
    } else {
      closeAllLoading();
      showCustomFlash(
        message: "A verification code has been sent to your Whatsapp".tr(),
        messageType: MessageType.Success,
      );

      ToRemove(
        context,
        VirefyCodeSignup(
          email: emailControllerForSignup.text,
          name: nameControllerForSignup.text,
          password: passwordControllerForSignup.text,
          phone: mobileControllerForSignup.text,
          userType: userType,
        ),
      );
    }
  }

  @override
  void dispose() {
    mobileControllerForSignup.dispose();
    passwordControllerForSignup.dispose();
    passwordConfirmControllerForSignup.dispose();

    nameControllerForSignup.dispose();
    emailControllerForSignup.dispose();

    super.dispose();
  }
}
