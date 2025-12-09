import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/lotti/maintenance.json", height: heigth * 0.5),
          DefaultText(
            "Sorry, the app is in maintenance mode.".tr(),
            fontSize: 15,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
