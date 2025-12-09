// ignore_for_file: file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/store_notofire.dart';
import 'package:fils/screen/Buyer/favourite/favourait_screen.dart';
import 'package:fils/screen/Buyer/notification/notification_screen.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';

import '../../../widget/flip_view.dart';

Widget itemTitleBar(StoreNotifire? storeNotifire, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: AnimatedOpacity(
      duration: const Duration(seconds: 1),
      opacity: storeNotifire!.visible ? 1.0 : 0.0,
      child: Row(
        children: [
          GestureDetector(
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
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.transparent,
            backgroundImage: const AssetImage('assets/icons/fils.png'),
          ),
          SizedBox(width: width * 0.04),
          SizedBox(
            width: width * 0.5,
            child: DefaultText(
              "Store".tr(),
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),


        ],
      ),
    ),
  );
}
