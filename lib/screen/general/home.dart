// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/home_notifire.dart';
import 'package:fils/screen/Buyer/home/home_buyer.dart';
import 'package:fils/screen/Buyer/home/item_auth_home.dart';
import 'package:fils/screen/Seller/home/home_seller.dart';

import 'package:fils/utils/animation/custom_fade_animation.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/widget/item_search.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../auth/login/screen/login_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeNotifire? homeNotifire;

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFadeAnimationComponent(
      1,
      ChangeNotifierProvider(
        create: (context) => HomeNotifire(),
        builder: (context, _) {
          homeNotifire = context.watch();
          return Stack(
            children: [
              Positioned(child: Image.asset("assets/icons/home_bar.png")),
              Scaffold(
                appBar: AppBar(
                  toolbarHeight: 0,

                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarIconBrightness: Brightness.light,
                    statusBarBrightness: Brightness.dark,
                    statusBarColor: Colors.transparent,
                  ),
                  backgroundColor: primaryDarkColor,
                ),
                backgroundColor: Colors.transparent,
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: heigth * 0.02),
                    isLogin()
                        ? authItem(homeNotifire, context)
                        : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: GestureDetector(
                            onTap: () {
                              ToWithFade(context, const LoginScreen());
                            },
                            child: SizedBox(
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: grey4,
                                    ),
                                    child: Icon(Icons.person, color: white),
                                  ),
                                  SizedBox(width: width * 0.02),
                                  DefaultText(
                                    "Login".tr(),
                                    color: getTheme() ? white : blackColor,
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                    isLogin()
                        ? getUser()!.user!.type != "customer"
                            ? const SizedBox()
                            : Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              child: ItemSearch(),
                            )
                        : const SizedBox(),

                    isLogin()
                        ? getUser()!.user!.type == "customer"
                            ? HomeBuyer(homeNotifire: homeNotifire!)
                            : HomeSeller()
                        : HomeBuyer(homeNotifire: homeNotifire!),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
