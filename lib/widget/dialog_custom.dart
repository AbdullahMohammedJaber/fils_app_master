// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/flip_view.dart';

customDialog(
  BuildContext context, {
  Widget? widget,
  String? title,
  String? body,
  String? titleButton,
  Function()? onTap,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: widget ??
          SizedBox(
            width: width,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 45,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xffF9F9F9),
                          ),
                          child: Center(
                            child: FlipView(
                              child: SvgPicture.asset(
                                "assets/icons/close.svg",
                                color: blackColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  DefaultText(
                    title ?? "Done Proccess".tr(),
                    color: blackColor,
                    type: FontType.bold,
                    fontSize: 18,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: heigth * 0.01),
                  DefaultText(
                    body ?? "Your Send New Password".tr(),
                    color: blackColor,
                    type: FontType.medium,
                    fontSize: 16,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: heigth * 0.03),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.2),
                    child: ButtonWidget(
                      title: titleButton ?? "Yes".tr(),
                      fontType: FontType.bold,
                      sizeTitle: 18,
                      onTap: onTap ??
                          () {
                            Navigator.pop(context);
                          },
                    ),
                  )
                ],
              ),
            ),
          ),
    ),
  );
}
