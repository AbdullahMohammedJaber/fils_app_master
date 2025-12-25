
import 'package:fils/controller/provider/home_notifire.dart';
import 'package:fils/controller/provider/theme_notifire.dart';
import 'package:flutter/material.dart';

import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/screen/Buyer/root_app/dialog_root.dart';

import 'package:fils/utils/theme/color_manager.dart';


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
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
