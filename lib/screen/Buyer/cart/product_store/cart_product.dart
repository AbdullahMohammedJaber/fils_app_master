import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/cart_notifire.dart';
import 'package:fils/model/response/cart_list_response.dart';
import 'package:fils/screen/Buyer/cart/product_store/cart_empty.dart';

import 'package:fils/utils/animation/custom_fade_animation.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

import '../../../../utils/http/get_object_widget.dart';

import 'item_analyze_price_cart.dart';

import 'item_delivery_methode.dart';
import 'item_product_cart.dart';

class CartProduct extends StatelessWidget {
  const CartProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<CartNotifire, AppNotifire>(
      builder: (context, cart, app, child) {
        return !isLogin()
            ? const CartEmptyScreen()
            : CustomFadeAnimationComponent(
              1,
              Container(
                margin: EdgeInsets.only(top: heigth * 0.04),
                child: CustomRequestWidget(
                  url: "carts?is_auction=0",
                  requestType: RequestType.post,
                  updateController: cart.cartUpdateController,
                  requestBody: {"user_id": getUser()!.user!.id},
                  parseResponse: (json) => CartListResponse.fromJson(json),
                  buildResponse: (p0, data) {
                    cart.changeCartListWhereRequest(data as CartListResponse);
                    if (cart.cartListResponse!.data.isNotEmpty) {
                      if (cart.cartListResponse!.data[0].cartItems.isEmpty) {
                        return const CartEmptyScreen();
                      } else {
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (
                                dynamic i = 0;
                                i < cart.cartListResponse!.data.length;
                                i++
                              )
                                ...List.generate(
                                  cart
                                      .cartListResponse!
                                      .data[i]
                                      .cartItems
                                      .length,
                                  (index) {
                                    if (cart
                                            .cartListResponse!
                                            .data[i]
                                            .cartItems[index]
                                            .auctionProduct ==
                                        0) {
                                      return ItemProductCart(
                                        index,
                                        cart
                                            .cartListResponse!
                                            .data[i]
                                            .cartItems[index],
                                        false,
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                ),
                              SizedBox(height: heigth * 0.01),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: DefaultText(
                                  "Add delivery methodes".tr(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff5A5555),
                                ),
                              ),
                              SizedBox(height: heigth * 0.01),
                              ItemDeliveryMethod(),
                              SizedBox(height: heigth * 0.04),
                              const ItemAnalyzePriceCart(),
                              SizedBox(height: heigth * 0.05),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Row(
                                  children: [
                                    DefaultText(
                                      "${cart.cartListResponse!.order_amount} ${app.currancy.tr()} ",
                                      color: secondColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    SizedBox(width: width * 0.05),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {

                                            if (!cart.key.currentState!
                                                .validate()) {
                                            } else {
                                              cart.functionGetPaymentMethode();
                                            }
                                        },
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            color: orange,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              DefaultText(
                                                "Check out".tr(),
                                                fontSize: 14,
                                                color: white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: heigth * 0.08),
                            ],
                          ),
                        );
                      }
                    } else {
                      return const CartEmptyScreen();
                    }
                  },
                ),
              ),
            );
      },
    );
  }
}
