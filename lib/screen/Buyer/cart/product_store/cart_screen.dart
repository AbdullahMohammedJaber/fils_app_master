// ignore_for_file: use_key_in_widget_constructors

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/cart_notifire.dart';
import 'package:fils/screen/Buyer/cart/auction/cart_aucation.dart';
import 'package:fils/screen/Buyer/cart/tap_bar_item.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

import 'cart_product.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartNotifire>(
      builder: (context, cart, child) {
        return Scaffold(
          appBar: AppBar(toolbarHeight: 0),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: heigth * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  width: width * 0.5,
                  child: DefaultText(
                    "My Cart".tr(),
                    color: const Color(0xff042D5C),
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: heigth * 0.03),
              const TapBarItem(),
              Expanded(
                child:
                    cart.pageTapBar == 1
                        ? CartProduct()
                        : const CartAucations(),
              ),
            ],
          ),
        );
      },
    );
  }
}
