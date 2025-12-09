// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/controller/provider/landing_notifire.dart';

import 'package:fils/utils/const.dart';
import 'package:fils/widget/flip_view.dart';
import 'package:provider/provider.dart';

import 'item_landing.dart';

class LandingPageScreen extends StatelessWidget {
  LandingPageScreen({super.key});

  LandingPageNotifire? landingPageNotifire;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return ChangeNotifierProvider(
      create: (context) => LandingPageNotifire(),
      builder: (context, _) {
        landingPageNotifire = context.watch();

        return SafeArea(
          child: Column(
            children: [
              SizedBox(height: heigth * 0.04),
              landingPageNotifire!.pageInit != 0
                  ? Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          landingPageNotifire!.backPage();
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          color: Colors.transparent,
                          child: FlipView(
                            child: Center(
                              child: SvgPicture.asset("assets/icons/back.svg"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                  : const SizedBox(width: 45, height: 45),
              Expanded(
                child: PageView(
                  onPageChanged: (index) {
                    landingPageNotifire!.onPageChange(index);
                  },
                  physics: const BouncingScrollPhysics(),
                  reverse: false,
                  scrollDirection: Axis.horizontal,
                  controller: landingPageNotifire!.pageController,
                  children:
                      landingPageNotifire!.landingList
                          .map(
                            (e) => ItemLanding(
                              e: e,
                              landingPageNotifire: landingPageNotifire,
                            ),
                          )
                          .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
