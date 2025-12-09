import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/filter_search_notifier.dart';
import 'package:fils/model/response/item_product.dart';
import 'package:fils/screen/Buyer/product/item_product_widget_g.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/http/gridview_pagination_request.dart';
import 'package:fils/widget/grid_view_custom.dart';
import 'package:fils/widget/item_back.dart';
import 'package:provider/provider.dart';

class AllProductFilter extends StatefulWidget {
  final String search;

  const AllProductFilter({super.key, required this.search});

  @override
  State<AllProductFilter> createState() => _AllProductFilterState();
}

class _AllProductFilterState extends State<AllProductFilter> {
  bool isActive = true;
  late FilterSearchNotifier myProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    myProvider = Provider.of<FilterSearchNotifier>(context, listen: false);
  }

  @override
  void dispose() {
    if (isActive) {
      myProvider.clearData();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<FilterSearchNotifier>(builder: (context, filter, child) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              SizedBox(height: heigth * 0.06),
              itemBackAndTitle(context,
                  title: "Filter".tr(), showBackIcon: true),
              SizedBox(height: heigth * 0.01),
              Expanded(
                child: InfiniteScrollGridView(
                  endpoint: 'products/search',

                  isDataFirstList: true,
                  data: filter.typeSection == 2
                      ? filter.filterAuction(widget.search)
                      : filter.filterStore(widget.search),
                  isParameter: false,
                  requestType: RequestType.get,
                  sliverGridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2,
                      height: heigth * 0.42,
                      mainAxisSpacing: 2),
                  parseItem: (json) => ProductListModel.fromJson(json),
                  itemBuilder: (BuildContext context, ProductListModel item) {
                    return ProductItemWidget(true,
                      productListModel: item,
                      isAuction: filter.typeSection == 2 ? true : false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
