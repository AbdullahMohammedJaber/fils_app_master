import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/filter_search_notifier.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

import '../../../utils/storage/storage.dart';

class TabBarItemFilter extends StatelessWidget {
  const TabBarItemFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterSearchNotifier>(
      builder: (context, app, child) {
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  app.changeTypeSection(2);
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: app.typeSection == 2 ? purpleColor : getTheme() ? Colors.black :white,
                    border: Border.all(
                      color: app.typeSection == 2 ? purpleColor :getTheme() ? Colors.white : textColor,
                    ),
                  ),
                  child: Center(
                    child: DefaultText(
                      "Auctions".tr(),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: app.typeSection == 2 ? white :getTheme() ? Colors.white : textColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: width * 0.02),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  app.changeTypeSection(1);
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: app.typeSection == 1 ? purpleColor :getTheme() ? Colors.black :white,
                    border: Border.all(
                      color: app.typeSection == 1 ? purpleColor :getTheme() ? Colors.white : textColor,
                    ),
                  ),
                  child: Center(
                    child: DefaultText(
                      "Online Store".tr(),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: app.typeSection == 1 ? white :getTheme() ? Colors.white : textColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
