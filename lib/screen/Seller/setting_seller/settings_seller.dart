import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/screen/Seller/store/edit_store/screen/edit_store_information.dart';
import 'package:provider/provider.dart';

import '../../../utils/const.dart';
import '../../../utils/route/route.dart';
import '../../../utils/storage/storage.dart';
import '../../../utils/theme/color_manager.dart';
import '../../../widget/dialog_auth.dart';
import '../../../widget/item_back.dart';
import '../../Buyer/about_us/about_us_screen.dart';
import '../../Buyer/edit_account/edit_personal_information.dart';

import '../../language/language_screen.dart';
import '../../setting/item_setting.dart';

class SettingsSeller extends StatelessWidget {
  const SettingsSeller({super.key});

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
                    showBackIcon: true,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: width * 0.02),
                    child: Divider(thickness: 0.2, color: textColor),
                  ),
                  itemSetting(
                    title: "Edit Personal information".tr(),
                    onClick: () {
                      if (!isLogin()) {
                        showDialogAuth(context);
                      } else {
                        ToWithFade(
                          context,
                          const EditPersonalInformationScreen(),
                        );
                      }
                    },
                    pathIcon: "assets/icons/edit_account.svg",
                    showBackIcon: true,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: width * 0.02),
                    child: Divider(thickness: 0.2, color: textColor),
                  ),
                  itemSetting(
                    title: "Edit Store Information".tr(),
                    showBackIcon: true,
                    onClick: () {
                      if (isLogin()) {
                        if (getShopInfo().data != null) {
                          ToWithFade(context, EditStoreInformation());
                        } else {
                          showCustomFlash(
                            message: "Please Select your Shop".tr(),
                            messageType: MessageType.Faild,
                          );
                        }
                      } else {
                        showDialogAuth(context);
                      }
                    },
                    pathIcon: "assets/icons/store.svg",
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: width * 0.02),
                    child: Divider(thickness: 0.2, color: textColor),
                  ),
                  itemSetting(
                    title: "About Us".tr(),
                    showBackIcon: true,
                    pathIcon: "assets/icons/about_us.svg",
                    onClick: () {
                      ToWithFade(context, const AboutUsScreen());
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
