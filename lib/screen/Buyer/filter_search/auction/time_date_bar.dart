import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/filter_search_notifier.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/global_function/timer_format.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

import '../../../../utils/storage/storage.dart';

class TabBarAuctionTimeDateFilter extends StatelessWidget {
  const TabBarAuctionTimeDateFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterSearchNotifier>(
      builder: (context, app, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultText(
              "Time & Date".tr(),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(
                              context,
                            ).copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          );
                        },
                      );

                      if (pickedTime != null) {
                        app.changeTimeFilter(pickedTime);
                      }
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: purpleColor.withOpacity(0.3),
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/clock.svg",
                            color: getTheme() ? Colors.white : textColor,
                          ),
                          const SizedBox(width: 5),
                          DefaultText(
                            app.timeFilter == null
                                ? "Select Time".tr()
                                : formatTimeOfDay(app.timeFilter!),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: getTheme() ? Colors.white : blackColor,
                          ),
                          const SizedBox(width: 5),
                          SvgPicture.asset(
                            "assets/icons/drob.svg",
                            color: getTheme() ? Colors.white : textColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.02),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        app.changeDateFilter(pickedDate);
                      }
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: purpleColor.withOpacity(0.3),
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/calendar.svg",
                            color: getTheme() ? Colors.white : textColor,
                          ),
                          const SizedBox(width: 5),
                          DefaultText(
                            app.dataFilter == null
                                ? "Select Date".tr()
                                : formatDateFilter(app.dataFilter!),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color:   getTheme() ? Colors.white : blackColor,
                          ),
                          const SizedBox(width: 5),
                          SvgPicture.asset(
                            "assets/icons/drob.svg",
                            color: getTheme() ? Colors.white : textColor,
                          ),
                        ],
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
