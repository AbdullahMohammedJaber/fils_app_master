import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/screen/Seller/control_product/all_users_reviews.dart';
import 'package:fils/screen/Seller/control_product/edit_product_form.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/product_notifire.dart';
import 'package:fils/model/response/seller/details_product_seller.dart';
import 'package:fils/screen/Seller/control_product/header_priduct_seller.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/http/get_object_widget.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

class DetailsProductSeller extends StatelessWidget {
  final dynamic idProduct;

  const DetailsProductSeller({super.key, required this.idProduct});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProductNotifire, AppNotifire>(
        builder: (context, controller, app, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
        ),
        body: CustomRequestWidget(
          url: "products/edit/$idProduct",
          requestType: RequestType.get,
          buildResponse: (p0, p1) {
            DetailsProductSellerResponse data =
                p1 as DetailsProductSellerResponse;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderDetailsSellerProduct(
                    details: data.data,
                  ),
                  SizedBox(height: heigth * 0.01),
                  SizedBox(height: heigth * 0.001),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        DefaultText(
                          data.data.shopName,
                          color: textColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        const Spacer(),
                        DefaultText(
                          "${data.data.unitPrice} ${app.currancy.tr()}",
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: secondColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: heigth * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DefaultText(
                      data.data.productName,
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  data.data.variantProduct == 0
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  DefaultText(
                                    "Option2".tr(),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(width: width * 0.02),
                                  DefaultText(
                                    "View option guide".tr(),
                                    fontSize: 8,
                                    fontWeight: FontWeight.w400,
                                    color: textColor,
                                  ),
                                ],
                              ),
                              SizedBox(height: heigth * 0.02),
                              Row(
                                children: [
                                  for (dynamic i = 0;
                                      i < data.data.colors.length;
                                      i++)
                                    Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        border: Border.all(color: grey4),
                                        color: Color(int.parse(data
                                            .data.colors[i]
                                            .replaceAll('#', '0xff'))),
                                      ),
                                    )
                                ],
                              ),
                              SizedBox(height: heigth * 0.02),
                              Row(
                                children: [
                                  for (dynamic i = 0;
                                      i < data.data.stocks.data.length;
                                      i++)
                                    Container(
                                      height: 40,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: primaryColor)),
                                      child: Center(
                                        child: DefaultText(
                                          data.data.stocks.data[i].variant,
                                          color: blackColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ],
                          ),
                        ),
                  SizedBox(height: heigth * 0.03),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DefaultText(
                              "Quantity".tr(),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: heigth * 0.01),
                            Container(
                              height: 40,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: textColor),
                              ),
                              child: Center(
                                child: DefaultText(
                                  data.data.currentStock.toString(),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: blackColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: width * 0.05),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DefaultText(
                              "Number of reviews".tr(),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: heigth * 0.01),
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: textColor),
                                  ),
                                  child: Center(
                                    child: DefaultText(
                                      data.data.reviews_count.toString(),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: blackColor,
                                    ),
                                  ),
                                ),
                                SizedBox(width: width * 0.03),
                                DefaultText(
                                  "(4.8)".tr(),
                                  textDecoration: TextDecoration.underline,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                SizedBox(width: width * 0.01),
                                SvgPicture.asset("assets/icons/star.svg"),
                                SizedBox(width: width * 0.02),
                                GestureDetector(
                                  onTap: () async {
                                    print(getUserToken());
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      useSafeArea: true,
                                      builder: (context) {
                                        return AllUsersReviews(
                                            productId: data.data.id);
                                      },
                                    );
                                  },
                                  child: DefaultText(
                                    "View users".tr(),
                                    textDecoration: TextDecoration.underline,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: heigth * 0.03),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DefaultText(
                              "Number of additions to favorites".tr(),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: heigth * 0.01),
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: textColor),
                                  ),
                                  child: Center(
                                    child: DefaultText(
                                      data.data.fav_count.toString(),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: blackColor,
                                    ),
                                  ),
                                ),
                                SizedBox(width: width * 0.03),
                                /* GestureDetector(
                                  onTap: () {},
                                  child: DefaultText(
                                    "View users".tr(),
                                    textDecoration: TextDecoration.underline,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),*/
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: heigth * 0.03),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          "Product Details".tr(),
                          fontSize: 14,
                          color: const Color(0xff5A5555),
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: heigth * 0.01),
                        data.data.description != null
                            ? SizedBox(
                                width: width,
                                child: Html(
                                  data: data.data.description,
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  SizedBox(height: heigth * 0.05),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.deleteProduct(context,
                                idProduct: data.data.id);
                          },
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: Center(
                              child: SvgPicture.asset(
                                  "assets/icons/delete_red.svg"),
                            ),
                          ),
                        ),
                        SizedBox(width: width * 0.05),
                        Expanded(
                          child: ButtonWidget(
                            onTap: () {
                              // context
                              //     .read<ProductNotifire>()
                              //     .initPassedData(data.data);
                              ToRemove(
                                  context,
                                  EditProductForm(
                                      detailsProductSellerResponse: data.data));
                            },
                            title: "Edit".tr(),
                            colorButton: secondColor,
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
          parseResponse: (p0) => DetailsProductSellerResponse.fromJson(p0),
        ),
      );
    });
  }
}
