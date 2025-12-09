import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/filter_search_notifier.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

class RatingItem extends StatelessWidget {
  const RatingItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterSearchNotifier>(
      builder: (context, app, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultText(
              "Rating".tr(),
              fontWeight: FontWeight.w600,
              color: getTheme() ? white : blackColor,
              fontSize: 16,
            ),
            Row(
              children: [
                ...List.generate(app.rateList.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      app.functionOnClickStar(app.rateList[index]['id']);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      child: Center(
                        child:
                            app.rateList[index]['select']
                                ? SvgPicture.asset(
                                  "assets/icons/star_select.svg",
                                )
                                : SvgPicture.asset(
                                  "assets/icons/star_unselect.svg",
                                ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        );
      },
    );
  }
}
