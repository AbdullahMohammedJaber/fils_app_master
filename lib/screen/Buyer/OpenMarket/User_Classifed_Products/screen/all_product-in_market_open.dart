import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fils/screen/Buyer/edit_account/edit_personal_information.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/update_controller.dart';
import 'package:fils/utils/http/wrap_util.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/widget/item_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../../../model/response/market_open_response.dart';
import '../../../../../model/response/online_store_response.dart';
import '../../../../../utils/const.dart';
import '../../../../../utils/global_function/loading_widget.dart';
import '../../../../../utils/http/gridview_pagination_request.dart';

import '../../../../../utils/route/route.dart';
import '../../../../../utils/storage/storage.dart';
import '../../../../../utils/theme/color_manager.dart';
import '../../../../../widget/defulat_text.dart';
import '../../../../../widget/flip_view.dart';
import '../../../../../widget/grid_view_custom.dart';
import '../../../../../widget/item_search.dart';
import '../../../../banners/banner_home_general.dart';
import '../../../aucations/auction_screen.dart';
import '../controller/classifed_general.dart';
import 'all_haraj_in_category.dart';
import 'details_open_market.dart';
import 'form_add_product_open_market.dart';

UpdateController marketOpenController = UpdateController();

class AllProductInMarketOpen extends StatelessWidget {
  const AllProductInMarketOpen({super.key});

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
        backgroundColor: kohliH,
      ),
      body: ChangeNotifierProvider(
        create: (context) => ClassifiedGeneral(),
        builder: (context, child) {
          var controller = context.watch<ClassifiedGeneral>();
          return Stack(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: BannerShapePainter(
                        shapeColor: kohliH,
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
                  child: Column(
                    children: [
                      SizedBox(height: heigth * 0.05),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: SizedBox(
                                      height: getLang() == 'ar' ? 30 : 28,
                                      width: 40,
                                      child: FlipView(
                                        child: Center(
                                          child: SvgPicture.asset(
                                            "assets/icons/back.svg",
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: const AssetImage(
                                      'assets/icons/fils.png',
                                    ),
                                  ),
                                  SizedBox(width: width * 0.04),
                                  SizedBox(
                                    width: width * 0.5,
                                    child: DefaultText(
                                      "Open Market".tr(),
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                if (getUser()!.user!.phone!.isNotEmpty) {
                                  TowithTrans(
                                    context,
                                    const FormAddProductOpenMarket(
                                      idCategory: null,
                                      nameCategory: null,
                                    ),
                                    PageTransitionType.bottomToTop,
                                  );
                                } else {
                                  showCustomFlash(
                                    message: "Please fill Phone number".tr(),
                                    messageType: MessageType.Faild,
                                  );
                                  To(context, EditPersonalInformationScreen());
                                }
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: secondColor,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/icons/plus.svg",
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),

                      SizedBox(height: heigth * 0.01),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 40,
                              width: 80,
                              decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(4),
                                color: kohliH.withOpacity(0.4),
                              ),
                              child: Center(
                                child: DefaultText(
                                  'Add Product'.tr(),
                                  color: kohliH ,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: heigth * 0.03),

                      const BannerHomeGeneral(),
                      SizedBox(height: heigth * 0.02),

                      StaticWrapView(
                        endpoint: "categories",
                        columns: 3,
                        rows: 3,

                        requestType: RequestType.get,
                        cacheKey: "category_openMarket",

                        itemBuilder: (context, item) {
                          return GestureDetector(
                            onTap: () {
                              ToWithFade(
                                context,
                                AllProductHarajPyCategoryId(item.id),
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
                      InfiniteScrollGridView(
                        endpoint: "classified/public",
                        shwrinkWrap: true,
                        cacheKey: "classified/public",
                        parseItem: (json) => MarketOpenResponse.fromJson(json),
                        itemBuilder: (context, item) {
                          return GestureDetector(
                            onTap: () {
                              ToWithFade(
                                context,
                                DetailsOpenMarket(slug: item.slug!),
                              );
                            },
                            child: Stack(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(color: white),
                                  ),
                                  color: getTheme() ? Colors.black : white,
                                  elevation: 4,
                                  child: Container(
                                    width: width * 0.46,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: heigth * 0.011),
                                        Stack(
                                          children: [
                                            Center(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16),

                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      item.thumbnailImage!,
                                                  placeholder:
                                                      (context, url) =>
                                                          const LoadingWidgetImage(),
                                                  errorWidget:
                                                      (
                                                        context,
                                                        url,
                                                        error,
                                                      ) => Image.asset(
                                                        "assets/images/fils_logo_f.png",
                                                      ),
                                                  height: heigth * 0.2,
                                                  width: width,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: heigth * 0.01),
                                        DefaultText(
                                          item.name,
                                          color:
                                              getTheme() ? white : blackColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: heigth * 0.005),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/store_nav.svg",
                                            ),
                                            SizedBox(width: width * 0.01),
                                            Expanded(
                                              child: DefaultText(
                                                item.category,
                                                color: textColor,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: heigth * 0.005),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            DefaultText(
                                              item.unitPrice,
                                              color: secondColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        isDataFirstList: true,
                        sliverGridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                              crossAxisCount: 2,
                              crossAxisSpacing: 2,
                              height: heigth * 0.32,
                              mainAxisSpacing: 2,
                            ),
                        requestType: RequestType.get,
                        updateController: marketOpenController,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
