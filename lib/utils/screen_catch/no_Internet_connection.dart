// ignore_for_file: file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';

class NoInternetConnection extends StatelessWidget {
  final Function()? onTryAgain;

  const NoInternetConnection({super.key, this.onTryAgain});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Lottie.asset('assets/lotti/no_internet.json'),
          ),
          Center(
            child: DefaultText(
              "Try connecting to the Internet".tr(),
              type: FontType.bold,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            child: ButtonWidget(
              title: "Try Again".tr(),
              onTap: onTryAgain,
              radius: 5,
              colorButton: primaryDarkColor,
              colorTitle: white,
            ),
          ),
          const Spacer(),
          /*Container(
            height: 50,
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {

              },
              child:
            ),
          ),*/
        ],
      ),
    );
  }
}
