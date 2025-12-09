import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/controller/provider/aucation_notifier.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/global_function/timer_format.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BidsSectionSeller extends StatefulWidget {
  final dynamic id;
  final String name;

  const BidsSectionSeller({super.key, required this.id, required this.name});

  @override
  State<BidsSectionSeller> createState() => _BidsSectionSellerState();
}

class _BidsSectionSellerState extends State<BidsSectionSeller> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    context.read<AuctionNotifier>().fetchBids(widget.id);

    super.initState();
    context.read<AuctionNotifier>().checkAuction(
          widget.id,
          widget.name,
        );
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
          return Center(
            child: DefaultText(
              "No bids available".tr(),
              color: blackColor,
            ),
          );
        }

        return Stack(
          children: [
            Container(
              height: heigth * 0.3,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                reverse: true,
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: ListView.builder(
                  reverse: false,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: bidsProvider.bids.length,
                  itemBuilder: (context, index) {
                    final bid = bidsProvider.bids[index];
                    String amount = bid.bid.customer_bid.toString();
                    dynamic date = bid.bid.bidAt;


                    return FadeTransition(
                      opacity: const AlwaysStoppedAnimation(1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(bid.bid.user.avatarOriginal),
                                ),
                                const SizedBox(width: 10),
                                DefaultText(
                                  bid.bid.user.name,
                                  color: white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: DefaultText(
                                "$amount ${app.currancy.tr()}",
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                DefaultText(
                                  getTimeAgo(date),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff726C6C),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                      borderRadius: BorderRadius.circular(50)),
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
        );
      },
    );
  }
}
