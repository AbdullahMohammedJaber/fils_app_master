// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';

import '../../../controller/provider/landing_notifire.dart';
import 'foter_landing.dart';

class ItemLanding extends StatelessWidget {
  Map<String, dynamic>? e;
  LandingPageNotifire? landingPageNotifire;

  ItemLanding({super.key, this.e, this.landingPageNotifire});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: heigth * 0.05),
          CachedNetworkImage(
            imageUrl: e!["image"],
            fit: BoxFit.cover,
            placeholder: (context, url) => const LoadingWidgetImage(),
            errorWidget: (context, url, error) => Image.asset(
              "assets/images/landing1.png",
              fit: BoxFit.cover,
              height: heigth * 0.3,
            ),
            height: heigth * 0.3,
          ),
          SizedBox(height: heigth * 0.03),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      DefaultText(
                        e!["title"],
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: heigth * 0.01),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DefaultText(
                    e!["des"],
                    color: grey,
                    overflow: TextOverflow.visible,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          FooterLanding(landingPageNotifire: landingPageNotifire),
        ],
      ),
    );
  }
}
