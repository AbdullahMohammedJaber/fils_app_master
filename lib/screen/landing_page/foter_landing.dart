// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/landing_notifire.dart';
import 'package:fils/screen/landing_page/smoth_landing.dart';
import 'package:fils/screen/splash_screen/select_where_go.dart';

import 'package:fils/utils/const.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/flip_view.dart';

import 'package:fils/widget/defulat_text.dart';

import '../Buyer/root_app/root_app.dart';
import '../auth/login/screen/login_screen.dart';

class FooterLanding extends StatelessWidget {
  LandingPageNotifire? landingPageNotifire;

  FooterLanding({super.key, this.landingPageNotifire});

  @override
  Widget build(BuildContext context) {
    if (landingPageNotifire!.pageInit ==
        landingPageNotifire!.landingList.length - 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                setLanding(true);
                toRemoveAll(context, const LoginScreen());
              },
              child: Container(
                height: heigth * 0.07,
                width: width,
                decoration: BoxDecoration(
                  color: secondColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DefaultText(
                        "Get Started !".tr(),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: white,
                      ),
                      Center(
                        child: FlipView(
                          child: SvgPicture.asset("assets/icons/go.svg"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: heigth * 0.015),
            GestureDetector(
              onTap: () {
                setLanding(true);
                toRemoveAll(context, const SelectWhereGoScreen());
              },
              child: Container(
                height: heigth * 0.07,
                width: width,
                decoration: BoxDecoration(
                  color: white,
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      DefaultText(
                        "Login as a guest".tr(),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: heigth * 0.02),
          ],
        ),
      );
    } else {
      return Container(
        width: width,
        height: 100,
        color: Colors.transparent,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                setLanding(true);
                toRemoveAll(context, const RootAppByuerScreen());
              },
              child: SizedBox(
                height: 50,
                width: 50,
                child: Center(
                  child: DefaultText(
                    "Skip".tr(),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff898384),
                  ),
                ),
              ),
            ),
            smothLanding(
              length: landingPageNotifire!.landingList.length,
              page: landingPageNotifire!.pageInit,
            ),
            GestureDetector(
              onTap: () {
                landingPageNotifire!.nextPage();
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: secondColor,
                ),
                child: Center(
                  child: FlipView(
                    child: SvgPicture.asset("assets/icons/go.svg"),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
