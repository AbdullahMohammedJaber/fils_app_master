import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:fils/model/response/seller/subscribe_response.dart';
import 'package:fils/screen/Buyer/about_us/about_us_screen.dart';
import 'package:fils/screen/auth/login/screen/login_screen.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/validation.dart';
import 'package:fils/utils/http/get_object_widget.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';

import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/item_back.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../utils/storage/storage.dart';
import '../../../widget/flip_view.dart';

class SubscriptionsScreen extends StatefulWidget {
  final int typeStore;

  const SubscriptionsScreen({super.key, required this.typeStore});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (widget.typeStore != 0) {
          Future.microtask(() {
            toRemoveAll(context, LoginScreen());
          });
        } else {

        }
      },
      child: Consumer<AppNotifire>(
        builder: (context, app, child) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  SizedBox(height: heigth * 0.06, width: width),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.typeStore != 0) {
                            toRemoveAll(context, LoginScreen());
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: SizedBox(
                          height: getLang() == 'ar' ? 30 : 28,
                          width: 40,
                          child: FlipView(
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/icons/back.svg",
                                color: getTheme() ? white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: width * 0.01),
                      DefaultText(
                        "Subscriptions".tr(),
                        color: primaryDarkColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  SizedBox(height: heigth * 0.01, width: width),
                  Row(
                    children: [
                      DefaultText(
                        "Let's choose your subscription plan".tr(),
                        color: textColor,
                        overflow: TextOverflow.visible,
                        fontSize: 14,

                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  SizedBox(height: heigth * 0.03, width: width),

                  SizedBox(
                    width: width * 0.6,
                    child: DefaultText(
                      "Complete the subscription process before continuing. This step helps to protect your account and prevent spam."
                          .tr(),
                      color: const Color(0xff5A5555),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      fontSize: 14,

                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: CustomRequestWidget(
                      url: 'seller-packages-list',
                      buildResponse: (p0, SubscribeResponse? p1) {
                        if (p1!.data!.isEmpty) {
                          return Center(
                            child: DefaultText("No Data Found".tr()),
                          );
                        } else {
                          return ListView(
                            physics: const BouncingScrollPhysics(),
                            children:
                                p1.data!.map((e) {
                                  if (widget.typeStore == 1 &&
                                      containsSelver(e.name!)) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          e.isSelect = !e.isSelect;
                                        });
                                      },
                                      child: Container(
                                        height:
                                            e.isSelect ? null : heigth * 0.13,
                                        margin: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xffE8E2F8),
                                          ),
                                        ),
                                        child:
                                            e.isSelect
                                                ? selectAdsWidget(e, context)
                                                : unSelectAdsWidget(e),
                                      ),
                                    );
                                  } else if (widget.typeStore == 2 &&
                                      !containsSelver(e.name!)) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          e.isSelect = !e.isSelect;
                                        });
                                      },
                                      child: Container(
                                        height:
                                            e.isSelect ? null : heigth * 0.13,
                                        margin: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xffE8E2F8),
                                          ),
                                        ),
                                        child:
                                            e.isSelect
                                                ? selectAdsWidget(e, context)
                                                : unSelectAdsWidget(e),
                                      ),
                                    );
                                  } else if (widget.typeStore == 0) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          e.isSelect = !e.isSelect;
                                        });
                                      },
                                      child: Container(
                                        height:
                                            e.isSelect ? null : heigth * 0.18,
                                        margin: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xffE8E2F8),
                                          ),
                                        ),
                                        child:
                                            e.isSelect
                                                ? selectAdsWidget(e, context)
                                                : unSelectAdsWidget(e),
                                      ),
                                    );
                                  }
                                  return SizedBox();
                                }).toList(),
                          );
                        }
                      },
                      parseResponse: (p0) => SubscribeResponse.fromJson(p0),
                      requestType: RequestType.get,
                    ),
                  ),
                  Container(
                    height: heigth * 0.08,
                    margin: const EdgeInsets.only(
                      bottom: 20,
                      left: 10,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xffE8E2F8)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/icons/cup.svg"),
                            const SizedBox(width: 10),
                            DefaultText(
                              "Quality & Security Guarantee".tr(),
                              color: textColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        DefaultText(
                          "All subscriptions are protected and 100% guaranteed"
                              .tr(),
                          color: textColor,
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Padding unSelectAdsWidget(Datum e) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: hexToColor(e.color!),
            ),
            child: Center(
              child:
                  e.logo != null
                      ? Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.network(e.logo!),
                      )
                      : SvgPicture.asset("assets/icons/favourite_home.svg"),
            ),
          ),
          const SizedBox(width: 7),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultText(
                getTextByDash(e.name!, true),
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              DefaultText(
                getTextByDash(e.name!, false),
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
            ],
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DefaultText(
                e.price!.toDouble().toStringAsFixed(2),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
              const SizedBox(height: 5),
              DefaultText(
                "KWD",
                fontSize: 16,
                fontWeight: FontWeight.w600,

                color: primaryColor,
              ),
              const SizedBox(height: 5),
              DefaultText(
                containsPlatinum(e.name!) ? "Yearly".tr() : "Monthly".tr(),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
            ],
          ),
          SizedBox(
            height: 40,
            width: 40,
            child: Center(child: SvgPicture.asset("assets/icons/drob.svg")),
          ),
        ],
      ),
    );
  }

  Column selectAdsWidget(Datum e, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: hexToColor(e.color!),
                ),
                child: Center(
                  child:
                      e.logo != null
                          ? Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.network(e.logo!),
                          )
                          : SvgPicture.asset("assets/icons/favourite_home.svg"),
                ),
              ),
              const SizedBox(width: 7),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultText(
                    getTextByDash(e.name!, true),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  DefaultText(
                    getTextByDash(e.name!, false),
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ],
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultText(
                    e.price!.toDouble().toStringAsFixed(2),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 5),
                  DefaultText(
                    "KWD",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,

                    color: primaryColor,
                  ),
                  const SizedBox(height: 5),
                  DefaultText(
                    containsPlatinum(e.name!) ? "Yearly".tr() : "Monthly".tr(),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ],
              ),
              SizedBox(
                height: 40,
                width: 40,
                child: Center(child: SvgPicture.asset("assets/icons/drob.svg")),
              ),
            ],
          ),
        ),
        Divider(color: textColor),
        Container(
          height: 70,
          width: width * 0.43,
          decoration: BoxDecoration(
            color: secondColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultText(
                  // ignore: prefer_interpolation_to_compose_strings
                  " KWD ".tr() + e.price!.toDouble().toStringAsFixed(2),
                  color: white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 5),
                DefaultText(
                  containsPlatinum(e.name!) ? "Yearly".tr() : "Monthly".tr(),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: white,
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultText(
                "* Features : ".tr(),
                color: blackColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              const SizedBox(height: 20),
              ...List.generate(
                e.featuers!.length,
                (index) => Row(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        // ignore: deprecated_member_use
                        color: purpleColor.withOpacity(0.5),
                      ),
                      child: Center(
                        child: SvgPicture.asset("assets/icons/check.svg"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    DefaultText(e.featuers![index]),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              ...List.generate(
                e.extraFeatures!.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: DefaultText(
                    "🔹 ${e.extraFeatures![index]}",
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(12),
          child: ButtonWidget(
            onTap: () async {
              await TowithTrans(
                context,
                TermsAndCondation(e.id!),
                PageTransitionType.rightToLeft,
              );
            },
            title: "Subscribe".tr(),
            colorButton: primaryColor,
          ),
        ),
      ],
    );
  }
}
