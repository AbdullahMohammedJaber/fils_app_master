// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:fils/controller/provider/user_notefire.dart';
import 'package:fils/screen/Buyer/OpenMarket/User_Classifed_Products/screen/all_product-in_market_open.dart';
import 'package:fils/screen/auth/signup/screen/signup_screen.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/dialog_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/controller/provider/home_notifire.dart';
import 'package:fils/screen/Buyer/aucations/auction_screen.dart';
import 'package:fils/screen/Buyer/video/show_reel.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../splash_screen/splash_screen.dart';
import '../store/store_screen.dart';
import 'create_web.dart';
import 'dialog_create_store.dart';

class ItemCategoryHome extends StatefulWidget {
  HomeNotifire? homeNotifire;
  GlobalKey? keyG;
  ItemCategoryHome({super.key, this.homeNotifire , this.keyG});

  @override
  State<ItemCategoryHome> createState() => _ItemCategoryHomeState();
}

class _ItemCategoryHomeState extends State<ItemCategoryHome> {
  late List<GlobalKey> showcaseKeys;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showcaseKeys = List.generate(lista.length, (index) => GlobalKey());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bool isDone = getShowCaseHomeB();

      if (isDone) {
        ShowCaseWidget.of(context).startShowCase(showcaseKeys);
      }
    });
  }

  List<CustomButton> lista = [
    CustomButton(
      label: 'Reels'.tr(),
      color: moveH,
      path: "assets/images/reel.png",
      dec:
          "The Reels section allows you to view the latest reels and product advertisements."
              .tr(),
    ),
    CustomButton(
      label: 'Online store'.tr(),
      color: orangeH,
      path: "assets/images/market.png",
      dec:
          "In the Market section, when you access it, you will find all the active stores within the application and shop from them easily."
              .tr(),
    ),
    CustomButton(
      label: 'Public auctions'.tr(),
      color: zaherH,
      path: "assets/images/auction.png",
      dec:
          "In the auction section, once you access it, you will find all the auctions and enjoy a distinctive, interactive, and secure bidding service."
              .tr(),
    ),
    CustomButton(
      label: 'Open Market'.tr(),
      color: kohliH,
      path: "assets/images/haraj.png",
      dec:
          "In the used goods section, you will find all used products, and you can purchase them by contacting the seller."
              .tr(),
    ),
    CustomButton(
      label: 'Create Web'.tr(),
      color: blueH,
      path: "assets/images/c_web.png",
      dec: "You can create your own website from here".tr(),
    ),
    CustomButton(
      label: 'Create store'.tr(),
      color: nahdiH,
      path: "assets/images/c_store.png",
      dec:
          "You can create your own store in the app and become a seller, enjoying the features and benefits."
              .tr(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: widget.keyG,
      padding: const EdgeInsetsDirectional.only(start: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultText(
            "Sections".tr(),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: getTheme() ? white : blackColor,
          ),
          SizedBox(height: heigth * 0.02),
          Container(
            alignment: AlignmentDirectional.centerStart,
            child: GridView.builder(

              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // عدد العناصر في كل صف
                mainAxisSpacing: 5, // المسافة بين الصفوف
                crossAxisSpacing: 5, // المسافة بين الأعمدة
                childAspectRatio: 2 / 3, // نسبة عرض إلى ارتفاع العنصر
              ),
              itemCount: lista.length,
              itemBuilder: (context, index) {
                return Showcase(
                  key: showcaseKeys[index],
                  title: lista[index].label,
                  description: lista[index].dec,
                  overlayOpacity: 0.7,
                  descriptionAlignment: Alignment.center,
                  scaleAnimationAlignment: Alignment.topCenter,
                  tooltipPosition: TooltipPosition.right,
                  showArrow: false,
                  tooltipActions: [
                    TooltipActionButton(
                      type: TooltipDefaultActionType.next,
                      backgroundColor: primaryColor,
                      name: "Next".tr(),
                      onTap: () {
                        ShowCaseWidget.of(context).next();
                        setShowCaseHomeB(true);
                      },
                      textStyle: TextStyle(color: white, fontFamily: "Almarai"),
                    ),
                    TooltipActionButton(
                      type: TooltipDefaultActionType.skip,
                      backgroundColor: error,
                      name: "Skip".tr(),
                      onTap: () {
                        ShowCaseWidget.of(context).dismiss();
                        setShowCaseHomeB(true);
                      },
                      textStyle: TextStyle(color: white, fontFamily: "Almarai"),
                    ),
                  ],
                  onToolTipClick: () {
                    ShowCaseWidget.of(context).next();
                    setShowCaseHomeB(true);
                  },
                  child: GestureDetector(
                    onTap: () async {
                      if (index == 0) {
                        ToWithFade(context, const ReelsScreen());
                      } else if (index == 1) {
                        ToWithFade(context, StoreScreen());
                      } else if (index == 2) {
                        ToWithFade(context, const AuctionScreen());
                      } else if (index == 3) {
                        if (isLogin()) {
                          ToWithFade(context, const AllProductInMarketOpen());
                        } else {
                          showDialogAuth(context);
                        }
                      } else if (index == 4) {
                        ToWithFade(context, CreateWebScreen());
                      } else if (index == 5) {
                        if (isLogin()) {
                          if (getUser()!.user!.can_switch_between_accounts) {
                            switchAccount(
                              context,
                              getUser()!.user!.type == "seller"
                                  ? "customer"
                                  : "seller",
                            );
                          } else {
                            showStoreLoginDialog(context);
                          }
                        } else {
                          showDialogAuth(context);
                        }
                      }
                    },
                    child: CustomButton(
                      label: lista[index].label,
                      color: lista[index].color,
                      path: lista[index].path,
                      dec: lista[index].dec,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String? label;
  final Color? color;
  final String? path;
  final String? dec;

  const CustomButton({
    super.key,
    required this.label,
    required this.color,
    required this.path,
    required this.dec,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color!, white, white],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08), // لون الظل الفاتح
                blurRadius: 8, // مدى انتشار الظل
                offset: const Offset(0, 3), // اتجاه الظل للأسفل قليلاً
              ),
            ],
          ),
          child: Center(
            child:
                path!.endsWith('.png')
                    ? Image.asset(path!, height: 30)
                    : SvgPicture.asset(path!, height: 30),
          ),
        ),
        const SizedBox(height: 10),
        DefaultText(label!),
      ],
    );
  }
}
