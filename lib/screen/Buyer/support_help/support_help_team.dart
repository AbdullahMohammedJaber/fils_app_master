// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';

import 'package:fils/screen/Buyer/support_help/bottom_support.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/strings_app.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/dialog_auth.dart';
import 'package:fils/widget/item_back.dart';
import 'package:provider/provider.dart';

class SupportAndHelpTeam extends StatefulWidget {
  const SupportAndHelpTeam({super.key});

  @override
  State<SupportAndHelpTeam> createState() => _SupportAndHelpTeamState();
}

class _SupportAndHelpTeamState extends State<SupportAndHelpTeam> {
  TextEditingController message = TextEditingController();

  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    changeDomain1();
    super.initState();
  }

  @override
  void dispose() {
    changeDomain2();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).show();
    });
    return Consumer<AppNotifire>(
      builder: (context, app, child) {
        return Scaffold(
          appBar: AppBar(automaticallyImplyLeading: false , toolbarHeight: 0),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _key,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: heigth * 0.06),
                    itemBackAndTitle(
                      context,
                      title: "Support and help Team".tr(),
                      showBackIcon: true,
                    ),
                    SizedBox(height: heigth * 0.06),
                    DefaultText(
                      "What Problems Are You Facing ?".tr(),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    SizedBox(height: heigth * 0.02),
                    //Translate
                    SizedBox(
                      width: width * 0.8,
                      child: DefaultText(
                        "Welcome To The Help Center. Please Leave Your Message And We Will Get Back To You Within The Next Few Hourse And Responed To You Via Email Or Notifications In The Application."
                            .tr(),
                        type: FontType.regular,
                        overflow: TextOverflow.visible,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: heigth * 0.06),
                    DefaultText(
                      "Your Message".tr(),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    SizedBox(height: heigth * 0.02),
                    TextFormField(
                      maxLines: 7,
                      controller: message,
                      validator: (value) {
                        if (message.text.isEmpty) {
                          return requiredField;
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: textColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: error),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: textColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: textColor),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: textColor),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: textColor),
                        ),
                      ),
                    ),
                    SizedBox(height: heigth * 0.1),
                    ButtonWidget(
                      colorButton: secondColor,
                      title: "Send".tr(),
                      onTap: () async {
                        if (!_key.currentState!.validate()) {
                        } else {
                          if (!isLogin()) {
                            showDialogAuth(context);
                          } else {
                            showBoatToast();

                            var json = await NetworkHelper.sendRequest(
                              requestType: RequestType.post,
                              endpoint: "support-ticket",
                              fields: {"message": message.text},
                            );
                            closeAllLoading();

                            if (json.containsKey("errorMessage")) {
                            } else {
                              showModalBottomSheet(
                                context: context,
                                elevation: 1,
                                isScrollControlled: true,
                                constraints: BoxConstraints(
                                  maxHeight: heigth * 0.6,
                                ),
                                isDismissible: true,
                                backgroundColor: white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                builder: (context) {
                                  return const SupportMessage();
                                },
                              );
                            }
                          }
                        }
                      },
                      fontType: FontType.bold,
                    ),
                    SizedBox(height: heigth * 0.2),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
