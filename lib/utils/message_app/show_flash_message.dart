// ignore_for_file: unrelated_type_equality_checks, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/app_notifire.dart';

import 'package:fils/controller/provider/vedio_notifire.dart';
import 'package:fils/screen/general/root_app.dart';
import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

showCustomFlash({
  required final String message,
  required final MessageType messageType,
  final FlashPosition flashPosition = FlashPosition.bottom,
}) {
  return showFlash(
    context: NavigationService.navigatorKey.currentContext!,
    persistent: true,
    duration: const Duration(seconds: 3),
    builder: (_, controller) {
      return Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Flash(
          position: flashPosition,
          controller: controller,
          forwardAnimationCurve: Curves.ease,
          reverseAnimationCurve: Curves.bounceIn,
          child: FlashBar(
            margin: const EdgeInsets.all(8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 8,
            backgroundColor:
                messageType == MessageType.Success ? Colors.green : Colors.red,
            icon: const Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            primaryAction: TextButton(
              onPressed: () => controller.dismiss(),
              child: Text(
                "DISMISS".tr(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            controller: controller,
            content: DefaultText(
              message,
              color: white,
              fontSize: 14,
              maxLines: 3,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
      );
    },
  );
}

Widget buildDownloadWidget() {
  return Consumer<VideoController>(builder: (context, app, s) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DefaultText(
            "Downloading ...".tr(),
            fontSize: 16,
            color: const Color(0xff433E3F),
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StepProgressIndicator(
                  totalSteps: 100,
                  currentStep: int.parse(app.progress.toString()),
                  size: 8,
                  padding: 0,
                  selectedColor: primaryColor,
                  unselectedColor: Colors.grey[200]!,
                  roundedEdges: const Radius.circular(10),
                ),
              ),
              const SizedBox(width: 10),
              DefaultText(
                app.progressText,
                fontSize: 16,
                color: const Color(0xff433E3F),
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ],
      ),
    );
  });
}

Widget buildWinAuctionWidget(dynamic winId, dynamic price, String nameUser,
    dynamic idAction, String nameProduct) {
  return Consumer<AppNotifire>(
    builder: (context , app , child) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  child: Center(
                    child: SvgPicture.asset("assets/icons/close.svg"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(child: Image.asset("assets/images/sale.png")),
            DefaultText(
              "Auction time has ended.".tr(),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 5),
            if (winId != getUser()!.user!.id)
              DefaultText(
                nameProduct +
                    " was sold".tr() +
                    " to ".tr() +
                    "$nameUser" +
                    "for the highest price of ".tr() +
                    "${app.currancy}$price.",
                overflow: TextOverflow.visible,
                color: const Color(0xff5A5555),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              )
            else
              DefaultText(
                "You won the auction and won the product.\n Now you have to pay by going to the Cart and paying through it"
                    .tr(),
                overflow: TextOverflow.visible,
                color: const Color(0xff5A5555),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            const Spacer(),
            if (winId != getUser()!.user!.id)
              ButtonWidget(
                title: "Back to Home Page".tr(),
                onTap: () {
                  NavigationService.navigatorKey.currentContext!
                      .read<AppNotifire>()
                      .changePageTapBar(index: 0);
                  toRemoveAll(NavigationService.navigatorKey.currentContext!,
                      const RootAppScreen());
                },
              )
            else
              Row(
                children: [
                  DefaultText(
                    "$price${app.currancy}",
                    color: secondColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(width: width * 0.05),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        toRemoveAll(NavigationService.navigatorKey.currentContext!,
                            const RootAppScreen());
                      },
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: secondColor,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/cart_nav.svg",
                              color: white,
                            ),
                            SizedBox(width: width * 0.02),
                            DefaultText(
                              "Add To Cart".tr(),
                              fontSize: 14,
                              color: white,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 5),
          ],
        ),
      );
    }
  );
}
