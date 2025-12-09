// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/widget/defualt_text_form_faild.dart';

import '../screen/Buyer/filter_search/all_product_filter.dart';
import '../screen/Buyer/filter_search/filter_widget.dart';

class ItemSearch extends StatelessWidget {
  ItemSearch({super.key});

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: TextFormFieldWidget(
        hintText: "Search".tr(),
        isIcon: true,
        isDouble: false,
        isPreffix: true,
        controller: searchController,
        onChange: (value) {},
        textInputType: TextInputType.name,
        textInputAction: TextInputAction.search,
        onTapDoneKey: (search) {
          print("On Tab search icon in keyboard");
          FocusScope.of(context).unfocus();
          ToWithFade(
              context,
              AllProductFilter(
                search: searchController.text,
              ));
        },
        ontapIconPrefix: () {
          print("On Tab search icon in form faild");

          FocusScope.of(context).unfocus();

          ToWithFade(
            context,
            AllProductFilter(
              search: searchController.text,
            ),
          );
        },
        ontapIcon: () {
          FocusScope.of(context).unfocus();
          showModalBottomSheet(
            context: context,
            elevation: 2,
            enableDrag: true,
            useSafeArea: true,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            builder: (context) {
              return const FilterWidget();
            },
          );
        },
        pathIconPrefix: "assets/icons/search_home.svg",
        pathIcon: "assets/icons/filter_home.svg",
      ),
    );
  }
}
