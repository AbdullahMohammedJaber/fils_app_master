import 'package:badges/badges.dart' as badges;
import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/home_notifire.dart';
import 'package:fils/controller/provider/theme_notifire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/screen/Buyer/root_app/dialog_root.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';

import 'package:provider/provider.dart';

import 'bottom_bar_widget.dart';

class RootAppByuerScreen extends StatefulWidget {
  const RootAppByuerScreen({super.key});

  @override
  State<RootAppByuerScreen> createState() => _RootAppScreenState();
}

class _RootAppScreenState extends State<RootAppByuerScreen> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).show();
    });
    return Consumer2<AppNotifire, HomeNotifire>(
      builder: (context, root, home, child) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (root.selectPageRoot == 0) {
              showDialogExitApp(context);
            } else {
              root.onClickBottomNavigationBar(root.selectPageRoot - 1);
            }
          },
          child: Scaffold(
            body: root.screenList[root.selectPageRoot],
            bottomNavigationBar: SafeArea(
              child: Consumer<ThemeProvider>(
                builder: (context, theme, child) {
               
                  return CurvedBottomNavigationBar(
              
                    activeColor: orange,
                    backgroundColor: white,
                    inactiveColor: textColor,
                  );
                  // return SafeArea(
                  //   child: Container(
                  //     height: 70,
                  //     decoration: BoxDecoration(
                  //       color: getTheme() ? Colors.black : white,
                  //       borderRadius: const BorderRadius.only(
                  //         topLeft: Radius.circular(15),
                  //         topRight: Radius.circular(15),
                  //       ),
                  //       border: Border(top: BorderSide(color: white)),
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: List.generate(
                  //         root.screenIcons.length,
                  //             (index) => GestureDetector(
                  //           onTap: () {
                  //             root.onClickBottomNavigationBar(index);
                  //           },
                  //           child: Container(
                  //             width: width * 0.15,
                  //             height: heigth,
                  //             color: Colors.transparent,
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               mainAxisSize: MainAxisSize.min,
                  //               children: [
                  //                 if (index == 2)
                  //                   badges.Badge(
                  //                     badgeStyle: badges.BadgeStyle(
                  //                       shape: badges.BadgeShape.circle,
                  //                       badgeColor: primaryColor,
                  //                       padding: const EdgeInsets.all(6),
                  //                       elevation: 5,
                  //                     ),
                  //                     stackFit: StackFit.loose,
                  //                     badgeContent: DefaultText(
                  //                       home.totalCount.toString(),
                  //                       color: white,
                  //
                  //                       textAlign: TextAlign.center,
                  //                       fontSize: 14,
                  //                       fontWeight: FontWeight.bold,
                  //                     ),
                  //
                  //                     child: SvgPicture.asset(
                  //                       root.screenIcons[index]['icons'],
                  //                       color:
                  //                       root.selectPageRoot == index
                  //                           ? secondColor
                  //                           : null,
                  //                       height: 25,
                  //                     ),
                  //                   )
                  //                 else
                  //                   SvgPicture.asset(
                  //                     root.screenIcons[index]['icons'],
                  //                     color:
                  //                     root.selectPageRoot == index
                  //                         ? secondColor
                  //                         : null,
                  //                     height: 22,
                  //                   ),
                  //                 SizedBox(height: heigth * 0.01),
                  //                 DefaultText(
                  //                   root.screenIcons[index]['title']
                  //                       .toString()
                  //                       .tr(),
                  //                   color:
                  //                   root.selectPageRoot == index
                  //                       ? secondColor
                  //                       : getTheme()
                  //                       ? white
                  //                       : grey,
                  //                   fontSize: 12,
                  //                   fontWeight: FontWeight.w400,
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}