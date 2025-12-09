import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:flutter/material.dart';

import '../../utils/enum/message_type.dart';
import '../../utils/message_app/show_flash_message.dart';
import '../../utils/storage/storage.dart';
import '../Seller/store/edit_store/screen/edit_store_information.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  @override
  void initState() {
 /*   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showCustomFlash(message: "You must complete your store profile.".tr(),
          messageType: MessageType.Faild);
    },);*/
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width * 0.7,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      DefaultText(
                        "Are you an online store owner?".tr(),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: getTheme() ? white : Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: heigth * 0.01),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 8),
                child: Wrap(
                  children: [
                    DefaultText(
                      "You must complete your store data in order to publish your products."
                          .tr(),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.visible,
                      color: getTheme() ? white : textColor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: heigth * 0.01),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 8,
                  end: 10,
                  top: 10,
                ),
                child: ButtonWidget(
                  onTap: () {
                    ToWithFade(context, EditStoreInformation());
                  },
                  heightButton: 40,
                  radius: 12,
                  title: "Complete data".tr(),
                  colorButton: purpleColor,
                ),
              ),
            ],
          ),
        ),
        Image.asset("assets/images/complete_profile.png"),
      ],
    );
  }
}
