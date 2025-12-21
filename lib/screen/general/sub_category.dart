import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fils/screen/Buyer/aucations/auction_category.dart';
import 'package:fils/screen/Buyer/store/all_store_screen.dart';
import 'package:fils/screen/banners/banner_home_general.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/enum/sub_category_screen.dart';
import 'package:fils/utils/http/wrap_util.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/widget/item_back.dart';
import 'package:flutter/material.dart';

import '../../../model/response/online_store_response.dart';
import '../../utils/const.dart';
import '../../utils/global_function/loading_widget.dart';

import '../../utils/storage/storage.dart';
import '../../utils/theme/color_manager.dart';
import '../../widget/defulat_text.dart';

class SubCategoryScreen extends StatelessWidget {
  final int category_id;
  final SubCategoryScreenEnum screen;
  const SubCategoryScreen({
    super.key,
    required this.category_id,
    required this.screen,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: ListView(
        children: [
          SizedBox(height: heigth * 0.02),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: itemBackAndTitle(context, title: "Category".tr()),
                ),
              ],
            ),
          ),

          SizedBox(height: heigth * 0.02),

          const BannerHomeGeneral(),
          SizedBox(height: heigth * 0.02),

          StaticWrapView(
            endpoint: "sub-categories/$category_id",
            columns: 3,
            rows: 3,

            requestType: RequestType.get,
            cacheKey: "sub-categories_openMarket",

            itemBuilder: (context, item) {
              return GestureDetector(
                onTap: () {
                  if (screen == SubCategoryScreenEnum.Store) {
                    ToWithFade(
                      context,
                      AllStoreScreen(
                        idCategory: item.id,
                        nameCategory: item.name,
                      ),
                    );
                  } else if (screen == SubCategoryScreenEnum.Auction) {
                    ToWithFade(
                      context,
                      AuctionCategory(
                        categoryId: int.parse(item.id.toString()),
                        categoryName: item.name,
                      ),
                    );
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: getTheme() ? Colors.black : grey6,
                        border: Border.all(color: grey6),
                      ),
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: item.banner,
                          fit: BoxFit.cover,
                          height: 60,
                          width: 60,
                          placeholder:
                              (context, url) => const LoadingWidgetImage(),
                        ),
                      ),
                    ),
                    SizedBox(height: heigth * 0.02),
                    DefaultText(
                      item.name,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: getTheme() ? white : const Color(0xff898384),
                    ),
                  ],
                ),
              );
            },

            parseItem: (json) => Category.fromJson(json),
          ),
          SizedBox(height: heigth * 0.03),
        ],
      ),
    );
  }
}
