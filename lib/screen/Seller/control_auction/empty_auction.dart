import 'package:easy_localization/easy_localization.dart';
import 'package:fils/screen/Seller/user_guide/user_guide.dart';
import 'package:fils/utils/global_function/validation.dart';
import 'package:fils/utils/route/route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/utils/theme/font_manager.dart';

import '../../../utils/theme/constants_manager.dart';

Widget emptyMyAuction(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Spacer(),
      SvgPicture.asset("assets/icons/product_empty.svg"),
      SizedBox(height: heigth * 0.05),
      RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textColor,
            fontFamily: FontConstants.fontFamily,
          ),
          children: [
            TextSpan(
              text: "There Are No Auction Yet, ".tr(),
              style: TextStyle(
                fontFamily:
                    ConstantGlobalVar.locale == ConstantGlobalVar.en
                        ? FontConstants.fontFamily
                        : FontConstants.fontFamilyAr,
              ),
            ),
            TextSpan(
              text: "Add Auction".tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: purpleColor,
                decoration: TextDecoration.underline,
                fontFamily:
                    ConstantGlobalVar.locale == ConstantGlobalVar.en
                        ? FontConstants.fontFamily
                        : FontConstants.fontFamilyAr,
              ),
              recognizer: TapGestureRecognizer()..onTap = () {
                checkStatusStore(false, context);
              },
            ),
          ],
        ),
      ),
      const SizedBox(height: 4),
      RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textColor,
            fontFamily:
                ConstantGlobalVar.locale == ConstantGlobalVar.en
                    ? FontConstants.fontFamily
                    : FontConstants.fontFamilyAr,
          ),
          children: [
            TextSpan(text: "Need Help? ".tr()),
            TextSpan(
              text: "Read The Guide".tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: purpleColor,
                decoration: TextDecoration.underline,
                fontFamily:
                    ConstantGlobalVar.locale == ConstantGlobalVar.en
                        ? FontConstants.fontFamily
                        : FontConstants.fontFamilyAr,
              ),
              recognizer:
                  TapGestureRecognizer()
                    ..onTap = () {
                      ToWithFade(context, UserGuideScreen());
                    },
            ),
          ],
        ),
      ),
      const Spacer(),
    ],
  );
}

Widget emptyMyProduct(BuildContext context) {
  return Column(
    children: [
      const Spacer(),
      SvgPicture.asset("assets/icons/product_empty.svg"),
      SizedBox(height: heigth * 0.05),
      RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textColor,
            fontFamily: FontConstants.fontFamily,
          ),
          children: [
            TextSpan(
              text: "There Are No Products Yet, ".tr(),
              style: TextStyle(
                fontFamily:
                    ConstantGlobalVar.locale == ConstantGlobalVar.en
                        ? FontConstants.fontFamily
                        : FontConstants.fontFamilyAr,
              ),
            ),
            TextSpan(
              text: "Add Product".tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: purpleColor,

                decoration: TextDecoration.underline,
                fontFamily:
                    ConstantGlobalVar.locale == ConstantGlobalVar.en
                        ? FontConstants.fontFamily
                        : FontConstants.fontFamilyAr,
              ),
              recognizer:
                  TapGestureRecognizer()
                    ..onTap = () {
                      checkStatusStore(true, context);
                    },
            ),
          ],
        ),
      ),
      const SizedBox(height: 4),
      RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textColor,
            fontFamily: FontConstants.fontFamily,
          ),
          children: [
            TextSpan(
              text: "Need Help? ".tr(),
              style: TextStyle(
                fontFamily:
                    ConstantGlobalVar.locale == ConstantGlobalVar.en
                        ? FontConstants.fontFamily
                        : FontConstants.fontFamilyAr,
              ),
            ),
            TextSpan(
              text: "Read The Guide".tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: purpleColor,
                decoration: TextDecoration.underline,
                fontFamily:
                    ConstantGlobalVar.locale == ConstantGlobalVar.en
                        ? FontConstants.fontFamily
                        : FontConstants.fontFamilyAr,
              ),
              recognizer: TapGestureRecognizer()..onTap = () {
                ToWithFade(context, UserGuideScreen());
              },
            ),
          ],
        ),
      ),
      const Spacer(),
    ],
  );
}
