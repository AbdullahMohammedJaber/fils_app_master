import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/model/app/delivery_companies_model.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/cart_notifire.dart';
import 'package:fils/screen/Buyer/cart/product_store/item_analyze_price_cart.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/item_back.dart';
import 'package:provider/provider.dart';

class PaymentMethodeScreen extends StatelessWidget {
  final DeliveryCompaniesModel deliveryCompaniesModel;

  const PaymentMethodeScreen({super.key, required this.deliveryCompaniesModel});

  @override
  Widget build(BuildContext context) {
    return Consumer2<CartNotifire, AppNotifire>(
      builder: (context, cart, app, child) {
        return Scaffold(
          appBar: AppBar(automaticallyImplyLeading: false , toolbarHeight: 0),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                SizedBox(height: heigth * 0.06),

                itemBackAndTitle(context, title: "Payment methods".tr()),
                SizedBox(height: heigth * 0.05),
                ...List.generate(cart.paymentMethodResponse!.data.length, (
                  index,
                ) {
                  return GestureDetector(
                    onTap: () {
                      cart.selectPaymentMethode(
                        cart.paymentMethodResponse!.data[index].paymentTypeKey,
                      );
                    },
                    child: Container(
                      height: 60,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color:
                            getTheme() ? Colors.black : const Color(0xffFAFAFA),
                        borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color:  cart
                                  .paymentMethodResponse!
                                  .data[index]
                                  .isSelect
                                  ? orange
                                  : Colors.grey.shade300
                          )
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            width: 50,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:  cart
                                    .paymentMethodResponse!
                                    .data[index]
                                    .isSelect
                                    ? orange
                                    : Colors.grey.shade300
                              )
                            ),
                            child: Image.network(
                              cart.paymentMethodResponse!.data[index].image,
                              fit: BoxFit.cover,
                            ),
                          ),
                          DefaultText(
                            cart.paymentMethodResponse!.data[index].name,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: const Color(0xff898384),
                              ),
                            ),
                            child: Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color:
                                    cart
                                            .paymentMethodResponse!
                                            .data[index]
                                            .isSelect
                                        ? purpleColor
                                        : Colors.transparent,
                              ),
                              margin: const EdgeInsets.all(2),
                            ),
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(height: heigth * 0.05),
                const ItemAnalyzePriceCart(),
                SizedBox(height: heigth * 0.1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      DefaultText(
                        "${cart.cartListResponse!.order_amount} ${app.currancy} ",
                        color: secondColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(width: width * 0.05),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (cart.paymentMethode != null) {
                              cart.createOrder(
                                deliveryCompaniesModel: deliveryCompaniesModel,
                              );
                            } else {
                              showCustomFlash(
                                message: "Please Select Payment Methode".tr(),
                                messageType: MessageType.Faild,
                              );
                            }
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: secondColor,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
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
          ),
        );
      },
    );
  }
}
