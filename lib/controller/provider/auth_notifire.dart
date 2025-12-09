// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:fils/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:fils/model/response/user_response.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/storage/storage.dart';
import '../../screen/Buyer/edit_account/item_bottom_sheet.dart';

class AuthNotifire extends ChangeNotifier {
  final keyForEdit = GlobalKey<FormState>();
  final mobileControllerForEdit = TextEditingController();
  final passwordControllerForEdit = TextEditingController();
  final nameControllerForEdit = TextEditingController();
  final emailControllerForEdit = TextEditingController();

  editPersonAccount(BuildContext context, String zipCode) async {
    changeDomain1();
    showBoatToast();
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "profile/update",
      fields: {
        "name": nameControllerForEdit.text,
        "email": emailControllerForEdit.text,
        "phone": "$zipCode${mobileControllerForEdit.text}",
      },
    );
    closeAllLoading();
    changeDomain2();
    if (json.containsKey("errorMessage")) {
      showCustomFlash(
        message: json['errorMessage'],
        messageType: MessageType.Faild,
      );
    } else {
      UserResponse userResponse = UserResponse.fromJson(json);
      setUserStorage(userResponse);
      showModalBottomSheet(
        context: context,
        elevation: 2,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        builder: (context) => const buttomWidgetEditAccount(),
      );
    }
  }

  ///[ResetPassword]

  @override
  void dispose() {
    nameControllerForEdit.dispose();
    emailControllerForEdit.dispose();
    passwordControllerForEdit.dispose();
    mobileControllerForEdit.dispose();
    super.dispose();
  }
}
