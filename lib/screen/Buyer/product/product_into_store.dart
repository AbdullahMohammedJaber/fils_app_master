import 'package:easy_localization/easy_localization.dart';
import 'package:fils/model/response/category_tabbar.dart';
import 'package:fils/utils/http/tab_bar_request.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/model/response/item_product.dart';

import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/grid_view_custom.dart';
import 'package:fils/widget/item_back.dart';
import 'package:fils/widget/item_search.dart';
import 'package:provider/provider.dart';

import '../../../utils/http/gridview_pagination_request.dart';
import 'item_product_widget_g.dart';

class ProductsIntoStoreScreen extends StatefulWidget {
  final dynamic idStore;
  final String nameStore;
  final String address;

  const ProductsIntoStoreScreen({
    super.key,
    required this.idStore,
    required this.nameStore,
    required this.address,
  });

  @override
  State<ProductsIntoStoreScreen> createState() =>
      _ProductsIntoStoreScreenState();
}

class _ProductsIntoStoreScreenState extends State<ProductsIntoStoreScreen> {
  @override
  void initState() {
    changeDomain1();

    super.initState();
  }

  @override
  void dispose() {
    changeDomain2();
    super.dispose();
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: itemBackAndTitle(context, title: widget.nameStore),
          ),
          Expanded(
            child: TabBarRequestWidget(
              endpoint: "products/seller-categories/${widget.idStore}",
              titleKey: "name",
              idStore:widget.idStore ,
              idKey: "id",

            ),
          ),
        ],
      ),
      /* body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

         // SizedBox(height: heigth * 0.01),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: DefaultText(
          //     widget.address,
          //     color: textColor,
          //     fontSize: 10,
          //     fontWeight: FontWeight.w400,
          //   ),
          // ),
          SizedBox(height: heigth * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ItemSearch(),
          ),
          SizedBox(height: heigth * 0.04),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DefaultText(
              "All Products".tr(),
              color: getTheme() ? white : blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: heigth * 0.02),
          Expanded(
            child: InfiniteScrollGridView(
              endpoint: 'products/seller/${widget.idStore}',
              isDataFirstList: false,
              cacheKey: "product_into_store",
              sliverGridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                    crossAxisCount: 2,
                    crossAxisSpacing: 1,
                    height: heigth * 0.42,
                    mainAxisSpacing: 2,
                  ),
              requestType: RequestType.get,
              parseItem: (json) => ProductListModel.fromJson(json),
              itemBuilder: (BuildContext context, ProductListModel item) {
                return ProductItemWidget(true ,productListModel: item);
              },
            ),
          ),
        ],
      ),*/
    );
  }
}
