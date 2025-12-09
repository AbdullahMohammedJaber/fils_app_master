import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/global_function/number_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/model/response/item_product.dart';
import 'package:fils/screen/Buyer/aucations/details_aucatin.dart';
import 'package:fils/screen/Buyer/favourite/favourait_screen.dart';
import 'package:fils/screen/Buyer/product/details_product/details_product_screen.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/dialog_auth.dart';

class ProductItemWidget extends StatefulWidget {
  final ProductListModel? productListModel;
  final bool isAuction;
  final bool isGrid;

  const ProductItemWidget(
    this.isGrid, {
    super.key,
    this.productListModel,

    this.isAuction = false,
  });

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isAuction) {
          ToWithFade(
            context,
            DetailsAuctions(slug: widget.productListModel!.id!),
          );
        } else {
          ToWithFade(
            context,
            DetailsProductScreen(idProduct: widget.productListModel!.id!),
          );
        }
      },
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: white),
            ),
            elevation: 0.1,
            color: getTheme() ? Colors.black : white,

            child: Container(
              width: width * 0.5,
              height: heigth * 0.41,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: heigth * 0.011),
                  Stack(
                    children: [
                      SizedBox(
                        height: heigth * 0.26,

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),

                          child: CachedNetworkImage(
                            imageUrl: widget.productListModel!.thumbnailImage!,
                            placeholder:
                                (context, url) => const LoadingWidgetImage(),
                            errorWidget:
                                (context, url, error) => Image.asset(
                                  "assets/images/fils_logo_f.png",
                                ),

                            width: width,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: heigth * 0.02,
                        right: 8,
                        child: GestureDetector(
                          onTap: () async {
                            if (isLogin()) {
                              if (widget.productListModel!.is_favorite!) {
                                widget.productListModel!.is_favorite = false;
                                setState(() {});
                                var json = await NetworkHelper.sendRequest(
                                  requestType: RequestType.get,
                                  endpoint:
                                      "wishlists-remove-product/${widget.productListModel!.id}",
                                );
                                if (!json.containsKey("errorMessage")) {
                                  if (updateControllerFav != null) {
                                    updateControllerFav!.update();
                                  }
                                }
                              } else {
                                widget.productListModel!.is_favorite = true;
                                setState(() {});
                                var json = await NetworkHelper.sendRequest(
                                  requestType: RequestType.get,
                                  endpoint:
                                      "wishlists-add-product/${widget.productListModel!.id}",
                                );
                                if (!json.containsKey("errorMessage")) {}
                              }
                            } else {
                              showDialogAuth(context);
                            }
                          },
                          child: Center(
                            child: SvgPicture.asset(
                              widget.productListModel!.is_favorite!
                                  ? "assets/icons/fav_fill.svg"
                                  : "assets/icons/favourite_home.svg",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: heigth * 0.020),
                  DefaultText(
                    widget.productListModel!.name,
                    color: getTheme() ? white : blackColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: heigth * 0.003),
                  Row(
                    children: [
                      SvgPicture.asset("assets/icons/store_nav.svg"),
                      SizedBox(width: width * 0.01),
                      Expanded(
                        child: DefaultText(
                          widget.productListModel!.shop_name,
                          color: getTheme() ? white : textColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: heigth * 0.001),
                  widget.productListModel!.current_stock == 0
                      ? Container(
                        width: width,
                        height: heigth * 0.05,
                        color: error.withOpacity(0.3),
                        child: Center(
                          child: DefaultText("Out of stock".tr(), color: error),
                        ),
                      )
                      : widget.isAuction
                      ? SizedBox()
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DefaultText(
                            widget.productListModel!.mainPrice,
                            color: secondColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          IconButton(
                            onPressed: () {
                              if (isLogin()) {
                                ToWithFade(
                                  context,
                                  DetailsProductScreen(
                                    idProduct: widget.productListModel!.id!,
                                  ),
                                );
                              } else {
                                showDialogAuth(context);
                              }
                            },
                            icon: const Icon(Icons.add),
                            color: getTheme() ? white : Colors.black,
                          ),
                        ],
                      ),
                ],
              ),
            ),
          ),

          extractDouble(widget.productListModel!.discount) == 0
              ? const SizedBox()
              : PositionedDirectional(
                top: 4,
                end: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: DefaultText(
                    "${widget.productListModel!.discount}",
                    color: white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
          if (widget.productListModel!.shop_logo != null)
            PositionedDirectional(
              bottom: widget.isGrid ? heigth * 0.14 : heigth * 0.12,
              end: 12,
              child: Container(
                height: 50,
                width: 70,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.productListModel!.shop_logo,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
