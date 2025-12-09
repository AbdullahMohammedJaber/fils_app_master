import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/storage/storage.dart';

class SaveFinancial extends StatelessWidget {
  const SaveFinancial({super.key});

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
                        "Safe Financial Systems".tr(),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: purpleColor,
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
                      "* Safe and secure money transfer system.".tr(),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.visible,
                      color:getTheme()?white: textColor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: heigth * 0.01),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 8),
                child: Wrap(
                  children: [
                    DefaultText(
                      "* Guarantee that the buyer receives the product in good condition."
                          .tr(),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.visible,
                      color:getTheme()?white: textColor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: heigth * 0.01),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 8),
                child: Wrap(
                  children: [
                    DefaultText(
                      "* Protect the rights of the seller and the buyer.".tr(),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.visible,
                      color:getTheme()?white: textColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Image.asset("assets/images/save.png"),
      ],
    );
  }
}
