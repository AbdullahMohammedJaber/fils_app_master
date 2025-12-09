import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fils/screen/Seller/wallet/bank_setting.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/item_back.dart';

class SettingWallet extends StatelessWidget {
  const SettingWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: heigth * 0.06, width: width),
            itemBackAndTitle(context, title: "Wallet Settings".tr()),
            SizedBox(height: heigth * 0.04, width: width),
            DefaultText(
              "Payment methods".tr(),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: blackColor,
            ),
            GestureDetector(
              onTap: () {
                ToRemove(context, const BankSetting());
              },
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: const Color(0xffFAFAFA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/icons/bank.svg"),
                      const SizedBox(width: 10),
                      DefaultText(
                        "Bank".tr(),
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      const Spacer(),
                      SvgPicture.asset("assets/icons/edit.svg"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
