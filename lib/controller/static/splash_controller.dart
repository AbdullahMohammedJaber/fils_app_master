// ignore_for_file: use_build_context_synchronously

import 'package:fils/screen/Seller/store/create_store/screen/add_store.dart';
import 'package:fils/screen/auth/login/screen/login_screen.dart';
import 'package:flutter/material.dart';

import 'package:fils/screen/general/root_app.dart';
import 'package:fils/screen/landing_page/landing_page.dart';

import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/storage/storage.dart';

class SplashController {
  getIntroRequest(BuildContext context, {bool loading = false}) async {
    skipSplashWhereRequest(context);
  }

  skipSplashWhereRequest(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      if (isLogin()) {
        if (getUser()!.user!.type == "seller" &&
            getUser()!.user!.shops_count == 0) {
          toRemoveAll(context, LoginScreen());
        } else {
          toRemoveAll(context, const RootAppScreen());
        }
      } else {
        if (!isLanding()) {
          ToRemove(context, LandingPageScreen());
        } else {
          toRemoveAll(context, const RootAppScreen());
        }
      }
    });
  }
}
