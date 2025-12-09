import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fils/screen/Seller/wallet/bank_setting.dart';
import 'package:fils/screen/Seller/wallet/setting_wallet.dart';
import 'package:fils/screen/Seller/wallet/withdrow_screen.dart';

import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/http/get_object_widget.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

import '../../../controller/provider/floating_button_provider.dart';
import '../../../model/response/seller/wallet_seller_response.dart';
import '../../../utils/global_function/number_format.dart';
import '../../../widget/item_back.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return Consumer<AppNotifire>(
      builder: (context, app, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: width, height: heigth * 0.06),
                Row(
                  children: [
                    Expanded(
                      child: itemBackAndTitle(context, title: "Wallet".tr() , showBackIcon: true),
                    ),
                    GestureDetector(
                      onTap: () {
                        ToWithFade(context, const SettingWallet());
                      },
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: Center(
                          child: SvgPicture.asset(
                            "assets/icons/setting.svg",
                            color: getTheme() ? white : textColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: CustomRequestWidget(
                    url: "wallet",
                    requestType: RequestType.get,
                    buildResponse: (context, data) {
                      WalletSellerResponse wallet = data!;
                      double priceWallet = extractDouble(
                        wallet.data.adminToPay,
                      );

                      return Column(
                        children: [
                          SizedBox(width: width, height: heigth * 0.05),
                          Container(
                            height: heigth * 0.12,
                            width: width,
                            decoration: BoxDecoration(
                              color: purpleColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DefaultText(
                                      "$priceWallet",
                                      color: white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    SizedBox(width: width * 0.015),
                                    DefaultText(
                                      app.currancy.tr(),
                                      color: white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                                SizedBox(height: heigth * 0.01),
                                /*DefaultText(
                                  "+${app.currancy} 0.00 pending",
                                  color: white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w400,
                                ),*/
                              ],
                            ),
                          ),
                          SizedBox(width: width, height: heigth * 0.03),
                          DefaultText(
                            "Your current balance in the wallet.".tr(),
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(width: width, height: heigth * 0.05),
                          ButtonWidget(
                            onTap: () {
                              if (priceWallet != 0) {
                                if (getShopInfo().data!.bankAccNo == "null") {
                                  ToWithFade(context!, const BankSetting());
                                } else {
                                  ToWithFade(
                                    context!,
                                    WithdrowScreen(
                                      wallet: wallet.data.adminToPay,
                                    ),
                                  );
                                }
                              }
                            },
                            title: "Withdraw Funds".tr(),
                            colorButton:
                                priceWallet == 0 ? textColor : secondColor,
                            radius: 18,
                          ),
                          SizedBox(width: width, height: heigth * 0.04),
                          wallet.data.latestPayouts.isNotEmpty
                              ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  DefaultText(
                                    "Latest Transactions".tr(),
                                    color: blackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      //ToWithFade(context, TransactionHistory());
                                    },
                                    child: DefaultText(
                                      "View Full Transactions".tr(),
                                      color: purpleColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                              : const SizedBox(),
                          Expanded(
                            child: ListView.separated(
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0.5,
                                            blurRadius: 1,
                                            offset: const Offset(2, 3),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          "assets/icons/payment_failed.svg",
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width * 0.03),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          DefaultText(
                                            "Failed transaction!".tr(),
                                            color: blackColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/calendar.svg",
                                                  ),
                                                  SizedBox(width: width * 0.01),
                                                  DefaultText(
                                                    "10.02.2025",
                                                    color: textColor,
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: width * 0.03),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/clock.svg",
                                                  ),
                                                  SizedBox(width: width * 0.01),
                                                  DefaultText(
                                                    "05:34 AM",
                                                    color: textColor,
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    DefaultText(
                                      "- ${app.currancy} 57",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xffE4626F),
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(height: heigth * 0.01);
                              },
                              itemCount: wallet.data.latestPayouts.length,
                            ),
                          ),
                        ],
                      );
                    },
                    parseResponse: (p0) => WalletSellerResponse.fromJson(p0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
