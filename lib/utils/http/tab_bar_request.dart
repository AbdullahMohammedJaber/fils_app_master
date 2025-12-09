import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/global_function/update_controller.dart';
import 'package:flutter/material.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/utils/global_function/printer.dart';
import 'package:fils/widget/defulat_text.dart';
import '../../model/response/item_product.dart';
import '../../screen/Buyer/product/item_product_widget_g.dart';
import '../../utils/screen_catch/no_Internet_connection.dart';
import '../../utils/screen_catch/crach_screen.dart';
import '../../widget/grid_view_custom.dart';
import '../const.dart';
import '../enum/request_type.dart';
import '../http/http_helper.dart';
import 'gridview_pagination_request.dart';

class TabBarRequestWidget extends StatefulWidget {
  final String endpoint;
  final String titleKey; // اسم المفتاح مثل "name"
  final String idKey; // مثل "id"
  final dynamic idStore;
  final Future<List<dynamic>> Function()? futureData; // إذا أردت تنفيذ مخصص

  const TabBarRequestWidget({
    super.key,
    required this.endpoint,
    required this.idStore,
    required this.titleKey,
    required this.idKey,
    this.futureData,
  });

  @override
  State<TabBarRequestWidget> createState() => _TabBarRequestWidgetState();
}

class _TabBarRequestWidgetState extends State<TabBarRequestWidget>
    with SingleTickerProviderStateMixin {
  List<dynamic> tabs = [];
  bool isLoading = true;
  bool hasError = false;
  bool empty = false;
  int? id;
  String? url;
  UpdateController updateTab = UpdateController();

  @override
  void initState() {
    super.initState();
    _fetchTabs();
  }

  Future<void> _fetchTabs() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await NetworkHelper.sendRequest(
        requestType: RequestType.get,
        endpoint: widget.endpoint,
      );

      final List<dynamic> data = response['data']['data'];
      if(data.isNotEmpty){
        tabs = data;
        id = tabs[0][widget.idKey];
        url = "products/seller/${widget.idStore}?category_id=$id";
        setState(() {
          empty = true;
          isLoading = false;
          hasError = false;

        });
      }else{
        setState(() {
          isLoading = false;
          hasError = false;
        });
      }



    } catch (e) {
      printWarning("❌ خطأ أثناء جلب التابات: $e");
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void _onTabSelected(int index) {
    id = index;
    String urlNew = "products/seller/${widget.idStore}?category_id=$id";
    updateTab.updateWithNewUrl(urlNew);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return CrachScreen(onTryAgain: _fetchTabs);
    }

    if (tabs.isEmpty) {
      return Center(child: DefaultText("No Data Found".tr()));
    }

    return Column(
      children: [
        SizedBox(height: heigth * 0.02),

        Container(
          height: heigth * 0.1,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            children:
                tabs.map((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        _onTabSelected(e[widget.idKey]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color:
                                  e[widget.idKey] == id
                                      ? primaryColor
                                      : Colors.grey.shade300,
                            ),
                          ),
                        ),
                        child: Center(
                          child: DefaultText(
                            e[widget.titleKey],
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
        if (id != null)
          Expanded(
            child: InfiniteScrollGridView(
              endpoint: url!,
              isDataFirstList: false,
              isParameter: true,
              updateController: updateTab,
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
                return ProductItemWidget(true, productListModel: item);
              },
            ),
          ),
      ],
    );
  }
}
