import 'package:easy_localization/easy_localization.dart';
import 'package:fils/screen/Buyer/OpenMarket/User_Classifed_Products/screen/header_details_product_open_market.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../controller/provider/floating_button_provider.dart';
import '../../../../../model/response/details_open_market_response.dart';
import '../../../../../utils/const.dart';
import '../../../../../utils/enum/request_type.dart';
import '../../../../../utils/http/get_object_widget.dart';
import '../../../../../utils/theme/color_manager.dart';
import '../../../../../widget/defulat_text.dart';
import 'all_product-in_market_open.dart';

class DetailsOpenMarket extends StatelessWidget {
  final String slug;

  const DetailsOpenMarket({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, toolbarHeight: 0),
      body: CustomRequestWidget(
        url: "classified/product-details/$slug",
        requestType: RequestType.get,
        buildResponse: (p0, p1) {
          DetailsOpenMarketResponseDatum details = p1!.data![0];
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                details.photos!.data!.isNotEmpty ||
                        details.thumbnailImage!.data!.isNotEmpty
                    ? HeaderDetailsProductOpenMarket(details: details)
                    : const SizedBox(),
                SizedBox(height: heigth * 0.03),

                // Category Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DefaultText(
                    details.category,
                    color: textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: heigth * 0.001),
                // Product Name
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DefaultText(
                          details.name,
                          color: blackColor,
                          fontSize: 16,
                          overflow: TextOverflow.visible,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),


                  ],
                ),
                SizedBox(height: heigth * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DefaultText(
                    "${details.unitPrice}",
                    color: secondColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: heigth * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      details.location == null
                          ? const SizedBox()
                          : DefaultText(
                            "Address".tr(),
                            fontSize: 14,
                            color: const Color(0xff5A5555),
                            fontWeight: FontWeight.w500,
                          ),
                      SizedBox(height: heigth * 0.01),
                      details.location == null
                          ? const SizedBox()
                          : SizedBox(
                            width: width * 0.85,
                            child: DefaultText(details.location),
                          ),
                    ],
                  ),
                ),
                SizedBox(height: heigth * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      details.phone == null
                          ? const SizedBox()
                          : DefaultText(
                        "Mobile Number".tr(),
                        fontSize: 14,
                        color: const Color(0xff5A5555),
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: heigth * 0.01),
                      PhoneText(phone: details.phone!),
                    ],
                  ),
                ),
                SizedBox(height: heigth * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      details.description == null
                          ? const SizedBox()
                          : DefaultText(
                            "Product Details".tr(),
                            fontSize: 14,

                            color: const Color(0xff5A5555),
                            fontWeight: FontWeight.w500,
                          ),
                      SizedBox(height: heigth * 0.01),
                      details.description == null
                          ? const SizedBox()
                          : SizedBox(
                            width: width * 0.85,
                            child: DefaultText(
                              details.description,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                    ],
                  ),
                ),
                SizedBox(height: heigth * 0.05),
                if (details.addedBy == getUser()!.user!.name)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GestureDetector(
                      onTap: () async {
                        showBoatToast();
                        final json = await NetworkHelper.sendRequest(
                          requestType: RequestType.delete,
                          endpoint: "classified/delete/${details.id}",
                        );
                        closeAllLoading();
                        if (!json.containsKey("errorMessage")) {
                          marketOpenController.update();
                          Navigator.pop(context);
                        }
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/icons/delete_red.svg",
                              ),
                            ),
                          ),
                          DefaultText("Delete Product".tr()),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        parseResponse: (p0) => DetailsOpenMarketResponse.fromJson(p0),
      ),
    );
  }
}

class PhoneText extends StatelessWidget {
  final String phone;

  const PhoneText({super.key, required this.phone});

  Future<void> _launchPhone() async {
    final Uri uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('لا يمكن فتح تطبيق الهاتف');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: GestureDetector(
        onTap: _launchPhone,
        child: Text(
          phone,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
