// ignore_for_file: unused_local_variable

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/screen/Buyer/aucations/live_room_buyer.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/model/response/details_auction.dart';

import 'package:fils/screen/Buyer/aucations/item_timer_left.dart';
import 'package:fils/screen/Buyer/aucations/room_auction.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';

import 'package:fils/utils/http/get_object_widget.dart';

import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/dialog_auth.dart';
import 'package:provider/provider.dart';

import '../../../utils/global_function/timer_format.dart';
import '../../../widget/defulat_text.dart';
import 'item_banner_details.dart';

class DetailsAuctions extends StatelessWidget {
  final dynamic slug;

  const DetailsAuctions({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, toolbarHeight: 0),
      body: CustomRequestWidget(
        parseResponse: (json) => DetailsAuctionResponse.fromJson(json),
        requestType: RequestType.get,
        buildResponse: (p0, p1) {
          DetailsAuctionResponse data = p1 as DetailsAuctionResponse;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ItemBannerDetailsAuction(data: data.data),
                SizedBox(height: heigth * 0.02),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 12),
                  child: Row(
                    children: [
                      DefaultText(
                        data.data.name,
                        color: const Color(0xff5A5555),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.visible,
                      ),
                      const Spacer(),
                      Container(
                        height: 25,
                        decoration: BoxDecoration(
                          color: statusContainerColor(data.data.status),
                          borderRadius: const BorderRadiusDirectional.only(
                            topStart: Radius.circular(5),
                            bottomStart: Radius.circular(5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Center(
                            child: DefaultText(
                              statusTitle(data.data.status),
                              color: statusColor(data.data.status),
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
                /*Padding(
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
                        data.data.startingBid,
                        color: secondColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),*/
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
                        width: width * 0.85,
                        child: DefaultText(
                          data.data.description,
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
                                data.data.shopName,
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
                                formatDate(data.data.auctionStartAt),
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
                ItemTimerLeft(data: data.data),
                SizedBox(height: heigth * 0.03),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset("assets/icons/notesBig.svg"),
                          const SizedBox(width: 10),
                          DefaultText(
                            "Note".tr(),
                            fontSize: 14,
                            color: const Color(0xff5A5555),
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      SizedBox(height: heigth * 0.01),
                      SizedBox(
                        width: width * 0.8,
                        child: DefaultText(
                          "The auction room will be opened when the time comes and you will be notified in the notifications."
                              .tr(),
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
                    children: [
                      data.data.auction_type == "live"
                          ? GestureDetector(
                            onTap: () async {
                              if (isLogin()) {
                                if (data.data.isLive == 1 ||
                                    data.data.isPaused == 1) {
                                  if (data.data.channel == null) {
                                    showCustomFlash(
                                      message: "Live Not Available".tr(),
                                      messageType: MessageType.Faild,
                                    );
                                  } else {
                                    ToWithFade(
                                      context,
                                      LiveWatchPage(
                                        playbackUrl:
                                            data.data.channel!.playbackUrl,
                                        detailsAuctionResponse: data,
                                      ),
                                    );
                                  }
                                } else {
                                  showCustomFlash(
                                    message: "Live Not Available".tr(),
                                    messageType: MessageType.Faild,
                                  );
                                }
                              } else {
                                showDialogAuth(context);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              width: width * 0.25,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(23),
                                color:
                                    data.data.status == "started"
                                        ? secondColor
                                        : const Color(0xff898384),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/icons/live.svg",
                                ),
                              ),
                            ),
                          )
                          : const SizedBox(),
                      Expanded(
                        child: ButtonWidget(
                          onTap: () {
                            if (isLogin()) {
                              if (data.data.status == "started" && isLogin()) {
                                ToRemove(
                                  context,
                                  RoomAuctionScreen(
                                    detailsAuctionResponse: data,
                                  ),
                                );
                              }
                            } else {
                              showDialogAuth(context);
                            }
                          },
                          colorButton:
                              data.data.status == "started"
                                  ? secondColor
                                  : const Color(0xff898384),
                          heightButton: 50,
                          radius: 23,
                          title: "Enter the auction room".tr(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: heigth * 0.03),
              ],
            ),
          );
        },
        url: "auction/products/$slug?is_auction=1",
      ),
    );
  }

  String statusTitle(String status) {
    switch (status) {
      case "started":
        return "Current Auction".tr();
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
      case "completed":
        return const Color(0xff32D732).withOpacity(0.3);
      case "cancelled":
        return const Color(0xffE4626F).withOpacity(0.3);
      default:
        return primaryColor;
    }
  }
}
