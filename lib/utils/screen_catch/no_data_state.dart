import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:fils/widget/defulat_text.dart';

class NoDataState extends StatelessWidget {
  final Function()? onTryAgain;
  final String? title;

  const NoDataState({super.key, this.onTryAgain, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Lottie.asset('assets/lotti/noData.json'),
          ),
          Container(
            height: 50,
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                onTryAgain;
              },
              child: Center(
                child: DefaultText(
                  title ?? "Try Again".tr(),
                  type: FontType.bold,
                  textDecoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
