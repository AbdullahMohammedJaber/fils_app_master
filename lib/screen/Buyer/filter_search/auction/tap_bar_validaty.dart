import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/filter_search_notifier.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

import '../../../../utils/storage/storage.dart';

class TabBarAuctionValidateFilter extends StatelessWidget {
  const TabBarAuctionValidateFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterSearchNotifier>(
      builder: (context, app, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultText(
              "Validity".tr(),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      app.changeTypeValidity(1);
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: app.typeValidity == 1 ? purpleColor :getTheme() ? Colors.black : white,
                        border: Border.all(
                          color:
                              app.typeValidity == 1 ? purpleColor :getTheme() ? Colors.white : textColor,
                        ),
                      ),
                      child: Center(
                        child: DefaultText(
                          "Expired".tr(),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: app.typeValidity == 1 ? white :getTheme() ? Colors.white : textColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.02),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      app.changeTypeValidity(2);
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: app.typeValidity == 2 ? purpleColor :getTheme() ? Colors.black : white,
                        border: Border.all(
                          color:
                              app.typeValidity == 2 ? purpleColor :getTheme() ? Colors.white : textColor,
                        ),
                      ),
                      child: Center(
                        child: DefaultText(
                          "Valid".tr(),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: app.typeValidity == 2 ? white :getTheme() ? Colors.white : textColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
