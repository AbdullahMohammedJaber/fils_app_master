// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/order_notifire.dart';
import 'package:fils/model/response/order_response.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

import '../../../utils/theme/color_manager.dart';

class ItemOrder extends StatelessWidget {
  final Orders orders;
  final bool isCancel;
  final dynamic status;

  const ItemOrder({
    super.key,
    required this.orders,
    this.isCancel = false,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderNotifier>(builder: (context, order, child) {
      return GestureDetector(
        onTap: () {
          if (isCancel) {
            order.changeIdCancelOrder(idOrder: orders.id);
          }

          order.changeShowDetailsOrder(orders);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10, top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xffFAFAFA),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0 , vertical: 10),
            child: Row(
              children: [
                SizedBox(width: width * 0.015),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DefaultText(
                              "# ${orders.code}",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: blackColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: heigth * 0.005),
                      Row(
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset("assets/icons/quantity.svg"),
                              SizedBox(width: width * 0.015),
                              DefaultText(
                                "Quantity : ".tr() +
                                    "${orders.products.length}",
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            ],
                          ),
                          SizedBox(width: width * 0.03),
                          Row(
                            children: [
                              SvgPicture.asset("assets/icons/man_delivery.svg"),
                              SizedBox(width: width * 0.015),
                              DefaultText(
                                "Delivery : 3 ",
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: heigth * 0.008),
                      Row(
                        children: [
                          DefaultText(
                            orders.date,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: textColor,
                          ),
                          SizedBox(width: width * 0.03),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 4,
                                backgroundColor: status == 1
                                    ? Colors.orange
                                    : status == 2
                                        ? Colors.green
                                        : Colors.red,
                              ),
                              SizedBox(width: width * 0.01),
                              DefaultText(
                                status == 1
                                    ? "in Progress".tr()
                                    : status == 2
                                        ? "Completed".tr()
                                        : status == 3
                                            ? "Canceled".tr()
                                            : "Un Paid".tr(),
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                      /* if (status == 4)
                        GestureDetector(
                          onTap: (){

                          },
                          child: Container(
                            height: 50,
                            width: 100,
                            margin:const EdgeInsets.only(top: 15),
                            child: DefaultText(
                              "Re Paid".tr(),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: purpleColor,
                            ),
                          ),
                        )*/
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    isCancel
                        ? Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: textColor),
                            ),
                            child: order.idOrderForCancel == orders.id
                                ? Container(
                                    margin: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: purpleColor),
                                  )
                                : const SizedBox(),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 5),
                    DefaultText(
                      orders.grandTotal,
                      color: secondColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      );
    });
  }
}
