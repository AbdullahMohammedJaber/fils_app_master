// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fils/model/response/all_store_response.dart';
import 'package:fils/screen/Buyer/product/product_into_store.dart';
import 'package:fils/screen/banners/banner_home_general.dart';
import 'package:fils/screen/general/sub_category.dart';
import 'package:fils/utils/enum/sub_category_screen.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/http/list_pagination.dart';
import 'package:fils/utils/http/wrap_util.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/store_notofire.dart';
import 'package:fils/model/response/online_store_response.dart';
import 'package:fils/utils/animation/custom_fade_animation.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/widget/item_search.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../utils/storage/storage.dart';
import '../aucations/auction_screen.dart';
import 'banner_store.dart';
import 'item_titleBar.dart';

class StoreScreen extends StatefulWidget {
  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  StoreNotifire? storeNotifire;
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
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: -1,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        backgroundColor: orangeH,
      ),
      body: CustomFadeAnimationComponent(
        1,
        ChangeNotifierProvider(
          create: (context) => StoreNotifire(),
          builder: (context, _) {
            storeNotifire = context.watch();
            return Stack(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: BannerShapePainter(
                          shapeColor: orangeH,
                          borderRadius: 0,
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/icons/stack_bar.svg",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: heigth * 0.35,
                    ),
                  ],
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    key: scrollViewKey,
                    controller: scrollController,
                    child: Column(
                      children: [
                        SizedBox(height: heigth * 0.045),
                        itemTitleBar(storeNotifire, context),
                        SizedBox(height: heigth * 0.05),
                        /*Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: ItemSearch(),
                        ),
                        SizedBox(height: heigth * 0.02),*/
                        // const BannerHomeGeneral(),
                        BannerStore(
                          onClick: () {
                            scrollDown();
                          },
                        ),
                        SizedBox(height: heigth * 0.02),
                        StaticWrapView(
                          endpoint: "categories",
                          cacheKey: "store_screen",

                          requestType: RequestType.get,
                          columns: 3,
                          rows: 3,
                          itemBuilder: (context, item) {
                            return GestureDetector(
                              onTap: () {
                                ToWithFade(
                                  context,
                                  SubCategoryScreen(
                                    category_id: item.id,
                                    screen: SubCategoryScreenEnum.Store,
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: getTheme() ? Colors.black : grey6,
                                      border: Border.all(color: grey6),
                                    ),
                                    child: Center(
                                      child: CachedNetworkImage(
                                        imageUrl: item.banner,
                                        fit: BoxFit.cover,
                                        height: 60,
                                        width: 60,
                                        placeholder:
                                            (context, url) =>
                                                const LoadingWidgetImage(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: heigth * 0.02),
                                  DefaultText(
                                    item.name,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        getTheme()
                                            ? white
                                            : const Color(0xff898384),
                                  ),
                                ],
                              ),
                            );
                          },

                          parseItem: (json) => Category.fromJson(json),
                        ),
                        SizedBox(height: heigth * 0.03),
                        PaginatedListWidget(
                          key: shopKey,
                          endpoint: "shops",
                          cacheKey: "store_screen_list",
                          isFirstData: true,
                          shrinkWrap: true,
                          requestType: RequestType.get,
                          parseItem: (json) => Datum.fromJson(json),
                          itemBuilder: (BuildContext context, Datum item) {
                            return item.logo == null
                                ? SizedBox()
                                : Padding(
                                  padding: EdgeInsetsDirectional.only(
                                    end: width * 0.01,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      ToWithFade(
                                        context,
                                        ProductsIntoStoreScreen(
                                          idStore: item.id,
                                          nameStore: item.name!,
                                          address: item.address,
                                        ),
                                      );
                                    },
                                    child: Card(
                                      elevation: 1,
                                      color: getTheme() ? Colors.black : white,
                                      child: Container(
                                        width: width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(color: white),
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(height: heigth * 0.02),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                  ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  item.logo!,
                                                  height: heigth * 0.13,
                                                  width: width * 0.31,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: width * 0.02),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  DefaultText(
                                                    item.name,
                                                    color:
                                                        getTheme()
                                                            ? white
                                                            : Colors.black,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  SizedBox(
                                                    height: heigth * 0.01,
                                                  ),
                                                  DefaultText(
                                                    item.description,
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.w400,
                                                    color: textColor,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(
                                                    height: heigth * 0.01,
                                                  ),

                                                  Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/rate.svg",
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.01,
                                                          ),
                                                          DefaultText(
                                                            "${item.rating}  ${"Rate".tr()}",
                                                            color: textColor,
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: width * 0.01,
                                                      ),
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/products_icons.svg",
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.01,
                                                          ),
                                                          DefaultText(
                                                            "${item.productsCount}  ${"Products".tr()}",
                                                            color: textColor,
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: width * 0.01,
                                                      ),
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/coustamer.svg",
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.01,
                                                          ),
                                                          DefaultText(
                                                            "${item.totalSales}  ${"Bayer".tr()}",
                                                            color: textColor,
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ],
                                                      ),

                                                      Expanded(
                                                        child: Transform(
                                                          alignment:
                                                              Alignment.center,
                                                          transform:
                                                              Matrix4.rotationY(
                                                                getLang() ==
                                                                        'ar'
                                                                    ? 0
                                                                    : pi,
                                                              ),
                                                          child: Center(
                                                            child: SvgPicture.asset(
                                                              height: 15,
                                                              "assets/icons/mynaui_arrow-up-solid.svg",
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                          },
                        ),
                        SizedBox(height: heigth * 0.02),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
