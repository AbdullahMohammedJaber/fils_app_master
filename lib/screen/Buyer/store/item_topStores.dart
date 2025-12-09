// ignore_for_file: file_names, must_be_immutable

import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/store_notofire.dart';
import 'package:fils/screen/Buyer/product/product_into_store.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';

import '../../../model/response/item_store.dart';

class ItemTopStores extends StatelessWidget {
  StoreNotifire? storeNotifire;

  List<TopStoresDatum>? storeList;

  ItemTopStores({super.key, this.storeNotifire, required this.storeList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          const SizedBox(),
          SizedBox(height: heigth * 0.02),
          SizedBox(
            width: width,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  storeList!.length,
                  (index) =>
                      storeList![index].logo == null
                          ? const SizedBox()
                          :   Padding(
                padding: EdgeInsetsDirectional.only(end: width * 0.01),
                child: GestureDetector(
                  onTap: () {
                    ToWithFade(
                      context,
                      ProductsIntoStoreScreen(
                        idStore: storeList![index].id,
                        nameStore: storeList![index].name!,
                        address: storeList![index].address,
                      ),
                    );
                  },
                  child: Card(
                    elevation: 1,
                    color: getTheme() ? Colors.black : white,
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: white),
                      ),
                      child: Row(
                        children: [
                          SizedBox(height: heigth * 0.02),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                storeList![index].logo!,
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
                                  storeList![index].name,
                                  color:
                                  getTheme() ? white : Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(height: heigth * 0.01),
                                DefaultText(
                                  storeList![index].description,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w400,
                                  color: textColor,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: heigth * 0.01),

                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/rate.svg",
                                        ),
                                        SizedBox(width: width * 0.01),
                                        DefaultText(
                                          "${storeList![index].rating}  ${"Rate".tr()}",
                                          color: textColor,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: width * 0.01),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/products_icons.svg",
                                        ),
                                        SizedBox(width: width * 0.01),
                                        DefaultText(
                                          "${storeList![index].productsCount}  ${"Products".tr()}",
                                          color: textColor,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: width * 0.01),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/coustamer.svg",
                                        ),
                                        SizedBox(width: width * 0.01),
                                        DefaultText(
                                          "${storeList![index].totalSales}  ${"Bayer".tr()}",
                                          color: textColor,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w600,
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
              ),
                ),
              ),
            ),
          ),
          /* ...List.generate(storeList!.length, (index) {
            return GestureDetector(
              onTap: () {
                ToWithFade(
                    context,
                    ProductsIntoStoreScreen(
                      idStore: storeList![index].id,
                      nameStore:storeList![index].name! ,
                      address: storeList![index].address ,
                    ));
              },
              child: Container(
                height: heigth * 0.120,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * 0.17,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: storeList![index].logo == null
                              ? Image.asset(
                                  "assets/images/logo_png.png",
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  imageUrl: storeList![index].logo!,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    "assets/images/logo_png.png",
                                    fit: BoxFit.cover,
                                  ),
                                  placeholder: (context, url) =>
                                      const LoadingWidgetImage(),
                                ),
                        ),
                      ),
                      SizedBox(width: width * 0.02),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                DefaultText(
                                  storeList![index].name,
                                  color: blackColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                                const Spacer(),
                                // SizedBox(
                                //   height: 35,
                                //   width: 35,
                                //   child: Center(
                                //     child: SvgPicture.asset(
                                //         "assets/icons/favourite_home.svg"),
                                //   ),
                                // ),
                              ],
                            ),
                            DefaultText(
                              storeList![index].slug,
                              color: textColor,
                              fontSize: 8,
                              fontWeight: FontWeight.w400,
                            ),
                            SizedBox(height: heigth * 0.01),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/rate.svg",
                                    ),
                                    SizedBox(width: width * 0.01),
                                    DefaultText(
                                      "${storeList![index].rating}  "
                                              "Rate"
                                          .tr(),
                                      color: textColor,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                                SizedBox(width: width * 0.03),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/products_icons.svg",
                                    ),
                                    SizedBox(width: width * 0.01),
                                    DefaultText(
                                      "${storeList![index].productsCount}  "
                                              "Products"
                                          .tr(),
                                      color: textColor,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                                SizedBox(width: width * 0.03),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/coustamer.svg",
                                    ),
                                    SizedBox(width: width * 0.01),
                                    DefaultText(
                                      "${storeList![index].totalSales}  "
                                              "Bayer"
                                          .tr(),
                                      color: textColor,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
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
            );
          })*/
        ],
      ),
    );
  }
}
