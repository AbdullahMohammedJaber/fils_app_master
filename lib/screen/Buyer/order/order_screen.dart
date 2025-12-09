import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/model/response/order_response.dart';

import 'package:fils/screen/Buyer/order/item_order.dart';

import 'package:fils/screen/Buyer/order/tapbar_item_order.dart';
import 'package:fils/screen/Buyer/order/traking_screen.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/update_controller.dart';
import 'package:fils/utils/http/list_pagination.dart';
import 'package:provider/provider.dart';

import '../../../controller/provider/order_notifire.dart';
import '../../../widget/item_back.dart';

UpdateController orderController = UpdateController();

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).show();
    });
    return Consumer<OrderNotifier>(
      builder: (context, order, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [

                itemBackAndTitle(context, title: "My Order".tr()),
                SizedBox(height: heigth * 0.05),
                const TapBarOrderItem(),
                SizedBox(height: heigth * 0.03),
                Expanded(
                  child: PaginatedListWidget(
                    isFirstData: true,
                    cacheKey: "order_screen",
                    updateController: orderController,
                    requestType: RequestType.get,
                    isParam: true,
                    parseItem: (json) => Orders.fromJson(json),
                    itemBuilder: (context, item) {
                      return Column(
                        children: [
                          ItemOrder(
                            orders: item,
                            status: order.pageTapBar,
                          ),
                          item.isShow
                              ? TrackingScreen(
                                  itineraries: item.products,
                                  date: item.date,
                                )
                              : const SizedBox(),
                        ],
                      );
                    },
                    endpoint: order.url,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
