// ignore_for_file: camel_case_types, deprecated_member_use

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

class bottomWidgetCheckOutReceveStore extends StatelessWidget {
  const bottomWidgetCheckOutReceveStore({
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
                        color: blackColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: heigth * 0.02),
            Image.asset("assets/images/checkout_done.png"),
            SizedBox(height: heigth * 0.03),
            Row(
              children: [
                SizedBox(
                  width: width * 0.7,
                  child: DefaultText(
                    "The product has been reserved.".tr(),
                    color: blackColor,
                    fontSize: 14,
                    overflow: TextOverflow.visible,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: heigth * 0.01),
            Row(
              children: [
                SizedBox(
                  width: width * 0.7,
                  child: DefaultText(
                    "You can go to the store to receive the product and pay for it in the store."
                        .tr(),
                    color: textColor,
                    fontSize: 12,
                    overflow: TextOverflow.visible,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: heigth * 0.03),
            Row(
              children: [
                SvgPicture.asset("assets/icons/location.svg"),
                SizedBox(width: width * 0.01),
                Expanded(
                  child: DefaultText(
                    "Kuwait, Farwaniya Governorate, Enjaz Market, Hall No. 1",
                    color: primaryColor,
                    fontSize: 12,
                    overflow: TextOverflow.visible,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: heigth * 0.03),
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
            SizedBox(height: heigth * 0.01),
          ],
        ),
      ),
    );
  }
}
