// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/aucation_notifier.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';

import 'package:fils/model/response/seller/auction_seller_response.dart';
import 'package:fils/screen/Buyer/aucations/bids_section.dart';
import 'package:fils/screen/Seller/control_auction/header_images_seller.dart';
import 'package:fils/screen/Seller/control_auction/item_timer_left_seller.dart';
import 'package:fils/screen/Seller/control_auction/timer_seller.dart';

import 'package:fils/utils/const.dart';

import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';

import 'package:provider/provider.dart';

class RoomAuctionSellerScreen extends StatefulWidget {
  final AuctionSeller detailsAuctionResponse;

  const RoomAuctionSellerScreen(
      {super.key, required this.detailsAuctionResponse});

  @override
  State<RoomAuctionSellerScreen> createState() =>
      _RoomAuctionSellerScreenState();
}

class _RoomAuctionSellerScreenState extends State<RoomAuctionSellerScreen> {
  TextEditingController bidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return Consumer2<AuctionNotifier , AppNotifire>(builder: (context, app,c, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderImagesSeller(data: widget.detailsAuctionResponse),
              SizedBox(height: heigth * 0.03),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DefaultText(
                      "Auction Name".tr(),
                      color: const Color(0xff433E3F),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    DefaultText(
                      widget.detailsAuctionResponse.name,
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              SizedBox(height: heigth * 0.03),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DefaultText(
                      "Initial price".tr(),
                      color: const Color(0xff433E3F),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    DefaultText(
                      widget.detailsAuctionResponse.mainPrice,
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              SizedBox(height: heigth * 0.03),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DefaultText(
                      "Auction time".tr(),
                      color: const Color(0xff433E3F),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    TimerSellerAuction(data: widget.detailsAuctionResponse),
                  ],
                ),
              ),
              SizedBox(height: heigth * 0.03),
              app.bids.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          DefaultText(
                            "Highest price".tr(),
                            color: const Color(0xff433E3F),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(width: 5),
                          DefaultText(
                            app.bids.last.bid.user.name,
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          const Spacer(),
                          DefaultText(
                            "${app.bids.last.bid.amount} ${c.currancy.tr()}",
                            color: const Color(0xffFE1515),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              SizedBox(height: heigth * 0.03),
              ItemTimerLeftSeller(data: widget.detailsAuctionResponse),
              SizedBox(height: heigth * 0.01),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DefaultText(
                      "Participants".tr(),
                      color: purpleColor,
                      fontSize: 18,
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.w600,
                    ),
                    widget.detailsAuctionResponse.auction_type == "live"
                        ? Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  app.startLive(
                                    context,
                                    idAuction: widget.detailsAuctionResponse.id,
                                    auctionName:
                                        widget.detailsAuctionResponse.name,
                                  );
                                },
                                child: DefaultText(
                                  "Live Room".tr(),
                                  color: primaryDarkColor,
                                  fontSize: 18,
                                  textAlign: TextAlign.start,
                                  textDecoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  app.startLive(
                                    context,
                                    idAuction: widget.detailsAuctionResponse.id,
                                    auctionName:
                                        widget.detailsAuctionResponse.name,
                                  );
                                },
                                icon: const Icon(
                                    Icons.video_camera_front_rounded),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              SizedBox(height: heigth * 0.03),
              BidsSection(
                id: widget.detailsAuctionResponse.id,
                name: widget.detailsAuctionResponse.name,
              ),
              SizedBox(height: heigth * 0.02),
            ],
          ),
        ),
      );
    });
  }
}
