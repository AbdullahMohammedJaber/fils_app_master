import 'package:easy_localization/easy_localization.dart';

import 'package:fils/utils/global_function/validation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fils/controller/provider/aucation_notifier.dart';
import 'package:fils/model/response/seller/auction_seller_response.dart';

import 'package:fils/screen/Seller/control_auction/empty_auction.dart';
import 'package:fils/screen/Seller/control_auction/item_auction_seller.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/http/list_pagination.dart';

import 'package:fils/widget/defulat_text.dart';

import 'package:provider/provider.dart';

import '../../../utils/const.dart';
import '../../../utils/theme/color_manager.dart';
import '../../../widget/item_back.dart';

class AuctionSellerScreen extends StatelessWidget {
 final bool isAds;

  const AuctionSellerScreen({super.key, required this.isAds});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuctionNotifier>(
      builder: (context, controller, child) {
        return Scaffold(

          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 SizedBox(width: width, height: heigth * 0.02),
                isAds
                    ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: itemBackAndTitle(context, title: "My Auction".tr()),
                )
                    :   Row(
                  children: [
                    DefaultText(
                      "My Auction".tr(),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: primaryDarkColor,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        checkStatusStore(false, context);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: secondColor,
                        ),
                        child: Center(
                          child: SvgPicture.asset("assets/icons/plus.svg"),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: width, height: heigth * 0.02),
                Expanded(
                  child: PaginatedListWidget(
                    endpoint: "auction-products",
                    cacheKey: "auction_seller_screen",
                    requestType: RequestType.get,
                    itemBuilder: (context, item) {
                      return ItemAuctionSeller(datum: item , isAds: isAds,);
                    },
                    parseItem: (json) => AuctionSeller.fromJson(json),
                    isFirstData: false,
                    isParam: false,
                    updateController: controller.updateControllerAuctionSeller,
                    emptyWidget: emptyMyAuction(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
