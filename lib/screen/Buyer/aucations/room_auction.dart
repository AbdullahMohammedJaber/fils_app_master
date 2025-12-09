// ignore_for_file: prefer_interpolation_to_compose_strings, must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/utils/global_function/number_format.dart';
import 'package:fils/utils/strings_app.dart';
import 'package:fils/widget/dialog_custom.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/aucation_notifier.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';

import 'package:fils/model/response/details_auction.dart';
import 'package:fils/screen/Buyer/aucations/bids_section.dart';
import 'package:fils/screen/Buyer/aucations/gift_section.dart';
import 'package:fils/screen/Buyer/aucations/item_banner_details.dart';
import 'package:fils/screen/Buyer/aucations/item_timer_left.dart';
import 'package:fils/screen/Buyer/aucations/timer_auction.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/dialog_auth.dart';
import 'package:provider/provider.dart';

class RoomAuctionScreen extends StatefulWidget {
  DetailsAuctionResponse detailsAuctionResponse;

  RoomAuctionScreen({super.key, required this.detailsAuctionResponse});

  @override
  State<RoomAuctionScreen> createState() => _RoomAuctionScreenState();
}

class _RoomAuctionScreenState extends State<RoomAuctionScreen> {
  TextEditingController bidController = TextEditingController();
  final key = GlobalKey<FormState>();

  @override
  void initState() {
    Provider.of<AuctionNotifier>(
      context,
      listen: false,
    ).changeDetailsAuctionResponse(widget.detailsAuctionResponse);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return Consumer2<AuctionNotifier, AppNotifire>(
      builder: (context, app, c, child) {
        return Scaffold(
          appBar: AppBar(automaticallyImplyLeading: false, toolbarHeight: 0),
          body: Form(
            key: key,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ItemBannerDetailsAuction(
                        data: app.detailsAuctionResponse.data,
                      ),
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
                              app.detailsAuctionResponse.data.name,
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
                            TimerAuction(data: app.detailsAuctionResponse.data),
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
                            const Spacer(),
                            DefaultText(
                              "${c.currancy.tr()} ${app.totalPriceBid}",
                              color: const Color(0xffFE1515),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      )
                          : const SizedBox(),
                      SizedBox(height: heigth * 0.03),
                      GiftSection(id: app.detailsAuctionResponse.data.id),
                      SizedBox(height: heigth * 0.03),
                      ItemTimerLeft(data: app.detailsAuctionResponse.data),
                      SizedBox(height: heigth * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DefaultText(
                          "Participants".tr(),
                          color: purpleColor,
                          fontSize: 18,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: heigth * 0.05),
                      BidsSection(
                        id: app.detailsAuctionResponse.data.id,
                        name: app.detailsAuctionResponse.data.name,
                      ),
                      const SizedBox(height: 2),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: textColor)),
                        ),
                        child: TextFormField(
                          controller: bidController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (bidController.text.isEmpty || value!.isEmpty) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Add bid ...".tr(),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.send, color: primaryColor),
                              onPressed: () {
                                if (key.currentState!.validate()) {
                                  sendPid(app);
                                }
                              },
                            ),
                          ),
                          textInputAction: TextInputAction.send,
                          onFieldSubmitted: (value) {
                            if (key.currentState!.validate()) {
                              sendPid(app);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const GiftBoxOverlay(),
                /*   if (app.showGiftBox)
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.orangeAccent,
                    child: Text(
                      '🎁 لديك هدية جديدة!',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        );
      },
    );
  }

  sendPid(AuctionNotifier app) {
    if (isLogin()) {
      if (bidController.text.isNotEmpty &&
          app.detailsAuctionResponse.data.assuranceFee == 0) {
        double customerBid = extractDouble(bidController.text);
        double amount = 0.0;
        if (app.bids.isNotEmpty) {
          amount = customerBid + app.totalPriceBid;
        } else {
          amount =
              customerBid +
                  extractDouble(app.detailsAuctionResponse.data.minBidPrice);
        }
        if (app.checkBid(extractDouble(bidController.text))) {
          app.placePid(app.detailsAuctionResponse.data.id, amount, customerBid);
          bidController.clear();
        }
      } else {
        if (!app.detailsAuctionResponse.data.isPaidAssuranceFee) {
          customDialog(
            context,
            title: "Insurance payment".tr(),
            titleButton: "Pay".tr(),
            body:
            "You must pay a deposit of ".tr() +
                "${app.detailsAuctionResponse.data.assuranceFee}" +
                " KWD to be able to bid in this room.".tr(),
            onTap: () async {
              Navigator.pop(context);
              app.payInsuranceBid(context, app.detailsAuctionResponse);
            },
          );
        } else {
          double customerBid = extractDouble(bidController.text);
          double amount = 0.0;
          if (app.bids.isNotEmpty) {
            amount = customerBid + app.totalPriceBid;
          } else {
            amount =
                customerBid +
                    extractDouble(app.detailsAuctionResponse.data.minBidPrice);
          }
          if (app.checkBid(extractDouble(bidController.text))) {
            app.placePid(
              app.detailsAuctionResponse.data.id,
              amount,
              customerBid,
            );
            bidController.clear();
          }
        }
      }
    } else {
      showDialogAuth(context);
    }
  }
}

class GiftBoxOverlay extends StatelessWidget {
  const GiftBoxOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuctionNotifier, AppNotifire>(
      builder: (context, provider, app, child) {
        if (!provider.showGiftBox) return const SizedBox.shrink();

        return Center(
          child: AnimatedScale(
            scale: 1.0,
            duration: const Duration(milliseconds: 500),
            child: Container(
              width: width * 0.9,
              height: 200,
              decoration: BoxDecoration(
                color: primaryDarkColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(blurRadius: 10, color: Colors.black26),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          provider.closeGiftBox();
                        },
                        icon: Icon(Icons.close, color: white),
                      ),
                    ],
                  ),
                  Image.asset("assets/icons/box_gift.png"),
                  const SizedBox(height: 10),
                  DefaultText(
                    "${provider.messageNewGift} ${app.currancy.tr()} ${provider
                        .amountNewGift}",
                    color: white,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
