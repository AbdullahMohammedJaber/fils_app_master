// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/screen/Seller/Subscriptions/subscriptions_screen.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fils/screen/Seller/wallet/wallet_screen.dart';

import 'package:fils/utils/const.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../utils/enum/message_type.dart';
import '../../../utils/message_app/show_flash_message.dart';
import '../reports/reports_screen.dart';

class CategorySectionSeller extends StatefulWidget {
  CategorySectionSeller({super.key});

  @override
  State<CategorySectionSeller> createState() => _CategorySectionSellerState();
}

class _CategorySectionSellerState extends State<CategorySectionSeller> {
  late List<GlobalKey> showcaseKeys;
  List<CustomButton> lista = [
    CustomButton(
      label: 'Wallet'.tr(),
      color: secondColor.withOpacity(0.2),
      path: "assets/icons/wallet_seller.svg",
      dec: "You can easily deposit and withdraw your profits and sales from the wallet section.".tr(),
    ),
    CustomButton(
      label: 'Subscriptions'.tr(),
      color: purpleColor.withOpacity(0.2),
      path: "assets/icons/subscription.svg",
      dec: "As a seller, you must subscribe to a package to enjoy the app's features, such as adding products and auctions. Choose the package according to your specific needs.".tr(),
    ),
    CustomButton(
      label: 'Reports'.tr(),
      color: Colors.orange.withOpacity(0.2),
      path: "assets/icons/subscription.svg",
      dec: "You can download your sales and purchase reports from here to easily see your incoming and outgoing transactions in your account.".tr(),
    ),
  ];

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: heigth * 0.01),
          SizedBox(
            height: heigth * 0.07,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(lista.length, (index) {
                  return Expanded(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (index == 1) {
                              ToWithFade(
                                context,
                                const SubscriptionsScreen(typeStore: 0),
                              );
                            } else if (index == 0) {
                              if (getAllShop().id == null) {
                                showCustomFlash(
                                  message: "Please Select your Shop".tr(),
                                  messageType: MessageType.Faild,
                                );
                              } else {
                                ToWithFade(context, const WalletScreen());
                              }
                            } else if (index == 2) {
                              ToWithFade(context, const ReportsScreen());
                            }
                          },
                          child: CustomButton(
                            label: lista[index].label,
                            color: lista[index].color,
                            path: lista[index].path,
                            dec: lista[index].dec,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final Color color;
  final String path;
  final String dec;

  const CustomButton({
    super.key,
    required this.label,
    required this.color,
    required this.path,
    required this.dec,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(child: SvgPicture.asset(path!)),
        ),
        const SizedBox(width: 10),
        DefaultText(label!.tr(), color: getTheme() ? white : Colors.black),
      ],
    );
  }
}
