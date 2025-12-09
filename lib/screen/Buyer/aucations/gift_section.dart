import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';

import 'package:flutter/material.dart';
import 'package:fils/controller/provider/aucation_notifier.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

class GiftSection extends StatefulWidget {
  final dynamic id;

  const GiftSection({super.key, required this.id});

  @override
  State<GiftSection> createState() => _GiftSectionState();
}

class _GiftSectionState extends State<GiftSection> {
  @override
  void initState() {
    context.read<AuctionNotifier>().fetchGift(widget.id);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuctionNotifier, AppNotifire>(
      builder: (context, bidsProvider, app, child) {
        if (bidsProvider.loadingGift == true) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey,
              color: primaryColor,
            ),
          );
        }

        if (bidsProvider.gifts.isEmpty) {
          return Center(child: DefaultText("No Gift available".tr()));
        }

        return ListView.builder(
          itemCount: bidsProvider.gifts.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Row(
                children: [
                  DefaultText(
                    "${bidsProvider.gifts[index]['message']} ${app.currancy.tr()} ${bidsProvider.gifts[index]['amount']}"
                        .tr(),
                    color: const Color(0xff433E3F),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      bidsProvider.acceptOrRejectGift(
                        idGift: bidsProvider.gifts[index]['gift_id'],
                        senderId: bidsProvider.gifts[index]['sender_id'],
                        type: 2,
                      );
                    },
                    child: Image.asset("assets/images/falseGift.png"),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      bidsProvider.acceptOrRejectGift(
                        idGift: bidsProvider.gifts[index]['gift_id'],
                        senderId: bidsProvider.gifts[index]['sender_id'],
                        type: 1,
                      );
                    },
                    child: Image.asset("assets/images/trueGift.png"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
