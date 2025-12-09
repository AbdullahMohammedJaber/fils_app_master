import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/screen/banners/smooth_widget.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/provider/home_notifire.dart';

class BannerHomeGeneral extends StatelessWidget {
  const BannerHomeGeneral({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeNotifire , AppNotifire>(builder: (context, controller, app , child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: heigth * 0.25,
            width: width,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: getTheme() ? Colors.black : white,
                border: Border.all(color: const Color(0xffB5B3B3)),
                borderRadius: BorderRadius.circular(12)),
            child: PageView.builder(
              itemBuilder: (context, index) {
                return controller.bannersList[index];
              },
              controller: controller.pageController,
              reverse: false,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index) {
                controller.updateCurrentPage(index);
              },
              itemCount: controller.bannersList.length,
              physics: const BouncingScrollPhysics(),
            ),
          ),
          const SmoothWidget(),
        ],
      );
    });
  }
}
