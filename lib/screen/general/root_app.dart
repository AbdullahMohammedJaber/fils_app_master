import 'package:fils/utils/const.dart';
import 'package:flutter/material.dart';

import 'package:fils/screen/Buyer/root_app/root_app.dart';
import 'package:fils/screen/Seller/root/root_app.dart';

import 'package:fils/utils/storage/storage.dart';

class RootAppScreen extends StatefulWidget {
  const RootAppScreen({super.key});

  @override
  State<RootAppScreen> createState() => _RootAppScreenState();
}

class _RootAppScreenState extends State<RootAppScreen> {
  @override
  void initState() {
    if (isLogin()) {
      if (getUser()!.user!.type == "customer") {
        changeDomain1();
      } else {
        changeDomain2();
      }
    } else {
      changeDomain1();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin()) {
      if (getUser()!.user!.type == "customer") {
        return const RootAppByuerScreen();
      } else {
        return const RootAppSeller();
      }
    } else {
      return const RootAppByuerScreen();
    }
  }
}
