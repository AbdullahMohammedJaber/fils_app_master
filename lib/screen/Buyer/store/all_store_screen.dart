// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/model/response/store_in_category_response.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/http/get_object_widget.dart';
import 'package:fils/widget/item_back.dart';
import 'package:fils/widget/item_search.dart';

import 'package:provider/provider.dart';

import '../../../widget/defulat_text.dart';
import 'item_topStores.dart';

class AllStoreScreen extends StatelessWidget {
  final dynamic idCategory;
  final String nameCategory;

  const AllStoreScreen({
    super.key,
    required this.nameCategory,
    required this.idCategory,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).show();
    });
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false , toolbarHeight: 0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                SizedBox(height: heigth * 0.06),
                Expanded(
                  child: itemBackAndTitle(
                    context,
                    title: "All Store in ".tr() + nameCategory,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: heigth * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ItemSearch(),
          ),
          Expanded(
            child: CustomRequestWidget(
              url: "category/sub-category/shops/find/$idCategory",
              requestType: RequestType.get,
              buildResponse: (p0, p1) {
                StoreInCategoryResponse data = p1 as StoreInCategoryResponse;
                if (data.data.shops.data.isEmpty) {
                  return Center(child: DefaultText('No Data Found'.tr()));
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: heigth * 0.02),
                        data.data.shops.data.isEmpty
                            ? Center(child: DefaultText('No Data Found'.tr()))
                            : ItemTopStores(storeList: data.data.shops.data),
                        SizedBox(height: heigth * 0.02),
                      ],
                    ),
                  );
                }
              },
              parseResponse: (json) => StoreInCategoryResponse.fromJson(json),
            ),
          ),
        ],
      ),
    );
  }
}
