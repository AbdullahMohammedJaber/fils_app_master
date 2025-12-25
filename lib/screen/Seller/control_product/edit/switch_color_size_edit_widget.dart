import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/edit_product_notifire.dart';
import 'package:flutter/material.dart';

 import 'package:fils/utils/const.dart';
import 'package:provider/provider.dart';

import '../../../../utils/theme/color_manager.dart';
import '../../../../widget/defulat_text.dart';


Widget switchColorSizeEditWidget(BuildContext context) {
  return Consumer<EditProductNotifire>(
    builder: (context, controller, child) {
      return Container(
        width: width,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffE9E9E9)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  DefaultText(
                    "Color".tr(),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: blackColor,
                  ),
                  const Spacer(),
                  Switch(
                    value: controller.switchColor,
                    onChanged: (value) {
                      controller.changeSwitchColor(value);
                    },
                    activeColor: primaryColor,
                    inactiveThumbColor: Colors.grey,
                  ),

                ],
              ),
              SizedBox(height: heigth * 0.02),
              Row(
                children: [
                  DefaultText(
                    "Size".tr(),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: blackColor,
                  ),
                  const Spacer(),
                  Switch(
                    value: controller.switchSize,
                    onChanged: (value) {
                      controller.changeSwitchSize(value);
                    },
                    activeColor: primaryColor,
                    inactiveThumbColor: Colors.grey,
                  ),

                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
