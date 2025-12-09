import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/theme_notifire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/flip_view.dart';
import 'package:provider/provider.dart';

Widget itemBackAndTitle(
  BuildContext context, {
  String? title,
  bool? showBackIcon = true,
  Color? color,
}) {
  return Consumer<ThemeProvider>(
    builder: (context, theme, app) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showBackIcon!
              ? GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SizedBox(
                  height: getLang() == 'ar' ? 30 : 28,
                  width: 40,
                  child: FlipView(
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/icons/back.svg",
                        color:
                            color ?? (getTheme()
                                ? white
                                : Colors.black),
                      ),
                    ),
                  ),
                ),
              )
              : const SizedBox(),
          SizedBox(width: width * 0.01),
          DefaultText(
            title ?? "Setting".tr(),
            color: primaryDarkColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ],
      );
    },
  );
}
