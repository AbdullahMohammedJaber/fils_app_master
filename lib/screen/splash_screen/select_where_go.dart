import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/screen/Buyer/aucations/auction_screen.dart';
import 'package:fils/screen/Buyer/video/show_reel.dart';
import 'package:fils/screen/general/root_app.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/route/route.dart';
import 'package:provider/provider.dart';

class SelectWhereGoScreen extends StatelessWidget {
  const SelectWhereGoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: heigth,
        width: width,
        color: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 3,
        mini: false,
        openCloseDial: ValueNotifier<bool>(false),
        childPadding: const EdgeInsets.all(5),
        spaceBetweenChildren: 4,
        onOpen: () => debugPrint('OPENING DIAL'),
        onClose: () => debugPrint('DIAL CLOSED'),
        elevation: 5.0,
        animationCurve: Curves.elasticInOut,
        isOpenOnStart: false,
        children: [
          SpeedDialChild(
            child: SvgPicture.asset("assets/icons/home_nav.svg"),
            backgroundColor: Colors.white,
            label: 'Home'.tr(),
            onTap: () {
              toRemoveAll(context, const RootAppScreen());
              context.read<AppNotifire>().onClickBottomNavigationBar(0);
            },
          ),
          SpeedDialChild(
            child: SvgPicture.asset("assets/icons/store_nav.svg"),
            backgroundColor: Colors.white,
            label: 'Online store'.tr(),
            onTap: () {
              toRemoveAll(context, const RootAppScreen());
              context.read<AppNotifire>().onClickBottomNavigationBar(1);
            },
          ),
          SpeedDialChild(
            child: SvgPicture.asset("assets/test/reels.svg"),
            backgroundColor: Colors.white,
            label: 'Reels'.tr(),
            visible: true,
            onTap: () {
              toRemoveAll(context, const RootAppScreen());
              ToWithFade(context, const VideoScreen());
            },
          ),
          SpeedDialChild(
            child: SvgPicture.asset("assets/test/aucation.svg"),
            backgroundColor: Colors.white,
            label: 'Public auctions'.tr(),
            visible: true,
            onTap: () {
              toRemoveAll(context, const RootAppScreen());
              ToWithFade(context, const AuctionScreen());
            },
          ),
        ],
      ),
    );
  }
}
