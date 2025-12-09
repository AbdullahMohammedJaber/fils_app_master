import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/cart_notifire.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

class ItemAnalyzePriceCart extends StatelessWidget {
  const ItemAnalyzePriceCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<CartNotifire, AppNotifire>(
      builder: (context, cart, app, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.07),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffE8E2F8)),
              color: getTheme() ? Colors.black : const Color(0xffFAFAFA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                SizedBox(height: heigth * 0.01),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      DefaultText(
                        "Order Amount".tr(),
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      const Spacer(),
                      DefaultText(
                        "${cart.cartListResponse!.grandTotal} ${app.currancy.tr()}"
                            .tr(),
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      DefaultText(
                        "Delivery Quote".tr(),
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      const Spacer(),
                      DefaultText(
                        "${cart.cartListResponse!.shipping_cost} ${app.currancy.tr()}"
                            .tr(),
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      DefaultText(
                        "Application rate".tr(),
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      const Spacer(),
                      DefaultText(
                        "${cart.tax} ${app.currancy.tr()}".tr(),
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 1),
                SizedBox(height: heigth * 0.01),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      DefaultText(
                        "Total".tr(),
                        color: blackColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      const Spacer(),
                      DefaultText(
                        "${cart.cartListResponse!.order_amount}${app.currancy.tr()}"
                            .tr(),
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: heigth * 0.02),
              ],
            ),
          ),
        );
      },
    );
  }
}
