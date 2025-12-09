import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/storage/storage.dart';

class IntegratedUser extends StatelessWidget {
  const IntegratedUser({super.key});

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
                        "Integrated User Experience".tr(),
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
                      "* Professional Reels videos to increase sales and excitement."
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
                      "* A unified basket for purchases from multiple stores."
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
                      "* Multiple delivery options to suit the customer.".tr(),
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
        Image.asset("assets/images/integrated.png"),
      ],
    );
  }
}
