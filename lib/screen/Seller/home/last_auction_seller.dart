import 'package:easy_localization/easy_localization.dart';

import 'package:fils/utils/global_function/validation.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:fils/model/response/seller/home_seller_response.dart';
import 'package:fils/screen/Seller/control_auction/item_auction_seller.dart';
import 'package:fils/utils/const.dart';

import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';

class LastAuctionSeller extends StatelessWidget {
  final HomeSeller homeSeller;

  const LastAuctionSeller({super.key, required this.homeSeller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Row(
            children: [
              DefaultText(
                "Last Auction".tr(),
                color: getTheme() ? white : blackColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          SizedBox(height: heigth * 0.02),
          homeSeller.latestAuction == null
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultText(
                    "There are no auction yet,".tr(),
                    color: getTheme() ? white : textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  const SizedBox(width: 2),
                  GestureDetector(
                    onTap: () async {
                      checkStatusStore(false, context);
                    },
                    child: DefaultText(
                      "add new auction".tr(),
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
              : ItemAuctionSeller(datum: homeSeller.latestAuction! , isAds: false,),
        ],
      ),
    );
  }
}
