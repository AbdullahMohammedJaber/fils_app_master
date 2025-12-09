// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/theme_notifire.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/screen/Buyer/root_app/dialog_root.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

import '../../../utils/message_app/show_flash_message.dart';
import '../../../utils/storage/storage.dart';
import '../../Buyer/root_app/bottom_bar_widget.dart';
import 'bottom_seller.dart';

class RootAppSeller extends StatefulWidget {
  const RootAppSeller({super.key});

  @override
  State<RootAppSeller> createState() => _RootAppSellerState();
}

class _RootAppSellerState extends State<RootAppSeller> {

  @override
  Widget build(BuildContext context) {


    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).show();
    });

    return Consumer<AppNotifire>(
      builder: (context, root, child) {
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
            resizeToAvoidBottomInset: false,
            body: SafeArea(child: root.screenListSeller[root.selectPageRoot]),
            bottomNavigationBar: SafeArea(
              child: Consumer<ThemeProvider>(
                builder: (context, th, child) {
                
                  return CurvedBottomNavigationBarSeller(
              
                    activeColor: orange,
                    backgroundColor: white,
                    inactiveColor: textColor,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
