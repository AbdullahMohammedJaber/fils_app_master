import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/aucation_notifier.dart';
import 'package:fils/screen/Buyer/favourite/favourait_screen.dart';
import 'package:fils/screen/Buyer/notification/notification_screen.dart';
import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/flip_view.dart';

import '../../../utils/theme/color_manager.dart';

Widget itemTitleAucatin(
  AuctionNotifier? auctionNotifier,
  BuildContext context,
    String nameCategory,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: AnimatedOpacity(
      duration: const Duration(seconds: 1),
      opacity: auctionNotifier!.visible ? 1.0 : 0.0,
      child: Row(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(NavigationService.navigatorKey.currentContext!);
                },
                child: SizedBox(
                  height: getLang() == 'ar' ? 20 : 25,
                  width: 30,
                  child: Center(
                    child: FlipView(
                      child: SvgPicture.asset(
                        "assets/icons/back.svg",
                        color:   white ,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: width * 0.04),
              SizedBox(
                width: width * 0.5,
                child: DefaultText(
                  "${"Public Auctions".tr()} $nameCategory",
                  color: white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const Spacer(),
          isLogin()
              ? Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      ToWithFade(context, const NotificationsScreen());
                    },
                    child: SizedBox(
                      height: 35,
                      width: 35,
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/icons/notification_home.svg",

                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.01),
                  GestureDetector(
                    onTap: () {
                      ToWithFade(context, FavouraitScreen());
                    },
                    child: SizedBox(
                      height: 35,
                      width: 35,
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/icons/favourite_home.svg",
                        ),
                      ),
                    ),
                  ),
                ],
              )
              : const SizedBox(),
        ],
      ),
    ),
  );
}
