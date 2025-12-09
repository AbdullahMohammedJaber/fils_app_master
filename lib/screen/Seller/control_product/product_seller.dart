import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/global_function/validation.dart';
import 'package:fils/widget/item_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/product_notifire.dart';
import 'package:fils/model/response/seller/product_seller_response.dart';
import 'package:fils/screen/Seller/control_auction/empty_auction.dart';
import 'package:fils/screen/Seller/control_product/item_product_seller.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/http/gridview_pagination_request.dart';

import 'package:fils/utils/theme/color_manager.dart';

import 'package:fils/widget/defulat_text.dart';

import 'package:provider/provider.dart';

import '../../../widget/grid_view_custom.dart';

class ProductSellerScreen extends StatelessWidget {
  final bool isAds;
  const ProductSellerScreen({super.key, this.isAds = false});
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductNotifire>(
      builder: (context, controller, child) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: width, height: heigth * 0.02),

              isAds
                  ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: itemBackAndTitle(context, title: "My Product".tr()),
                  )
                  : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        DefaultText(
                          "My Product".tr(),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: primaryDarkColor,
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            checkStatusStore(true, context);
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: secondColor,
                            ),
                            child: Center(
                              child: SvgPicture.asset("assets/icons/plus.svg"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              SizedBox(width: width, height: heigth * 0.02),

              Expanded(
                child: InfiniteScrollGridView(
                  endpoint: "products/all",
                  cacheKey: "product_all_seller",
                  requestType: RequestType.get,
                  updateController: controller.updateControllerProduct,
                  itemBuilder: (context, item) {
                    return ProductItemWidget(
                      productListModel: item,
                      isAds: isAds,
                    );
                  },
                  parseItem: (json) => ProductSeller.fromJson(json),
                  emptyWidget: emptyMyProduct(context),
                  isDataFirstList: false,
                  sliverGridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                        crossAxisCount: 2,
                        height: heigth * 0.35,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
