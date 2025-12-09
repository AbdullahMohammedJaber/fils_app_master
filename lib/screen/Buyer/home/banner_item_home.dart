import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/home_notifire.dart';
import 'package:fils/model/response/home_response.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';

class BannerHomeItem extends StatefulWidget {
  final HomeNotifire? homeNotifire;
  final HomeResponse? data;

  const BannerHomeItem({
    super.key,
    required this.homeNotifire,
    required this.data,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BannerHomeItemState createState() => _BannerHomeItemState();
}

class _BannerHomeItemState extends State<BannerHomeItem> {
  late AuctionEndDate remainingTime;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    remainingTime = widget.data!.data!.latestAuction!.auctionPeriod;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_hasTimeLeft()) {
          _decrementTime();
        } else {
          timer.cancel();
        }
      });
    });
  }

  bool _hasTimeLeft() {
    return remainingTime.days > 0 ||
        remainingTime.hours > 0 ||
        remainingTime.minutes > 0 ||
        remainingTime.seconds > 0;
  }

  void _decrementTime() {
    if (remainingTime.seconds > 0) {
      remainingTime.seconds--;
    } else {
      remainingTime.seconds = 59;
      if (remainingTime.minutes > 0) {
        remainingTime.minutes--;
      } else {
        remainingTime.minutes = 59;
        if (remainingTime.hours > 0) {
          remainingTime.hours--;
        } else {
          remainingTime.hours = 23;
          if (remainingTime.days > 0) {
            remainingTime.days--;
          }
        }
      }
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: width * 0.01),
                DefaultText(
                  widget.data!.data!.latestAuction!.name,
                  fontSize: 16,
                  type: FontType.bold,
                  color: secondColor,
                ),
                SizedBox(width: width * 0.01),
                DefaultText(
                  widget.data!.data!.latestAuction!.slug,
                  overflow: TextOverflow.visible,
                  color: textColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: heigth * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTimeUnit(remainingTime.days, "Days".tr()),
                    _buildColon(),
                    _buildTimeUnit(remainingTime.hours, "Hours".tr()),
                    _buildColon(),
                    _buildTimeUnit(remainingTime.minutes, "Minute".tr()),
                    _buildColon(),
                    _buildTimeUnit(remainingTime.seconds, "Second".tr()),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          CachedNetworkImage(
            imageUrl: widget.data!.data!.latestAuction!.thumbnailImage,
            height: 100,
            width: 100,
            placeholder: (context, url) => const LoadingWidgetImage(),
            errorWidget:
                (context, url, error) =>
                    SvgPicture.asset("assets/test/banners.svg"),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(dynamic value, String label) {
    return Column(
      children: [
        itemCounter(title: value),
        SizedBox(height: heigth * 0.005),
        DefaultText(
          label.tr(),
          fontSize: 6,
          color: textColor,
          type: FontType.medium,
        ),
      ],
    );
  }

  Widget _buildColon() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
      child: DefaultText(
        ":",
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: blackColor,
      ),
    );
  }

  Widget itemCounter({dynamic title}) {
    return Container(
      height: heigth * 0.06,
      width: width * 0.08,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xff522BAD), Color(0xffBA27B7)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: DefaultText(
          title.toString(),
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: white,
        ),
      ),
    );
  }
}
