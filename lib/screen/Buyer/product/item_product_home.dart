// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/screen/Buyer/product/product_into_store.dart';
import 'package:fils/screen/Buyer/store/store_screen.dart';
import 'package:fils/widget/flip_view.dart';
import 'package:flutter/material.dart';

import 'package:fils/controller/provider/home_notifire.dart';
import 'package:fils/screen/Buyer/product/all_product_screen.dart';
import 'package:fils/screen/Buyer/product/item_product_widget_g.dart';
import 'package:fils/utils/const.dart';

import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';

import '../../../model/response/home_response.dart';
import '../../../utils/storage/storage.dart';

class ItemProductHome extends StatelessWidget {
  HomeResponse data;

  ItemProductHome({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeNotifire>(
      builder: (context, home, child) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(start: 12),
          child:
              data.data!.newProducts.data!.isNotEmpty
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          DefaultText(
                            "New Product".tr(),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: getTheme() ? white : blackColor,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              ToWithFade(context, const AllProductScreen());
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: DefaultText(
                                "See All".tr(),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: heigth * 0.02),
                      SizedBox(
                        width: width,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              data.data!.newProducts.data!.length,
                              (index) => Padding(
                                padding: EdgeInsetsDirectional.only(
                                  end: width * 0.01,
                                ),
                                child: ProductItemWidget(
                                  false,
                                  productListModel:
                                      data.data!.newProducts.data![index],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                  : const SizedBox(),
        );
      },
    );
  }
}

class ItemRelatedProductHome extends StatelessWidget {
  HomeResponse data;

  ItemRelatedProductHome({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeNotifire>(
      builder: (context, home, child) {
        if (data.data!.relatedProducts.data!.isNotEmpty) {
          return Padding(
            padding: const EdgeInsetsDirectional.only(start: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DefaultText(
                      "Related Product".tr(),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: getTheme() ? white : blackColor,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        ToWithFade(context, const AllProductScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DefaultText(
                          "See All".tr(),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: heigth * 0.02),
                SizedBox(
                  width: width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        data.data!.relatedProducts.data!.length,
                        (index) => Padding(
                          padding: EdgeInsetsDirectional.only(
                            end: width * 0.01,
                          ),
                          child: ProductItemWidget(
                            false,
                            productListModel:
                                data.data!.relatedProducts.data![index],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class ItemShopHome extends StatelessWidget {
  HomeResponse data;

  ItemShopHome({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeNotifire>(
      builder: (context, home, child) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(start: 12),
          child:
              data.data!.shops.data.isNotEmpty
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          DefaultText(
                            "Online Store".tr(),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: getTheme() ? white : blackColor,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              ToWithFade(context, StoreScreen());
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: DefaultText(
                                "See All".tr(),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: heigth * 0.02),
                      SizedBox(
                        width: width,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(data.data!.shops.data.length, (
                              index,
                            ) {
                              ShopsDatum dataInter =
                                  data.data!.shops.data[index];
                              if (dataInter.logo == null ||
                                  dataInter.logo == "") {
                                return const SizedBox();
                              } else {
                                return Padding(
                                  padding: EdgeInsetsDirectional.only(
                                    end: width * 0.01,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      ToWithFade(
                                        context,
                                        ProductsIntoStoreScreen(
                                          idStore: dataInter.id,
                                          nameStore: dataInter.name!,
                                          address: dataInter.address,
                                        ),
                                      );
                                    },
                                    child: Card(
                                      elevation: 1,
                                      color: getTheme() ? Colors.black : white,
                                      child: Container(
                                        width: width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(color: white),
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(height: heigth * 0.02),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                  ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  dataInter.logo!,
                                                  height: heigth * 0.13,
                                                  width: width * 0.31,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: width * 0.02),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  DefaultText(
                                                    dataInter.name,
                                                    color:
                                                        getTheme()
                                                            ? white
                                                            : Colors.black,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  SizedBox(
                                                    height: heigth * 0.01,
                                                  ),
                                                  DefaultText(
                                                    dataInter.description,
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.w400,
                                                    color: textColor,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(
                                                    height: heigth * 0.01,
                                                  ),

                                                  Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/rate.svg",
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.01,
                                                          ),
                                                          DefaultText(
                                                            "${dataInter.rating}  ${"Rate".tr()}",
                                                            color: textColor,
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: width * 0.01,
                                                      ),
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/products_icons.svg",
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.01,
                                                          ),
                                                          DefaultText(
                                                            "${dataInter.productsCount}  ${"Products".tr()}",
                                                            color: textColor,
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: width * 0.01,
                                                      ),
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/coustamer.svg",
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.01,
                                                          ),
                                                          DefaultText(
                                                            "${dataInter.totalSales}  ${"Bayer".tr()}",
                                                            color: textColor,
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ],
                                                      ),

                                                      Expanded(
                                                        child: Transform(
                                                          alignment: Alignment.center,
                                                          transform: Matrix4.rotationY(getLang() == 'ar' ? 0 : pi),
                                                          child: Center(
                                                            child: SvgPicture.asset(
                                                              height: 15,
                                                              "assets/icons/mynaui_arrow-up-solid.svg",
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }),
                          ),
                        ),
                      ),
                    ],
                  )
                  : const SizedBox(),
        );
      },
    );
  }
}
