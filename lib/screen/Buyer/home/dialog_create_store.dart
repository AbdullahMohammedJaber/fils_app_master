import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:flutter/material.dart';

import '../../../utils/enum/message_type.dart';
import '../../../utils/enum/request_type.dart';
import '../../../utils/http/http_helper.dart';
import '../../../utils/http/service.dart';
import '../../../utils/message_app/show_flash_message.dart';
import '../../../utils/route/route.dart';
import '../../../utils/strings_app.dart';
import '../../auth/virefy_code_signup.dart';

void showStoreLoginDialog(BuildContext context) {
  final TextEditingController storeNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Create store".tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: storeNameController,
                decoration: InputDecoration(
                  hintText: "Store Name".tr(),
                  prefixIcon: const Icon(Icons.storefront_outlined),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (value) {
                  if (passwordController.text == null ||
                      passwordController.text.isEmpty) {
                    return requiredField;
                  }
                  if (passwordController.text.length < 8) {
                    return "Password must be at least 8 characters";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Password".tr(),
                  prefixIcon: const Icon(Icons.lock_outline),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel".tr(),
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () async {
                      final storeName = storeNameController.text.trim();
                      final password = passwordController.text.trim();

                      if (storeName.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(requiredField),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      } else if (passwordController.text.length < 8) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Password less 6 characters".tr()),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      } else {
                        Navigator.pop(context);
                        showBoatToast();
                        var json = await NetworkHelper.sendRequest(
                          requestType: RequestType.post,
                          endpoint: register,
                          fields: {
                            "email": getUser()!.user!.email,

                            "phone": getUser()!.user!.phone,

                            "user_type": "seller",
                          },
                        );
                        closeAllLoading();
                        if (json.containsKey("errorMessage")) {
                          closeAllLoading();
                        } else {
                          closeAllLoading();
                          showCustomFlash(
                            message:
                                "A verification code has been sent to your Whatsapp"
                                    .tr(),
                            messageType: MessageType.Success,
                          );

                          toRemoveAll(
                            NavigationService.navigatorKey.currentContext!,
                            VirefyCodeSignup(
                              email: getUser()!.user!.email,
                              name: storeNameController.text,
                              password: passwordController.text,
                              phone: getUser()!.user!.phone,
                              userType: "seller",
                            ),
                          );
                        }
                      }
                    },
                    child: Text(
                      "Done".tr(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
