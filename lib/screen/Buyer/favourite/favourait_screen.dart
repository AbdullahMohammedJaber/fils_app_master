// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/model/response/item_product.dart';
import 'package:fils/screen/Buyer/favourite/tap_bar_item.dart';
import 'package:fils/screen/Buyer/product/item_product_widget_g.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/update_controller.dart';
import 'package:fils/utils/http/gridview_pagination_request.dart';
import 'package:fils/widget/grid_view_custom.dart';
import 'package:fils/widget/item_back.dart';
import 'package:provider/provider.dart';

UpdateController ?updateControllerFav = UpdateController();

class FavouraitScreen extends StatelessWidget {
  FavouraitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return Consumer<AppNotifire>(builder: (context, app, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              SizedBox(height: heigth * 0.06),
              itemBackAndTitle(
                context,
                title: "Favourite".tr(),
              ),
              SizedBox(height: heigth * 0.03),
              const TapBarItemFav(),
              SizedBox(height: heigth * 0.03),
              Expanded(
                child: InfiniteScrollGridView(
                  cacheKey: "fav",
                  endpoint: app.url,
                  isDataFirstList: false,
                  updateController: updateControllerFav,
                  requestType: RequestType.get,
                  itemBuilder: (context, item) {
                    return ProductItemWidget(true,
                      productListModel: item,
                      isAuction: app.url.contains('1') ? true : false,
                    );
                  },
                  sliverGridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2,
                      height: heigth * 0.42,
                      mainAxisSpacing: 2),
                  parseItem: (json) => ProductListModel.fromJson(json),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
