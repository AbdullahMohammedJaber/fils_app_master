import 'package:easy_localization/easy_localization.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:fils/utils/theme/color_manager.dart';

class CrachScreen extends StatelessWidget {
  final Function()? onTryAgain;

  const CrachScreen({super.key, this.onTryAgain});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Lottie.asset('assets/lotti/error_state.json'),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            child: ButtonWidget(
              title: "Try Again".tr(),
              onTap: onTryAgain,
              radius: 5,
              colorButton: primaryDarkColor,
              colorTitle: white,
            ),
          ),
        ],
      ),
    );
  }
}
