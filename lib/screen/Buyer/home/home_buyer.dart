// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/model/response/item_product.dart';
import 'package:fils/screen/Buyer/edit_account/edit_personal_information.dart';
import 'package:fils/screen/Buyer/product/item_product_widget_g.dart';
import 'package:fils/screen/banners/banner_home_general.dart';
import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/http/list_pagination.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/home_notifire.dart';
import 'package:fils/model/response/home_response.dart';
import 'package:fils/screen/Buyer/home/banner_item_home.dart';
import 'package:fils/screen/Buyer/home/item_category.dart';
import 'package:fils/screen/Buyer/product/item_product_home.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/http/get_object_widget.dart';
import 'package:fils/utils/http/service.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../controller/provider/admob_ads_provider.dart';
import '../../../utils/storage/storage.dart';
import '../../general/ads_widget.dart';
import '../product/all_product_screen.dart';
import '../store/banner_store.dart';
import 'home_shimmer_loading.dart';

class HomeBuyer extends StatefulWidget {
  HomeNotifire homeNotifire;

  HomeBuyer({super.key, required this.homeNotifire});

  @override
  State<HomeBuyer> createState() => _HomeBuyerState();
}

class _HomeBuyerState extends State<HomeBuyer> {
  var scrollController = ScrollController();
  final GlobalKey shopKey = GlobalKey();
  final GlobalKey scrollViewKey = GlobalKey();
  void scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final targetContext = shopKey.currentContext;
      final scrollContext = scrollViewKey.currentContext;

      if (targetContext == null || scrollContext == null) return;

      final RenderBox targetBox = targetContext.findRenderObject() as RenderBox;
      final RenderBox scrollBox = scrollContext.findRenderObject() as RenderBox;

      // موقع العنصر بالنسبة لإحداثيات الشاشة (global)
      final targetGlobal = targetBox.localToGlobal(Offset.zero);

      // نحول الموقع العالمي إلى إحداثيات محلية لصندوق الـ scroll
      final targetLocalToScroll = scrollBox.globalToLocal(targetGlobal);

      // نضيف الـ offset الحالي للسكرول للحصول على القيمة النهائية المراد التنقل إليها
      double targetOffset = scrollController.offset + targetLocalToScroll.dy;

      // ضبط لتجنّب القيم السالبة أو تجاوز الحد الأعلى
      if (targetOffset < scrollController.position.minScrollExtent) {
        targetOffset = scrollController.position.minScrollExtent;
      } else if (targetOffset > scrollController.position.maxScrollExtent) {
        targetOffset = scrollController.position.maxScrollExtent;
      }

      scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeNotifier = Provider.of<HomeNotifire>(context, listen: false);
      homeNotifier.getRequestByuer();
    });

  }
  @override
  void dispose() {

    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return Consumer2<HomeNotifire, AppNotifire>(
      builder: (context, controller, app, child) {
        scrollDown();
        return Expanded(
          child: CustomRequestWidget(
            cacheKey: "home_response",
            buildResponse: (context, HomeResponse? data) {
              if (data!.data!.latestAuction != null) {
                controller.insertWidgetListBanners(
                  BannerHomeItem(homeNotifire: widget.homeNotifire, data: data),
                );
              }

              return SingleChildScrollView(
                key: scrollViewKey,
                controller: scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: heigth * 0.01),
                    GestureDetector(
                      onTap: () {
                        toUrl('http://wibex.io');
                      },
                      child: Image.asset("assets/images/web.png"),
                    ),
                    SizedBox(height: heigth * 0.01),

                    /*  BannerAdWidget(),
                    SizedBox(height: heigth * 0.01),*/
                    ItemCategoryHome(
                      homeNotifire: widget.homeNotifire,
                      keyG: shopKey,
                    ),
                    SizedBox(height: heigth * 0.04),
                    ItemProductHome(data: data),
                    SizedBox(height: heigth * 0.01),

                    const BannerHomeGeneral(),

                    SizedBox(height: heigth * 0.04),
                    ItemShopHome(data: data),
                    SizedBox(height: heigth * 0.04),
                    BannerStore(
                      onClick: () {
                        ToWithFade(
                          NavigationService.navigatorKey.currentContext!,
                          const AllProductScreen(),
                        );
                      },
                    ),
                    SizedBox(height: heigth * 0.02),

                    ItemRelatedProductHome(data: data),
                    SizedBox(height: heigth * 0.04),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              DefaultText(
                                "Suggested Product".tr(),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: getTheme() ? white : blackColor,
                              ),
                              const Spacer(),
                              // GestureDetector(
                              //   onTap: () {},
                              //   child: Padding(
                              //     padding:
                              //         const EdgeInsets.symmetric(horizontal: 12),
                              //     child: DefaultText("See All".tr(),
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w400,
                              //         color: primaryColor),
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(height: heigth * 0.02),
                          SizedBox(
                            height: heigth * 0.42,
                            child: PaginatedListWidget(
                              cacheKey: "suggested-products",
                              isFirstData: false,
                              axis: Axis.horizontal,
                              itemBuilder: (context, item) {
                                return ProductItemWidget(
                                  false,
                                  productListModel: item,
                                );
                              },
                              parseItem:
                                  (json) => ProductListModel.fromJson(json),
                              endpoint: "suggested-products",
                              requestType: RequestType.get,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: heigth * 0.1),
                  ],
                ),
              );
            },
            parseResponse: (p0) => HomeResponse.fromJson(p0),
            url: home,
            customLoading: const HomeShimmerLoading(),
            requestType: RequestType.get,
          ),
        );
      },
    );
  }
}
