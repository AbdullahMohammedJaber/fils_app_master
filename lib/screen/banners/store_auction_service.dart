import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/storage/storage.dart';

class StoreAuctionService extends StatelessWidget {
  const StoreAuctionService({super.key});

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
                        "Store And Auction Services".tr(),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: purpleColor,
                      ),
                      const SizedBox(width: 3),
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
                      "* Renting an integrated online store for merchants and companies."
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
                      "* Specialized auctions with a system that ensures integrity."
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
                      "* Securing bids to prevent manipulation.".tr(),
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
        Image.asset("assets/images/store_auction_sevise.png"),
      ],
    );
  }
}
