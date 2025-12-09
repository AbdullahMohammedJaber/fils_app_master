// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';

import 'package:fils/utils/global_function/validation.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:flutter/material.dart';

import 'package:fils/screen/Seller/control_product/item_product_seller.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';

import '../../../model/response/seller/home_seller_response.dart';

class LastProductSeller extends StatelessWidget {
  HomeSeller homeSeller;

  LastProductSeller({super.key, required this.homeSeller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Row(
            children: [
              DefaultText(
                "Last My Product".tr(),
                color: getTheme() ? white : blackColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          SizedBox(height: heigth * 0.05),
          homeSeller.bestProducts.isEmpty
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultText(
                    "There are no products yet,".tr(),
                    color: getTheme() ? white : textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  const SizedBox(width: 2),
                  GestureDetector(
                    onTap: () async {
                      checkStatusStore(true, context);
                    },
                    child: DefaultText(
                      "add products".tr(),
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
              : Container(
                alignment: AlignmentDirectional.centerStart,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(
                      homeSeller.bestProducts.length,
                      (index) => ProductItemWidget2(
                        productListModel: homeSeller.bestProducts[index],
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
