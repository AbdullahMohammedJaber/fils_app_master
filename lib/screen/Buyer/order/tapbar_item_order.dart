import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:fils/controller/provider/order_notifire.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

class TapBarOrderItem extends StatelessWidget {
  const TapBarOrderItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderNotifier>(builder: (context, cart, child) {
      return Container(
        height: 55,
        margin: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          border: Border.all(color: grey3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    cart.changePageTapBar(index: 1);
                    cart.changeUrl(
                        "purchase-history?delivery_status=pending&payment_status=paid");
                  },
                  child: AnimatedContainer(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: cart.pageTapBar == 1 ? primaryColor : white,
                    ),
                    duration: const Duration(milliseconds: 100),
                    child: Center(
                      child: DefaultText(
                        "Current".tr(),
                        color: cart.pageTapBar == 1 ? white : blackColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: width * 0.01),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    cart.changePageTapBar(index: 2);
                    cart.changeUrl(
                        "purchase-history?delivery_status=delivered&payment_status=paid");
                  },
                  child: AnimatedContainer(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: cart.pageTapBar == 2 ? primaryColor : white,
                    ),
                    duration: const Duration(milliseconds: 100),
                    child: Center(
                      child: DefaultText(
                        "Completed".tr(),
                        color: cart.pageTapBar == 2 ? white : blackColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: width * 0.01),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    cart.changePageTapBar(index: 4);
                    cart.changeUrl(
                        "purchase-history?delivery_status=pending&payment_status=unpaid");
                  },
                  child: AnimatedContainer(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: cart.pageTapBar == 4 ? primaryColor : white,
                    ),
                    duration: const Duration(milliseconds: 100),
                    child: Center(
                      child: DefaultText(
                        "Un Paid".tr(),
                        color: cart.pageTapBar == 4 ? white : blackColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: width * 0.01),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    cart.changePageTapBar(index: 3);
                    cart.changeUrl(
                        "purchase-history?delivery_status=cancelled");
                  },
                  child: AnimatedContainer(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: cart.pageTapBar == 3 ? primaryColor : white,
                    ),
                    duration: const Duration(milliseconds: 100),
                    child: Center(
                      child: DefaultText(
                        "Cancelled".tr(),
                        color: cart.pageTapBar == 3 ? white : blackColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
