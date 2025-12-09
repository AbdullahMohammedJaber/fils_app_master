import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/model/response/transactionHistory_response.dart';
import 'package:fils/utils/http/list_request.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/controller/provider/wallet_notifire.dart';
import 'package:fils/model/response/balance_response.dart';
import 'package:fils/screen/Buyer/wallet/add_funds_wallet.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/http/get_object_widget.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

class FundsWalletScreen extends StatelessWidget {
  const FundsWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).show();
    });
    return Consumer2<WalletNotifire, AppNotifire>(
      builder: (context, app, c, child) {
        return Scaffold(
          appBar: AppBar(toolbarHeight: 0),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                SizedBox(height: heigth * 0.02),
                Row(
                  children: [
                    DefaultText(
                      "Add Funds".tr(),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: primaryDarkColor,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        app.paymentMethode = null;
                        ToWithFade(context, AddFundsWallet());
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: primaryDarkColor,
                        ),
                        child: Center(
                          child: SvgPicture.asset("assets/icons/plus.svg"),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  color: Colors.transparent,
                  height: heigth * 0.5,
                  child: CustomRequestWidget(
                    url: 'wallet/balance',
                    requestType: RequestType.get,
                    customLoading: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    buildResponse: (p0, p1) {
                      BalanceResponse? pay = p1;
                      if (pay!.data!.lastRecharged == "Not Available") {
                        return Column(
                          children: [
                            SizedBox(height: heigth * 0.05),
                            DefaultText(
                              "You must charge your wallet balance in order to enjoy the application features"
                                  .tr(),
                              overflow: TextOverflow.visible,
                              color: textColor,
                            ),
                            SizedBox(height: heigth * 0.02),

                            Image.asset("assets/images/wallet_F.png" ),
                            SizedBox(height: heigth * 0.05),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    app.paymentMethode = null;
                                    ToWithFade(context, AddFundsWallet());
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: primaryDarkColor,
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "assets/icons/plus.svg",
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                DefaultText(
                                  "Add your wallet details".tr(),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff5A5555),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            SizedBox(height: heigth * 0.05),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: purpleColor,
                              ),
                              height: heigth * 0.15,
                              width: width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  DefaultText(
                                    "${pay.data!.balance}",
                                    color: white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  const SizedBox(width: 5),
                                  DefaultText(
                                    c.currancy.tr(),
                                    color: white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: heigth * 0.03),
                            DefaultText(
                              "Your current balance in the wallet, you can add more through the add button"
                                  .tr(),
                              overflow: TextOverflow.visible,
                              color: textColor,
                            ),
                          ],
                        );
                      }
                    },
                    parseResponse: (p0) => BalanceResponse.fromJson(p0),
                  ),
                ),
                ListWidgetRequest(
                  endpoint: "balance/transactions",
                  requestType: RequestType.get,
                  cacheKey: "balance/transactions",
                  parseItem: (json) => TransactionHistory.fromJson(json),
                  itemBuilder: (context, item) {
                    return Row(
                      children: [
                        Card(
                          elevation: 5,
                          margin: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/icons/gift.svg",
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DefaultText(
                                item.description ?? "",
                                color: getTheme() ? white : blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                        DefaultText(
                          item.amount,
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    );
                  },
                  isFirstData: true,
                  isParam: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
