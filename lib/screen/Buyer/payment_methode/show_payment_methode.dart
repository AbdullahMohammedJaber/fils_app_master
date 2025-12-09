import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/item_back.dart';
import 'package:provider/provider.dart';

class ShowPaymentMethodeScreen extends StatelessWidget {
  const ShowPaymentMethodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifire>(builder: (context, app, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                SizedBox(height: heigth * 0.06),
                itemBackAndTitle(context, title: "Payment methods".tr()),
                SizedBox(height: heigth * 0.06),
                ...List.generate(
                  app.paymentMethodeList.length,
                  (index) => Container(
                    height: 70,
                    width: width,
                    margin: EdgeInsets.only(bottom: heigth * 0.01),
                    decoration: BoxDecoration(
                      color: const Color(0xffFAFAFA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Image.asset(app.paymentMethodeList[index]['image']),
                          SizedBox(width: width * 0.07),
                          Expanded(
                            child: DefaultText(
                                app.paymentMethodeList[index]['name'],
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
