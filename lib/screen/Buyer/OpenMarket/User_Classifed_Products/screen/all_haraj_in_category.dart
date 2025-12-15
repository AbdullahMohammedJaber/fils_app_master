// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fils/model/response/market_open_response.dart';
import 'package:fils/screen/Buyer/OpenMarket/User_Classifed_Products/screen/details_open_market.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/global_function/update_controller.dart';
import 'package:fils/utils/http/gridview_pagination_request.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/grid_view_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
 UpdateController haraj = UpdateController();
class AllProductHarajPyCategoryId extends StatelessWidget {
  int categoryId;
  AllProductHarajPyCategoryId(this.categoryId, {super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: heigth * 0.05, width: width),
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                color: getTheme() ? white : blackColor,
                size: 30,
              ),
            ),
          ],
        ),
        SizedBox(height: heigth * 0.03),
        Expanded(
          child: InfiniteScrollGridView(
            endpoint: "classified/public",
            shwrinkWrap: true,
            updateController: haraj,
            data: {"category_id": categoryId},
            cacheKey: "classified/public",
            parseItem: (json) => MarketOpenResponse.fromJson(json),
            itemBuilder: (context, item) {
              return GestureDetector(
                onTap: () {
                  ToWithFade(context, DetailsOpenMarket(slug: item.slug!));
                },
                child: Stack(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: white),
                      ),
                      color: getTheme() ? Colors.black : white,
                      elevation: 4,
                      child: Container(
                        width: width * 0.46,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: heigth * 0.011),
                            Stack(
                              children: [
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),

                                    child: CachedNetworkImage(
                                      imageUrl: item.thumbnailImage!,
                                      placeholder:
                                          (context, url) =>
                                              const LoadingWidgetImage(),
                                      errorWidget:
                                          (context, url, error) => Image.asset(
                                            "assets/images/fils_logo_f.png",
                                          ),
                                      height: heigth * 0.2,
                                      width: width,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: heigth * 0.01),
                            DefaultText(
                              item.name,
                              color: getTheme() ? white : blackColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: heigth * 0.005),
                            Row(
                              children: [
                                SvgPicture.asset("assets/icons/store_nav.svg"),
                                SizedBox(width: width * 0.01),
                                Expanded(
                                  child: DefaultText(
                                    item.category,
                                    color: textColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: heigth * 0.005),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DefaultText(
                                  item.unitPrice,
                                  color: secondColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            isDataFirstList: true,
            sliverGridDelegate:
                SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2,
                  height: heigth * 0.32,
                  mainAxisSpacing: 2,
                ),
            requestType: RequestType.get,
          ),
        ),
      ],
    );
  }
}
