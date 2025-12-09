import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/order_notifire.dart';
import 'package:fils/model/response/seller/order_seller.dart';
import 'package:fils/screen/Buyer/order/traking_screen.dart';
import 'package:fils/screen/Seller/order/shipping_address.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/defulat_text.dart';

import 'package:flutter/material.dart';

import 'package:fils/utils/enum/request_type.dart';

import 'package:fils/utils/http/list_pagination.dart';

import 'package:fils/widget/item_back.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../utils/const.dart';

class OrderSeller extends StatefulWidget {
  final bool isPop;

  const OrderSeller({super.key, required this.isPop});

  @override
  State<OrderSeller> createState() => _OrderSellerState();
}

class _OrderSellerState extends State<OrderSeller> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderNotifier>(
      builder: (context, order, child) {
        return Scaffold(
          appBar: AppBar(toolbarHeight: 0),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: width, height: heigth * 0.02),

                itemBackAndTitle(
                  context,
                  title: "My Order".tr(),
                  showBackIcon: widget.isPop,
                ),
                SizedBox(height: heigth * 0.04),
                Expanded(
                  child: PaginatedListWidget(
                    endpoint: 'orders',
                    requestType: RequestType.get,
                    requestBody: const {
                      "payment_status": "paid",
                      // "delivery_status": ""
                    },
                    parseItem: (json) => OrderSeeler.fromJson(json),
                    itemBuilder: (context, item) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              order.changeShowDetailsOrderSeller(item);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                bottom: 10,
                                top: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xffFAFAFA),
                                border: Border.all(color: textColor),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 10,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: width * 0.015),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: DefaultText(
                                                      "# ${item.code}",
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                      SvgPicture.asset(
                                                        "assets/icons/quantity.svg",
                                                      ),
                                                      SizedBox(
                                                        width: width * 0.015,
                                                      ),
                                                      DefaultText(
                                                        "${"Quantity : ".tr()}${item.products!.length}",
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: textColor,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: width * 0.03),
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/icons/man_delivery.svg",
                                                      ),
                                                      SizedBox(
                                                        width: width * 0.015,
                                                      ),
                                                      DefaultText(
                                                        "Delivery : 3 ",
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                                    item.date,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w400,
                                                    color: textColor,
                                                  ),
                                                  SizedBox(width: width * 0.03),
                                                  // Row(
                                                  //   children: [
                                                  //     CircleAvatar(
                                                  //       radius: 4,
                                                  //       backgroundColor:
                                                  //           status == 1
                                                  //               ? Colors.orange
                                                  //               : status == 2
                                                  //               ? Colors.green
                                                  //               : Colors.red,
                                                  //     ),
                                                  //     SizedBox(width: width * 0.01),
                                                  //     DefaultText(
                                                  //       status == 1
                                                  //           ? "in Progress".tr()
                                                  //           : status == 2
                                                  //           ? "Completed".tr()
                                                  //           : status == 3
                                                  //           ? "Canceled".tr()
                                                  //           : "Un Paid".tr(),
                                                  //       fontSize: 8,
                                                  //       fontWeight: FontWeight.w500,
                                                  //       color: textColor,
                                                  //     ),
                                                  //   ],
                                                  // ),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(),
                                            const SizedBox(height: 5),
                                            DefaultText(
                                              item.grandTotal,
                                              color: secondColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    ),

                                    SizedBox(
                                      width: 100,
                                      child: ButtonWidget(
                                        colorButton: primaryColor,
                                        colorTitle: white,
                                        heightButton: 30,
                                        onTap: () {
                                          ToWithFade(
                                            context,
                                            ShippingAdress(order_id: item.id!),
                                          );
                                        },
                                        title: "Sipping".tr(),
                                        radius: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          item.isShow
                              ? TrackingScreen(
                                itineraries: item.products!,
                                date: item.date!,
                              )
                              : const SizedBox(),
                        ],
                      );
                    },
                    isFirstData: false,
                    isParam: false,
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
