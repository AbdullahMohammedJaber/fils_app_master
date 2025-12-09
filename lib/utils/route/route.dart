// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

Future To(BuildContext context, Widget widget) async {
  return await Navigator.of(
    context,
    rootNavigator: true,
  ).push(MaterialPageRoute(builder: (BuildContext context) => widget));
}

TowithTrans(
  BuildContext context,
  Widget widget,
  PageTransitionType type,
) async {
  return await Navigator.push(
    context,
    PageTransition(
      type: type,
      child: widget,
      curve: Curves.easeInOutQuart,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 400),
    ),
  );
}

Future<void> toUrl(String url2) async {
  final Uri url = Uri.parse(url2);

  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication, // لفتح الرابط في المتصفح الخارجي
  )) {
    throw Exception('Could not launch $url');
  }
}

Future ToWithFade(BuildContext context, Widget widget) async {
  return await Navigator.of(
    NavigationService.navigatorKey.currentContext!,
  ).push(
    PageRouteBuilder(
      pageBuilder: (c, a1, a2) => widget,
      transitionsBuilder: (c, anim, a2, child) {
        return FadeTransition(opacity: anim, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    ),
  );
}

Future ToRemove(BuildContext context, Widget widget) async {
  return await Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      pageBuilder: (c, a1, a2) => widget,
      transitionsBuilder: (c, anim, a2, child) {
        return FadeTransition(opacity: anim, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    ),
  );
}

Future toRemoveAll(BuildContext context, Widget widget) async {
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      pageBuilder: (c, a1, a2) => widget,
      transitionsBuilder: (c, anim, a2, child) {
        return FadeTransition(opacity: anim, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    ),
    (_) => false,
  );
}

Future ToRemoveExcept(BuildContext context, Widget widget) async {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (BuildContext context) => widget),
    (Route<dynamic> route) {
      return route.isFirst;
    },
  );
}
