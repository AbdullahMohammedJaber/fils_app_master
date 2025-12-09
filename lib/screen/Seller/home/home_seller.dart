// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/controller/provider/home_notifire.dart';
import 'package:fils/screen/Buyer/edit_account/edit_personal_information.dart';

import 'package:fils/screen/banners/banner_home_general.dart';
import 'package:fils/screen/banners/complete_profile.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/global_function/update_controller.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:flutter/material.dart';

import 'package:fils/model/response/seller/home_seller_response.dart';
import 'package:fils/screen/Seller/home/category_section_seller.dart';
import 'package:fils/screen/Seller/home/last_auction_seller.dart';
import 'package:fils/screen/Seller/home/last_product_seller.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/http/get_object_widget.dart';
import 'package:provider/provider.dart';

import '../../Buyer/home/home_shimmer_loading.dart';

UpdateController homeUpdate = UpdateController();

class HomeSeller extends StatefulWidget {
  HomeSeller({super.key});

  @override
  State<HomeSeller> createState() => _HomeSellerState();
}

class _HomeSellerState extends State<HomeSeller> {
  bool test = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeNotifier = Provider.of<HomeNotifire>(context, listen: false);

      homeNotifier.getRequestSeller(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return Consumer2<HomeNotifire, AppNotifire>(
      builder: (context, controller, app, child) {
        return Expanded(
          child: CustomRequestWidget(
            customLoading: const HomeShimmerLoading(),
            buildResponse: (context, HomeSellerResponse? data) {
              if (  getShopInfo().data != null && getShopInfo().data!.logo == null) {


                controller.insertWidgetListBannersSeller(
                  const CompleteProfile(),
                );

              }else{
                controller.initBannersList();
              }

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const BannerHomeGeneral(),
                    SizedBox(height: heigth * 0.01),
                    CategorySectionSeller(),
                    SizedBox(height: heigth * 0.01),
                    LastProductSeller(homeSeller: data!.data),
                    SizedBox(height: heigth * 0.03),
                    LastAuctionSeller(homeSeller: data.data),
                    SizedBox(height: heigth * 0.05),
                  ],
                ),
              );
            },
            parseResponse: (p0) => HomeSellerResponse.fromJson(p0),
            url: "home",
            requestType: RequestType.get,
            updateController: homeUpdate,
          ),
        );
      },
    );
  }
}
