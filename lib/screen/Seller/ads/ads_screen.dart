import 'package:fils/controller/provider/ads_controller.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/screen/Seller/control_product/product_seller.dart';

import 'package:fils/utils/route/route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';

import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/item_back.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../model/response/seller/ads_response.dart';
import '../../../utils/enum/place_ads.dart';
import '../../../utils/http/get_object_widget.dart';

import '../../../widget/button_widget.dart';
import '../control_auction/auction_seller_screen.dart';

class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  @override
  Widget build(BuildContext ctx) {
    return ChangeNotifierProvider(
      create: (context) => AdsNotifire(),
      child: Consumer2<AppNotifire, AdsNotifire>(
        builder: (context, value, ads, child) {
          return Scaffold(
            appBar: AppBar(automaticallyImplyLeading: false, toolbarHeight: 0),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  SizedBox(height: heigth * 0.06),
                  itemBackAndTitle(ctx, title: "Sponsored ads".tr()),

                  SizedBox(height: heigth * 0.03, width: width),
                  Row(
                    children: [
                      DefaultText(
                        "Let's boost your business visibility".tr(),
                        color: textColor,
                        overflow: TextOverflow.visible,
                        fontSize: 14,

                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  SizedBox(height: heigth * 0.03, width: width),

                  SizedBox(
                    width: width * 0.6,
                    child: DefaultText(
                      "Choose the advertising package that best fits your business needs and reach more customers effectively."
                          .tr(),
                      color: const Color(0xff5A5555),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      fontSize: 14,

                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: heigth * 0.01, width: width),

                  Expanded(
                    child: CustomRequestWidget(
                      url: "ads-area/list",
                      requestType: RequestType.get,
                      parseResponse: (json) => AdsResponse.fromJson(json),
                      buildResponse: (ctx2, item) {
                        return ListView(
                          children:
                              item!.data!.map((e) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      e.isSelect = !e.isSelect;
                                    });
                                  },
                                  child: Container(
                                    height: e.isSelect ? null : heigth * 0.10,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: textColor),
                                    ),
                                    child:
                                        e.isSelect
                                            ? selectedAdsWidget(e, ctx)
                                            : NotSelectWidget(e: e),
                                  ),
                                );
                              }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  selectedAdsWidget(Datum e, BuildContext ctx) {
    return Consumer<AdsNotifire>(
      builder: (context, ads, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  DefaultText(
                    e.name,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  const Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DefaultText(
                        e.pricePerDay,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                      const SizedBox(height: 5),
                      DefaultText(
                        "KWD",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,

                        color: primaryColor,
                      ),
                      const SizedBox(height: 5),

                      SvgPicture.asset("assets/icons/drob.svg"),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: textColor),
            Container(
              height: 55,
              width: width * 0.43,
              decoration: BoxDecoration(
                color: secondColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: DefaultText(
                  // ignore: prefer_interpolation_to_compose_strings
                  " KWD ".tr() + e.pricePerDay,
                  color: white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DefaultText(
                        "* Place : ".tr(),
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      DefaultText(handleAdPlacement(place: e.place!)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DefaultText(
                        "* Number of ads currently available : ".tr(),
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      DefaultText("${e.maxSlots} ${"Ads".tr()}"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DefaultText(
                        "* Price Ads : ".tr(),
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      DefaultText("${e.pricePerDay} KWD"),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DefaultText(
                        "* Count Day : ".tr(),
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ],
                  ),
                  countDayWidget(e),
                  e.auctionId == null
                      ? Row(
                        children: [
                          TextButton(
                            onPressed: () async {
                              selectProductForAds(e, ctx);
                            },
                            child: DefaultText(
                              e.productId == null
                                  ? "Select Product For Ads".tr()
                                  : "${e.productName}",
                              textDecoration: TextDecoration.underline,
                            ),
                          ),
                          e.productId != null?
                          IconButton(
                            onPressed: () {
                              e.productId = null;
                              e.productName = null;
                              setState(() {});
                            },
                            icon: Icon(Icons.delete),
                          ) : SizedBox(),
                        ],
                      )
                      : SizedBox(),
                  e.productId == null
                      ? Row(
                        children: [
                          TextButton(
                            onPressed: () async {
                              selectProductForAds(e, ctx);
                            },
                            child: DefaultText(
                              e.productId == null
                                  ? "Select auction For Ads".tr()
                                  : "${e.productName}",
                              textDecoration: TextDecoration.underline,
                            ),
                          ),
                          e.auctionId != null?
                          IconButton(
                            onPressed: () {
                              e.auctionId = null;
                              e.auctionName = null;
                              setState(() {});
                            },
                            icon: Icon(Icons.delete),
                          ) : SizedBox(),
                        ],
                      )
                      : SizedBox(),
                ],
              ),
            ),

            TextButton(
              onPressed: () async {
                await ads.selectAndUploadImage();
                e.urlImage = ads.imageFile;
                e.idImage = ads.idImage;
              },
              child: DefaultText(
                "Select Custom Image".tr(),
                fontWeight: FontWeight.bold,
                textDecoration: TextDecoration.underline,
              ),
            ),
            if (e.urlImage != null)
              Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SizedBox(
                      height: 150,
                      child: Image.file(e.urlImage!),
                    ),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: ButtonWidget(
                onTap: () async {
                  ads.subscribeAds(e, ctx);
                },
                title: "Subscribe".tr(),
                colorButton: primaryColor,
              ),
            ),
          ],
        );
      },
    );
  }

  Row countDayWidget(Datum e) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            plusCountDay(e);
          },
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: textColor),
            ),
            child: Center(
              child: DefaultText(
                "+",
                fontSize: 25,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Container(
          height: 50,
          width: 50,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: purpleColor
            // ignore: deprecated_member_use
            .withOpacity(0.5),
            border: Border.all(color: purpleColor),
          ),
          child: Center(
            child: DefaultText(
              e.countDay.toString(),
              color: blackColor,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            minusCountDay(e);
          },
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: textColor),
            ),
            child: Center(
              child: DefaultText(
                "-",
                fontSize: 25,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Count Day +
  plusCountDay(Datum e) {
    e.countDay++;
    setState(() {});
  }

  minusCountDay(Datum e) {
    if (e.countDay != 1) {
      e.countDay--;
      setState(() {});
    }
  }

  Future<void> selectProductForAds(Datum e, BuildContext ctx) async {
    Map<String, dynamic> product = await ToWithFade(
      ctx,
      const ProductSellerScreen(isAds: true),
    );
    if (product['id'] != null) {
      if (kDebugMode) {
        print("id :: ${product['id']}");
      }
      setState(() {
        e.productId = product['id'];
        e.productName = product['name'];
      });
    }
  }

  Future<void> selectAuctionForAds(Datum e, BuildContext ctx) async {
    Map<String, dynamic> product = await ToWithFade(
      ctx,
      const AuctionSellerScreen(isAds: true),
    );
    if (product['id'] != null) {
      if (kDebugMode) {
        print("id :: ${product['id']}");
      }
      setState(() {
        e.auctionId = product['id'];
        e.auctionName = product['name'];
      });
    }
  }
}

class NotSelectWidget extends StatelessWidget {
  final Datum e;

  const NotSelectWidget({super.key, required this.e});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          DefaultText(
            e.name,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DefaultText(
                e.pricePerDay,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
              const SizedBox(height: 5),
              DefaultText(
                "KWD",
                fontSize: 16,
                fontWeight: FontWeight.w600,

                color: primaryColor,
              ),
              const SizedBox(height: 5),

              SvgPicture.asset("assets/icons/drob.svg"),
            ],
          ),
        ],
      ),
    );
  }
}
