import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/aucation_notifier.dart';
import 'package:fils/model/response/details_auction.dart';
import 'package:fils/screen/Buyer/aucations/bids_section.dart';
import 'package:fils/screen/Buyer/aucations/room_auction.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/global_function/number_format.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/dialog_auth.dart';
import 'package:fils/widget/dialog_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class LiveWatchPage extends StatefulWidget {
  final String playbackUrl;
  final DetailsAuctionResponse detailsAuctionResponse;

  const LiveWatchPage({
    super.key,
    required this.playbackUrl,
    required this.detailsAuctionResponse,
  });

  @override
  _LiveWatchPageState createState() => _LiveWatchPageState();
}

class _LiveWatchPageState extends State<LiveWatchPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    print(widget.detailsAuctionResponse.data.channel!.playbackUrl!);
    super.initState();
    _controller = VideoPlayerController.network(
        widget.detailsAuctionResponse.data.channel!.playbackUrl!,
        formatHint: VideoFormat.hls,
      )
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextEditingController bidController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<AuctionNotifier>(
      builder: (context, app, child) {
        return Scaffold(
          body:
              _controller.value.isInitialized
                  ? Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _controller.value.size.width,
                            height: _controller.value.size.height,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: heigth * 0.07),
                        child: BidsSection(
                          id: widget.detailsAuctionResponse.data.id,
                          name: widget.detailsAuctionResponse.data.name,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: textColor)),
                        ),
                        child: TextFormField(
                          controller: bidController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Add bid ...".tr(),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.send, color: primaryColor),
                              onPressed: () {
                                sendPid(app);
                              },
                            ),
                          ),
                          textInputAction: TextInputAction.send,
                          onFieldSubmitted: (value) {
                            sendPid(app);
                          },
                        ),
                      ),
                      const GiftBoxOverlay(),
                    ],
                  )
                  : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  sendPid(AuctionNotifier app) {
    if (isLogin()) {
      if (bidController.text.isNotEmpty &&
          widget.detailsAuctionResponse.data.assuranceFee == 0) {
        double customerBid = double.parse(bidController.text);
        double amount = 0.0;
        if (app.bids.isNotEmpty) {
          amount = customerBid + app.totalPriceBid;
        } else {
          amount =
              customerBid +
              extractDouble(widget.detailsAuctionResponse.data.minBidPrice);
        }
        if (app.checkBid(double.parse(bidController.text))) {
          app.placePid(
            widget.detailsAuctionResponse.data.id,
            amount,
            customerBid,
          );
          bidController.clear();
        }
      } else {
        if (!widget.detailsAuctionResponse.data.isPaidAssuranceFee) {
          customDialog(
            context,
            title: "Insurance payment".tr(),
            titleButton: "Pay".tr(),
            body:
                "${"You must pay a deposit of ".tr()}${widget.detailsAuctionResponse.data.assuranceFee}${" KWD to be able to bid in this room.".tr()}",
            onTap: () async {
              Navigator.pop(context);
              Navigator.pop(context);
              app.payInsuranceBid(context, widget.detailsAuctionResponse);
            },
          );
        } else {
          double customerBid = double.parse(bidController.text);
          double amount = 0.0;
          if (app.bids.isNotEmpty) {
            amount = customerBid + app.totalPriceBid;
          } else {
            amount =
                customerBid +
                extractDouble(widget.detailsAuctionResponse.data.minBidPrice);
          }
          if (app.checkBid(double.parse(bidController.text))) {
            app.placePid(
              widget.detailsAuctionResponse.data.id,
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
