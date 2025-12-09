import 'package:easy_localization/easy_localization.dart';
import 'package:fils/screen/Seller/control_auction/room_auction.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/aucation_notifier.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/model/response/seller/auction_seller_response.dart';
import 'package:fils/screen/Seller/control_auction/header_images_seller.dart';
import 'package:fils/screen/Seller/control_auction/item_timer_left_seller.dart';
import 'package:fils/utils/const.dart';

import 'package:fils/utils/global_function/timer_format.dart';

import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

import '../../../utils/route/route.dart';

class DetailsAuctionSeller extends StatelessWidget {
  final AuctionSeller data;

  const DetailsAuctionSeller({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return Consumer<AuctionNotifier>(builder: (context, controller, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              HeaderImagesSeller(data: data),
              SizedBox(height: heigth * 0.02),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 12),
                child: Row(
                  children: [
                    DefaultText(
                      data.name,
                      color: const Color(0xff5A5555),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.visible,
                    ),
                    const Spacer(),
                    Container(
                      height: 25,
                      decoration: BoxDecoration(
                        color: statusContainerColor(data.status),
                        borderRadius: const BorderRadiusDirectional.only(
                          topStart: Radius.circular(5),
                          bottomStart: Radius.circular(5),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Center(
                          child: DefaultText(
                            statusTitle(data.status),
                            color: statusColor(data.status),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: heigth * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    DefaultText(
                      "Price".tr(),
                      color: const Color(0xff5A5555),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    const Spacer(),
                    DefaultText(
                      data.mainPrice,
                      color: secondColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
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
                    SizedBox(
                      width: width,
                      child: DefaultText(
                        data.description,
                        fontSize: 10,
                        color: textColor,
                        overflow: TextOverflow.visible,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: heigth * 0.03),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: heigth * 0.09,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DefaultText(
                              "Seller".tr(),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                            const SizedBox(height: 8),
                            DefaultText(
                              getUser()!.user!.name,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: secondColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: heigth * 0.09,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DefaultText(
                              "Auction date".tr(),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                            const SizedBox(height: 8),
                            DefaultText(
                              formatDate(data.auctionEndDateString),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: secondColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: heigth * 0.03),
              ItemTimerLeftSeller(data: data),
              SizedBox(height: heigth * 0.03),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ButtonWidget(
                  title: "Enter the auction room".tr(),
                  colorButton:
                      data.status == "started" ? secondColor : textColor,
                  onTap: () async {
                    if (data.status == "started") {
                      ToRemove(
                          context,
                          RoomAuctionSellerScreen(
                              detailsAuctionResponse: data));
                    }
                  },
                ),
              ),
              SizedBox(height: heigth * 0.1),
            ],
          ),
        ),
      );
    });
  }

  String statusTitle(String status) {
    switch (status) {
      case "started":
        return "Current Auction".tr();
      case "coming":
        return "Coming Auction".tr();
      case "completed":
        return "Completed".tr();
      case "cancelled":
        return "Canceled".tr();
      default:
        return "";
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case "started":
        return primaryColor;
      case "coming":
        return purpleColor;
      case "completed":
        return const Color(0xff32D732);
      case "cancelled":
        return const Color(0xffE4626F);
      default:
        return primaryColor;
    }
  }

  Color statusContainerColor(String status) {
    switch (status) {
      case "started":
        return primaryColor.withOpacity(0.3);
      case "coming":
        return purpleColor.withOpacity(0.3);
      case "completed":
        return const Color(0xff32D732).withOpacity(0.3);
      case "cancelled":
        return const Color(0xffE4626F).withOpacity(0.3);
      default:
        return primaryColor;
    }
  }
}
