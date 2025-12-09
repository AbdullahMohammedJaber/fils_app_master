// ignore_for_file: camel_case_types

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/screen/general/root_app.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

class buttomWidgetEditAccount extends StatelessWidget {
  const buttomWidgetEditAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    color: Colors.transparent,
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/icons/x.svg",
                        // ignore: deprecated_member_use
                        color: blackColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: heigth * 0.02),
            Image.asset(
              "assets/images/donee.png",
            ),
            SizedBox(height: heigth * 0.05),
            SizedBox(
              width: width * 0.7,
              child: DefaultText(
                "Data changed successfully".tr(),
                color: const Color(0xff5A5555),
                fontSize: 16,
                overflow: TextOverflow.visible,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: heigth * 0.05),
            ButtonWidget(
              title: "Back To Home Page".tr(),
              colorButton: secondColor,
              sizeTitle: 17,
              fontType: FontType.bold,
              onTap: () {
                Navigator.pop(context);
                context.read<AppNotifire>().onClickBottomNavigationBar(0);
                toRemoveAll(context, const RootAppScreen());
              },
            ),
            SizedBox(height: heigth * 0.03),
          ],
        ),
      ),
    );
  }
}
