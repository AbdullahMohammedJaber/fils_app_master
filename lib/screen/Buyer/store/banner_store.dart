import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/flip_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/storage/storage.dart';

class BannerStore extends StatelessWidget {
  final Function() onClick;

  const BannerStore({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: width,
      margin: EdgeInsets.only(top: 5, bottom: 5, right: 12, left: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.purpleAccent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              SizedBox(width: width * 0.25),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultText(
                      "Shop now and experience smart shopping!".tr(),
                      fontSize: 14,
                      color: white,
                      overflow: TextOverflow.visible,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: heigth * 0.02),
                    DefaultText(
                      "Try a shopping experience that combines quality and the right price!".tr(),
                      fontSize: 8,
                      color: white,
                      overflow: TextOverflow.visible,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: heigth * 0.02),
                    GestureDetector(
                      onTap: onClick,
                      child: Container(
                        height: heigth * 0.07,
                        width: width * 0.35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xff039DF0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DefaultText(
                              'Start Shops'.tr(),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: white,
                            ),
                            SizedBox(width: 10),
                            Center(
                              child: FlipView(
                                child: SvgPicture.asset(
                                  "assets/icons/go.svg",
                                  height: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,

            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(getLang() == 'ar' ? 0 : pi),
              child: IgnorePointer(
                child: Image.asset("assets/icons/cover_store.png"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
