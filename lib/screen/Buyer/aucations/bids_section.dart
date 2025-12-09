// ignore_for_file: unused_local_variable

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/utils/strings_app.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/custom_validation.dart';
import 'package:fils/widget/defualt_text_form_faild.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/aucation_notifier.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/global_function/timer_format.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

class BidsSection extends StatefulWidget {
  final dynamic id;
  final String name;

  const BidsSection({super.key, required this.id, required this.name});

  @override
  State<BidsSection> createState() => _BidsSectionState();
}

class _BidsSectionState extends State<BidsSection> {
  final ScrollController _scrollController = ScrollController();
  double priceTotal = 0.0;

  @override
  void initState() {
    context.read<AuctionNotifier>().fetchBids(widget.id);

    super.initState();
    context.read<AuctionNotifier>().checkAuction(widget.id, widget.name);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final provider = Provider.of<AuctionNotifier>(context, listen: false);

    if (_scrollController.offset > 100 && !_scrollController.position.atEdge) {
      provider.setShowScrollDownButton(true);
    } else {
      provider.setShowScrollDownButton(false);
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuctionNotifier, AppNotifire>(
      builder: (context, bidsProvider, app, child) {
        if (bidsProvider.isLoading == true) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey,
              color: primaryColor,
            ),
          );
        }

        if (bidsProvider.errorMessage != null) {
          return Center(child: Text(bidsProvider.errorMessage!));
        }

        if (bidsProvider.bids.isEmpty) {
          return Center(child: DefaultText("No bids available".tr()));
        }

        return SafeArea(
          child: Stack(
            children: [
              Container(
                height: heigth * 0.4,
                color: Colors.transparent,
                child: SingleChildScrollView(
                  reverse: true,
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: bidsProvider.bids.length,
                    itemBuilder: (context, index) {
                      final bid = bidsProvider.bids[index];
                      String amount = bid.bid.customer_bid.toString();

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                /* CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    bid.bid.user.avatarOriginal,
                                  ),
                                ),*/
                                const SizedBox(width: 10),
                                DefaultText(
                                  bid.bid.user.name,
                                  color: const Color(0xff433E3F),
                                  fontWeight: FontWeight.w500,
                                ),
                                const Spacer(),
                                getUser()!.user!.type == "customer"
                                    ? bid.bid.user.id != getUser()!.user!.id
                                        ? GestureDetector(
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/icons/gift.svg",
                                            ),
                                          ),
                                          onTap: () async {
                                            if (getBalance() > 0) {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,

                                                builder: (context) {
                                                  return BottomSheetGift(
                                                    id_resever:
                                                        bid.bid.user.id
                                                            .toString(),
                                                    auction_id:
                                                        bid.productId
                                                            .toString(),
                                                  );
                                                },
                                              );
                                            } else {
                                              showCustomFlash(
                                                message:
                                                    "Please Charged Wallet"
                                                        .tr(),
                                                messageType: MessageType.Faild,
                                              );
                                            }
                                          },
                                        )
                                        : const SizedBox()
                                    : const SizedBox(),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: DefaultText(
                                "${app.currancy.tr()}  $amount",
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff433E3F),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                DefaultText(
                                  getTimeAgo(bid.bid.bidAt),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff726C6C),
                                ),
                                /* const SizedBox(width: 10),
                                getUser()!.user!.type == "customer"
                                    ? DefaultText(
                                        "Gift".tr(),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff726C6C),
                                      )
                                    : const SizedBox(),*/
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (bidsProvider.showScrollDownButton)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: _scrollToBottom,
                      icon: const Icon(
                        Icons.arrow_downward,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class BottomSheetGift extends StatefulWidget {
  final String id_resever;
  final String auction_id;

  const BottomSheetGift({
    super.key,
    required this.id_resever,
    required this.auction_id,
  });

  @override
  State<BottomSheetGift> createState() => _BottomSheetGiftState();
}

class _BottomSheetGiftState extends State<BottomSheetGift> {
  TextEditingController giftAmount = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuctionNotifier>(
      builder: (context, app, child) {
        return SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: heigth * 0.05, width: width),
                DefaultText(
                  "Enter the gift value".tr(),
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
                SizedBox(height: heigth * 0.1, width: width),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ValidateWidget(
                    validator: (value) {
                      if (giftAmount.text.isEmpty) {
                        return requiredField;
                      } else {
                        return null;
                      }
                    },
                    child: TextFormFieldWidget(
                      controller: giftAmount,
                      textInputType: TextInputType.number,
                      hintText: "Amount gift".tr(),
                      textInputAction: TextInputAction.send,
                      onTapDoneKey: (value) async {
                        if (_key.currentState!.validate()) {
                          await app.sendGift(
                            id_resever: widget.id_resever,
                            auction_id: widget.auction_id,
                            price: giftAmount.text,
                          );
                          giftAmount.clear();
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: heigth * 0.05, width: width),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ButtonWidget(
                    onTap: () async {
                      if (_key.currentState!.validate()) {
                        await app.sendGift(
                          id_resever: widget.id_resever,
                          auction_id: widget.auction_id,
                          price: giftAmount.text,
                        );
                        giftAmount.clear();
                        Navigator.pop(context);
                      }
                    },
                    title: "Send".tr(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
