import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fils/widget/flip_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/model/response/seller/home_seller_response.dart';

import 'package:fils/model/response/seller/product_seller_response.dart';

import 'package:fils/screen/Seller/control_product/details_product_seller.dart';

import 'package:fils/utils/const.dart';

import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/storage/storage.dart';

import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';

import '../../../utils/enum/message_type.dart';
import '../../../utils/message_app/show_flash_message.dart';

class ProductItemWidget extends StatefulWidget {
  final ProductSeller? productListModel;
  final bool isAds;
  const ProductItemWidget({
    super.key,
    this.productListModel,
    this.isAds = false,
  });

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(getUser()!.user!.type=="seller" && getAllShop().id == null){
          showCustomFlash(
            message: "Please Select your Shop".tr(),
            messageType: MessageType.Faild,
          );
        }else{
          if (widget.isAds) {
            Navigator.pop(context, {
              'id':widget.productListModel!.id,
              'name':widget.productListModel!.name,
            });
          } else {
            ToWithFade(
              context,
              DetailsProductSeller(idProduct: widget.productListModel!.id),
            );
          }
        }

      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: white),
        ),
        color: getTheme() ? Colors.black : white,
        elevation: getTheme() ? 0 : 4,
        child: Container(
          width: width * 0.46,

          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: heigth * 0.01),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),

                  child: CachedNetworkImage(
                    imageUrl: widget.productListModel!.thumbnailImg,
                    placeholder: (context, url) => const LoadingWidgetImage(),
                    errorWidget:
                        (context, url, error) =>
                            Image.asset("assets/images/fils_logo_f.png"),
                    height: heigth * 0.2,
                    width: width,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: heigth * 0.01),
              DefaultText(
                widget.productListModel!.name,
                color: getTheme() ? white : blackColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: heigth * 0.005),
              Row(
                children: [
                  SvgPicture.asset("assets/icons/store_nav.svg"),
                  SizedBox(width: width * 0.01),
                  Expanded(
                    child: DefaultText(
                      getAllShop().name ?? "",
                      color: getTheme() ? white : textColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: heigth * 0.005),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DefaultText(
                    widget.productListModel!.price.toString(),
                    color: secondColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: Center(
                      child: FlipView(
                        child: SvgPicture.asset(
                          "assets/icons/go_product.svg",
                          color: getTheme() ? white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductItemWidget2 extends StatefulWidget {
  final BestProduct? productListModel;

  const ProductItemWidget2({super.key, this.productListModel});

  @override
  State<ProductItemWidget2> createState() => _ProductItemWidget2State();
}

class _ProductItemWidget2State extends State<ProductItemWidget2> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ToWithFade(
          context,
          DetailsProductSeller(idProduct: widget.productListModel!.id),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Container(
          width: width * 0.46,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),

                  child: CachedNetworkImage(
                    imageUrl: widget.productListModel!.thumbnailImage,
                    placeholder: (context, url) => const LoadingWidgetImage(),
                    errorWidget:
                        (context, url, error) =>
                            Image.asset("assets/images/fils_logo_f.png"),
                    height: heigth * 0.2,
                    width: width,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: heigth * 0.01),
              DefaultText(
                widget.productListModel!.name,
                color: blackColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: heigth * 0.005),
              Row(
                children: [
                  SvgPicture.asset("assets/icons/store_nav.svg"),
                  SizedBox(width: width * 0.01),
                  Expanded(
                    child: DefaultText(
                      getAllShop().name ?? "",
                      color: textColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: heigth * 0.005),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DefaultText(
                    widget.productListModel!.basePrice.toString(),
                    color: secondColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: Center(
                      child: FlipView(
                        child: SvgPicture.asset("assets/icons/go_product.svg"),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
