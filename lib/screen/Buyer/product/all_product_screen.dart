import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';

import 'package:fils/model/response/item_product.dart';
import 'package:fils/screen/Buyer/product/item_product_widget_g.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/http/gridview_pagination_request.dart';
import 'package:fils/widget/grid_view_custom.dart';
import 'package:fils/widget/item_back.dart';
import 'package:provider/provider.dart';

class AllProductScreen extends StatelessWidget {
  const AllProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).show();
    });
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: heigth * 0.06),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: itemBackAndTitle(
              context,
              title: "All Product".tr(),
              showBackIcon: true,
            ),
          ),
          SizedBox(height: heigth * 0.02),

          Expanded(
            child: InfiniteScrollGridView(
              endpoint: 'products?is_auction=0',
              isDataFirstList: true,
              isParameter: true,
              cacheKey: "all_product_screen",
              requestType: RequestType.get,
              sliverGridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                    crossAxisCount: 2,
                    crossAxisSpacing: 1,
                    height: heigth * 0.42,
                    mainAxisSpacing: 2,
                  ),
              parseItem: (json) => ProductListModel.fromJson(json),
              itemBuilder: (BuildContext context, ProductListModel item) {
                return ProductItemWidget(true ,productListModel: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}
