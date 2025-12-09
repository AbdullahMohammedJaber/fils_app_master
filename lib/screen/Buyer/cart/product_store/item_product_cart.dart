import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fils/controller/provider/cart_notifire.dart';
import 'package:fils/model/response/cart_list_response.dart';

import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/changeCount.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/global_function/printer.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/slidable_widget.dart';
import 'package:provider/provider.dart';

class ItemProductCart extends StatelessWidget {
  final dynamic index;
  final CartItem cartItem;
  final bool isAuction;

  const ItemProductCart(this.index, this.cartItem, this.isAuction, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<CartNotifire, AppNotifire>(
      builder: (context, cart, app, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            height: heigth * 0.15,
            width: width,
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: getTheme() ? Colors.black : const Color(0xffFAFAFA),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Slidable(
              direction: Axis.horizontal,
              enabled: true,
              closeOnScroll: true,
              key: ValueKey(index),
              startActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  Expanded(
                    child: CustomSlideAction(
                      color: const Color(0xffF1673C),
                      imagePath: "assets/icons/delete.svg",
                      onTap: () async {
                        cart.deleteCartRequest(idItem: cartItem.id);
                        printGreenLong("Delete Cart");
                      },
                    ),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: width * 0.17,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: cartItem.productThumbnailImage,
                          placeholder:
                              (context, url) => const LoadingWidgetImage(),
                          errorWidget:
                              (context, url, error) =>
                                  Image.asset("assets/images/fils_logo_f.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DefaultText(
                            cartItem.shopName,
                            color: getTheme() ? white : textColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: heigth * 0.01),
                          SizedBox(
                            width: width * 0.4,
                            child: DefaultText(
                              cartItem.productName,
                              color: getTheme() ? white : blackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: heigth * 0.01),
                          isAuction
                              ? const SizedBox()
                              : Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (cartItem.quantity > 1) {
                                        cart.processCart(
                                          idItem: cartItem.id,
                                          quantity: cartItem.quantity - 1,
                                          type: ChangeCountType.MIN,
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Center(
                                        child: DefaultText(
                                          "-",
                                          fontSize: 12,
                                          color: textColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width * 0.02),
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: const Color(0xff898384),
                                      ),
                                    ),
                                    child: Center(
                                      child: DefaultText(
                                        cartItem.quantity.toString(),
                                        fontSize: 12,
                                        color: textColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width * 0.02),
                                  GestureDetector(
                                    onTap: () {
                                      cart.processCart(
                                        idItem: cartItem.id,
                                        quantity: cartItem.quantity + 1,
                                        type: ChangeCountType.PLUS,
                                      );
                                    },
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Center(
                                        child: DefaultText(
                                          "+",
                                          fontSize: 12,
                                          color: primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        ],
                      ),
                    ),
                    DefaultText(
                      "${cartItem.price} ${app.currancy} ",
                      color: primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
