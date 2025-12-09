import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/store_notofire.dart';
import 'package:fils/utils/enum/changeCount.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

import '../../../../model/response/details_product_response.dart';
import '../../../../utils/const.dart';

class SectionCountAddCart extends StatelessWidget {
  final ProductData details;

  const SectionCountAddCart({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreNotifire>(
      builder: (context, store, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  DefaultText(
                    "Number of quantity".tr(),
                    fontSize: 14,
                    color: const Color(0xff5A5555),
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(width: width * 0.02),
                  DefaultText(
                    "How many do you want?".tr(),
                    fontSize: 8,
                    color: textColor,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
              SizedBox(height: heigth * 0.02),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (details.variantProduct == 1) {
                        if (store.idSizeSelect == null) {
                          showCustomFlash(
                            message: "Please Select option".tr(),
                            messageType: MessageType.Faild,
                          );
                        } else {
                          store.changeCountItemForOrder(
                            changeCountType: ChangeCountType.MIN,
                            max:
                                details.variantProduct == 1
                                    ? store.qtuWSize
                                    : details.lowStockQuantity!,
                          );
                        }
                      } else {
                        store.changeCountItemForOrder(
                          changeCountType: ChangeCountType.MIN,
                          max: details.lowStockQuantity,
                        );
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xff898384)),
                      ),
                      child: Center(
                        child: DefaultText(
                          "-",
                          fontSize: 28,
                          color: textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xff898384)),
                    ),
                    child: Center(
                      child: DefaultText(
                        store.countItemForOrder.toString(),
                        fontSize: 20,
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  GestureDetector(
                    onTap: () {
                      print(details.lowStockQuantity);
                      if (details.variantProduct == 1) {
                        if (store.idSizeSelect == null) {
                          showCustomFlash(
                            message: "Please Select option".tr(),
                            messageType: MessageType.Faild,
                          );
                        } else {
                          if (store.countItemForOrder == store.qtuWSize) {
                            showCustomFlash(
                              message:
                                  "The product has run out of stock in the store"
                                      .tr(),
                              messageType: MessageType.Faild,
                            );
                          } else {
                            store.changeCountItemForOrder(
                              changeCountType: ChangeCountType.PLUS,
                              max:
                                  details.variantProduct == 1
                                      ? store.qtuWSize
                                      : details.lowStockQuantity,
                            );
                          }
                        }
                      } else {
                        if (store.countItemForOrder == details.currentStock!) {
                          showCustomFlash(
                            message:
                                "The product has run out of stock in the store"
                                    .tr(),
                            messageType: MessageType.Faild,
                          );
                        } else {
                          store.changeCountItemForOrder(
                            changeCountType: ChangeCountType.PLUS,
                            max: details.lowStockQuantity,
                          );
                        }
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: primaryColor,
                      ),
                      child: Center(
                        child: DefaultText(
                          "+",
                          fontSize: 25,
                          color: white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
