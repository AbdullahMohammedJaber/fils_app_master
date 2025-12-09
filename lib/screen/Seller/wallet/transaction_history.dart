import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fils/widget/item_back.dart';

import 'package:provider/provider.dart';

import '../../../controller/provider/floating_button_provider.dart';
import '../../../utils/const.dart';
import '../../../utils/theme/color_manager.dart';
import '../../../widget/defulat_text.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return Consumer<AppNotifire>(builder: (context, app, child) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              SizedBox(height: heigth * 0.06, width: width),
              itemBackAndTitle(context, title: "Transactions history".tr()),
              SizedBox(height: heigth * 0.05, width: width),
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
                                  offset: const Offset(
                                      2, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                  "assets/icons/payment_failed.svg"),
                            ),
                          ),
                          SizedBox(width: width * 0.03),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      )
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
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )),
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
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    itemCount: 15),
              ),
            ],
          ),
        ),
      );
    });
  }
}
