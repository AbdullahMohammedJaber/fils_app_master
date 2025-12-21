// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/utils/global_function/number_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/controller/provider/store_notofire.dart';
import 'package:fils/model/response/details_product_response.dart';
import 'package:fils/screen/Buyer/product/details_product/header_details_product.dart';
import 'package:fils/screen/Buyer/product/details_product/option_section.dart';
import 'package:fils/screen/Buyer/product/details_product/section_category.dart';
import 'package:fils/screen/Buyer/product/details_product/section_count_add_cart.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/http/get_object_widget.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/dialog_auth.dart';
import 'package:provider/provider.dart';

class DetailsProductScreen extends StatefulWidget {
  final dynamic idProduct;

  const DetailsProductScreen({super.key, required this.idProduct});

  @override
  State<DetailsProductScreen> createState() => _DetailsProductScreenState();
}

class _DetailsProductScreenState extends State<DetailsProductScreen> {
  @override
  void initState() {
    // TODO: implement initState
    changeDomain1();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    changeDomain2();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return ChangeNotifierProvider(
      create: (context) => StoreNotifire(),
      child: Consumer2<StoreNotifire, AppNotifire>(
        builder: (context, store, app, child) {
          return Scaffold(
            appBar: AppBar(automaticallyImplyLeading: false, toolbarHeight: 0),
            body: CustomRequestWidget(
              url: "products/${widget.idProduct}",
              requestType: RequestType.get,
              buildResponse: (p0, p1) {
                DetailsProductResponse data = p1 as DetailsProductResponse;
                ProductData details = data.data.product.data;
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      details.photos!.data.isNotEmpty ||
                              details.thumbnailImg!.data.isNotEmpty
                          ? HeaderDetailsProduct(details: details)
                          : const SizedBox(),
                      SizedBox(height: heigth * 0.01),
                      // Category Name
                      SectionCategory(details: details),
                      SizedBox(height: heigth * 0.001),
                      // Product Name
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DefaultText(
                          details.productName,
                          color: blackColor,
                          fontSize: 16,
                          overflow: TextOverflow.visible,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: heigth * 0.02),
                      // Product Price
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DefaultText(
                          "${details.price_after_discount}",
                          color: secondColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      // Product Size (xl , xxl)
                      details.variantProduct == 1
                          ? OptionSection(details: details)
                          : const SizedBox(),
                      SizedBox(height: heigth * 0.03),
                      // Product Count For Order
                      SectionCountAddCart(details: details),
                      // Product Details
                      SizedBox(height: heigth * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            details.description == null
                                ? const SizedBox()
                                : DefaultText(
                                  "Product Details".tr(),
                                  fontSize: 14,
                                  color: const Color(0xff5A5555),
                                  fontWeight: FontWeight.w500,
                                ),
                            SizedBox(height: heigth * 0.01),
                            details.description == null
                                ? const SizedBox()
                                : SizedBox(
                                  width: width * 0.85,
                                  child: Html(data: details.description),
                                ),
                          ],
                        ),
                      ),
                      SizedBox(height: heigth * 0.05),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap:(){
                                if (isLogin()) {
                                  if (details.variantProduct == 1) {
                                    if (store.idSizeSelect == null) {
                                      showCustomFlash(
                                        message: "Please Select option".tr(),
                                        messageType: MessageType.Faild,
                                      );
                                    } else {
                                      store.functionAddCart(id: details.id, type: 1);
                                    }
                                  } else {
                                    store.functionAddCart(id: details.id, type: 1);
                                  }
                                } else {
                                  showDialogAuth(context);
                                }
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: primaryColor,
                                ),
                                child: Center(
                                  child: SvgPicture.asset("assets/icons/plus.svg"),
                                ),
                              ),
                            ),
                            // if (store.totalPrice == 0)
                            //   DefaultText(
                            //     " ${extractDouble(details.price_after_discount!) * store.countItemForOrder} ${app.currancy.tr()}",
                            //     color: secondColor,
                            //     fontSize: 20,
                            //     fontWeight: FontWeight.w500,
                            //   )
                            // else
                            //   DefaultText(
                            //     " ${store.totalPrice * store.countItemForOrder} ${app.currancy.tr()}",
                            //     color: secondColor,
                            //     fontSize: 20,
                            //     fontWeight: FontWeight.w500,
                            //   ),
                            SizedBox(width: width * 0.05),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                       if(isLogin()){
                                         if (details.variantProduct == 1) {
                                           if (store.idSizeSelect == null) {
                                             showCustomFlash(
                                               message: "Please Select option".tr(),
                                               messageType: MessageType.Faild,
                                             );
                                           } else {
                                             store.functionAddCart(id: details.id, type: 2);
                                           }
                                         } else {
                                           store.functionAddCart(id: details.id , type: 2);
                                         }

                                       }else{
                                         showDialogAuth(context);
                                       }
                                },
                                child: Container(
                                  height: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: orange,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/cart_nav.svg",
                                        color: white,
                                      ),
                                      SizedBox(width: width * 0.02),
                                      DefaultText(
                                        "Go To Cart".tr(),
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
                      SizedBox(height: heigth * 0.05),
                    ],
                  ),
                );
              },
              parseResponse: (p0) => DetailsProductResponse.fromJson(p0),
            ),
          );
        },
      ),
    );
  }
}
