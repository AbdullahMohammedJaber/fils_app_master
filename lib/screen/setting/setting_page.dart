import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/screen/Buyer/about_us/about_us_screen.dart';
import 'package:fils/screen/Buyer/edit_account/edit_personal_information.dart';
import 'package:fils/screen/Buyer/order/cancel_order.dart';

import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/item_back.dart';
import 'package:fils/utils/const.dart';
import 'package:provider/provider.dart';

import '../../utils/storage/storage.dart';
import '../../widget/dialog_auth.dart';

import '../language/language_screen.dart';
import 'item_setting.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return Consumer<AppNotifire>(builder: (context, app, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: heigth * 0.06),

                itemBackAndTitle(context, title: "Settings".tr()),
                SizedBox(height: heigth * 0.06),
                itemSetting(
                    title: "Language".tr(),
                    onClick: () {
                      ToWithFade(context, const LanguageScreen());
                    },
                    pathIcon: "assets/icons/language.svg",
                    showBackIcon: true),
                Padding(
                    padding: EdgeInsetsDirectional.only(end: width * 0.02),
                    child: Divider(thickness: 0.2, color: textColor)),
                itemSetting(
                    title: "Edit Personal information".tr(),
                    onClick: () {
                      if (!isLogin()) {
                        showDialogAuth(context);
                      } else {
                        ToWithFade(
                            context, const EditPersonalInformationScreen());
                      }
                    },
                    pathIcon: "assets/icons/edit_account.svg",
                    showBackIcon: true),
                Padding(
                    padding: EdgeInsetsDirectional.only(end: width * 0.02),
                    child: Divider(thickness: 0.2, color: textColor)),
                itemSetting(
                    title: "Submit a cancellation request".tr(),
                    showBackIcon: true,
                    onClick: () {
                      if (isLogin()) {
                        ToWithFade(context, const CancelOrderScreen());
                      } else {
                        showDialogAuth(context);
                      }
                    },
                    pathIcon: "assets/icons/cancel_request.svg"),
                Padding(
                    padding: EdgeInsetsDirectional.only(end: width * 0.02),
                    child: Divider(thickness: 0.2, color: textColor)),
                itemSetting(
                    title: "About Us".tr(),
                    showBackIcon: true,
                    pathIcon: "assets/icons/about_us.svg",
                    onClick: () {
                      ToWithFade(context, const AboutUsScreen());
                    }),
                Padding(
                    padding: EdgeInsetsDirectional.only(end: width * 0.02),
                    child: Divider(thickness: 0.2, color: textColor)),
                itemSetting(
                    title: "Privacy Policy".tr(),
                    showBackIcon: true,
                    pathIcon: "assets/icons/about_us.svg",
                    onClick: () {
                      ToWithFade(context, const PrivacyPolicyScreen());
                    }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
