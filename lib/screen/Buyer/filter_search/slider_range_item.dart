// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/filter_search_notifier.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

import '../../../utils/storage/storage.dart';

class PriceRangeSlider extends StatefulWidget {
  const PriceRangeSlider({super.key});

  @override
  _PriceRangeSliderState createState() => _PriceRangeSliderState();
}

class _PriceRangeSliderState extends State<PriceRangeSlider> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<FilterSearchNotifier, AppNotifire>(
      builder: (context, app, c, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultText(
              "Price".tr(),
              fontWeight: FontWeight.w600,
              color: getTheme() ? white : blackColor,
              fontSize: 16,
            ),
            RangeSlider(
              values: app.currentRangeValues,
              min: 1,
              max: 1000,
              divisions: 50,
              activeColor: purpleColor,
              inactiveColor: Colors.black,
              onChanged: (RangeValues price) {
                app.changeRangePrice(price);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAnimatedLabel(
                  '${app.currentRangeValues.start.toInt()} ${c.currancy.tr()}',
                ),
                _buildAnimatedLabel(
                  '${app.currentRangeValues.end.toInt()} ${c.currancy.tr()}',
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnimatedLabel(String? text) {
    return DefaultText(
      text!,
      fontWeight: FontWeight.w500,
      color: getTheme() ? white : blackColor,
      fontSize: 14,
    );
  }
}
