import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/filter_search_notifier.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

import '../../../../model/response/category_response.dart';

import '../../../../utils/enum/request_type.dart';
import '../../../../utils/http/dialog_request.dart';
import '../../../../utils/storage/storage.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterSearchNotifier>(
      builder: (context, search, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultText(
              "Categories".tr(),
              fontWeight: FontWeight.w500,
              color: getTheme() ? white : blackColor,
              fontSize: 14,
            ),
            SizedBox(height: heigth * 0.02),
            GestureDetector(
              onTap: () {
                showCupertinoDialog(
                  context: context,
                  builder:
                      (context) => InfiniteScrollDialog(
                        endpoint: 'categories',
                        itemSearchString: (p0) => p0.name,
                        cacheKey: "category_section_screen",
                        callback: (item) {
                          search.changeCategory(name: item!.name, id: item.id);
                        },
                        requestType: RequestType.get,
                        title: "Category".tr(),
                        itemBuilder: (context, item) {
                          return DefaultText(item.name);
                        },
                        parseResponse: (p0) => Datum.fromJson(p0),
                      ),
                );
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: getTheme() ? Colors.black : white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xffE9E9E9)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/icons/category.svg"),
                      SizedBox(width: width * 0.03),
                      DefaultText(
                        search.categoryName ?? "Select category".tr(),
                        color: const Color(0xff898384),
                      ),
                      const Spacer(),
                      Center(child: SvgPicture.asset("assets/icons/drob.svg")),
                    ],
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
