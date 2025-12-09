import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/aucation_notifier.dart';
import 'package:flutter/material.dart';

import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

import '../../../utils/storage/storage.dart';

// ignore: must_be_immutable
class TapBarItemAuction extends StatefulWidget {
  final int category_id;
   const TapBarItemAuction({super.key, required this.category_id});

  @override
  State<TapBarItemAuction> createState() => _TapBarItemAuctionState();
}

class _TapBarItemAuctionState extends State<TapBarItemAuction> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuctionNotifier>(
      builder: (context, app, child) {
        return Container(
          height: 55,
          margin: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            border: Border.all(color: grey3),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.06,
              vertical: 5,
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      app.changePageTapBar(index: 1);
                      app.changeUrlAuction(
                        "auction/products/sub-category",
                        "?is_auction=1&auction_type=normal",
                        widget.category_id,
                      );
                    },
                    child: AnimatedContainer(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color:
                            app.pageTapBarAuction == 1
                                ? secondColor
                                : getTheme()
                                ? Colors.black
                                : white,
                      ),
                      duration: const Duration(milliseconds: 100),
                      child: Center(
                        child: DefaultText(
                          "Normal Auction".tr(),
                          color:
                              app.pageTapBarAuction == 1
                                  ? white
                                  : getTheme()
                                  ? white
                                  : blackColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.01),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      app.changePageTapBar(index: 2);
                      app.changeUrlAuction(
                        "auction/products/sub-category",
                        "?is_auction=1&auction_type=live",
                        widget.category_id,

                      );
                    },
                    child: AnimatedContainer(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color:
                            app.pageTapBarAuction == 2
                                ? secondColor
                                : getTheme()
                                ? Colors.black
                                : white,
                      ),
                      duration: const Duration(milliseconds: 100),
                      child: Center(
                        child: DefaultText(
                          "Live Auction".tr(),
                          color:
                              app.pageTapBarAuction == 2
                                  ? white
                                  : getTheme()
                                  ? white
                                  : blackColor,
                        ),
                      ),
                    ),
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
