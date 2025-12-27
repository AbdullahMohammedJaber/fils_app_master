import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fils/screen/Buyer/favourite/favourait_screen.dart';
import 'package:fils/utils/route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/store_notofire.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:provider/provider.dart';

import '../../../../model/response/details_product_response.dart';
import '../../../../utils/const.dart';
import '../../../../utils/enum/message_type.dart';
import '../../../../utils/enum/request_type.dart';
import '../../../../utils/global_function/image_view.dart';
import '../../../../utils/http/http_helper.dart';
import '../../../../utils/message_app/show_flash_message.dart';
import '../../../../utils/storage/storage.dart';
import '../../../../utils/theme/color_manager.dart';
import '../../../../widget/dialog_auth.dart';
import '../../../../widget/flip_view.dart';

class HeaderDetailsProduct extends StatefulWidget {
  final ProductData details;

  const HeaderDetailsProduct({super.key, required this.details});

  @override
  State<HeaderDetailsProduct> createState() => _HeaderDetailsProductState();
}

class _HeaderDetailsProductState extends State<HeaderDetailsProduct> {
  dynamic selectIndexImage = 0;

  addImage() {
    widget.details.photos!.data.add(
      PhotosDatum(
        id: 0,
        type: "",
        extension: '',
        fileName: "",
        fileOriginalName: "",
        fileSize: 0,
        url: widget.details.thumbnailImg!.data[0].url,
      ),
    );
  }

  @override
  void initState() {
    addImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreNotifire>(
      builder: (context, store, child) {
        return SizedBox(
          height: heigth * 0.6,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GestureDetector(
                  onTap: () {
                    List<String> images = [];
                    for (var element in widget.details.photos!.data) {
                      images.add(element.url);
                    }
                    print(images.length);
                    ToWithFade(
                      context,
                      ImageView(images: images, initialIndex: selectIndexImage),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: widget.details.photos!.data[selectIndexImage].url,
                    placeholder: (context, url) => const LoadingWidgetImage(),
                    errorWidget:
                        (context, url, error) => Image.asset(
                          'assets/test/abaya.png',
                          fit: BoxFit.cover,
                          height: heigth * 0.5,
                          width: double.infinity,
                        ),
                    fit: BoxFit.cover,
                    height: heigth * 0.6,
                    width: double.infinity,
                  ),
                ),
              ),

              // IgnorePointer(
              //   child: Container(
              //     height: heigth * 0.4,
              //     width: width,
              //     decoration: BoxDecoration(
              //       // gradient: LinearGradient(
              //       //   colors: [
              //       //     Colors.black.withOpacity(0.28),
              //       //     Colors.transparent,
              //       //   ],
              //       //   begin: Alignment.topCenter,
              //       //   end: Alignment.center,
              //       // ),
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              // ),
              Positioned(
                top: heigth * 0.05,
                left: width * 0.04,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 45,
                        width: 45,
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: white,
                        ),
                        child: Center(
                          child: FlipView(
                            child: SvgPicture.asset("assets/icons/back.svg"),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (isLogin()) {
                          if (widget.details.is_favorite) {
                            widget.details.is_favorite = false;
                            setState(() {});
                            var json = await NetworkHelper.sendRequest(
                              requestType: RequestType.get,
                              endpoint:
                                  "wishlists-remove-product/${widget.details.id}",
                            );
                            if (!json.containsKey("errorMessage")) {
                              showCustomFlash(
                                message: json['message'],
                                messageType: MessageType.Success,
                              );
                              if (updateControllerFav != null) {
                                updateControllerFav!.update();
                              }
                            }
                          } else {
                            widget.details.is_favorite = true;
                            setState(() {});
                            var json = await NetworkHelper.sendRequest(
                              requestType: RequestType.get,
                              endpoint:
                                  "wishlists-add-product/${widget.details.id}",
                            );
                            if (!json.containsKey("errorMessage")) {
                              showCustomFlash(
                                message: json['message'],
                                messageType: MessageType.Success,
                              );
                              if (updateControllerFav != null) {
                                updateControllerFav!.update();
                              }
                            }
                          }
                        } else {
                          showDialogAuth(context);
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                        ),
                        margin: EdgeInsetsDirectional.only(bottom: 10),
                        child: Center(
                          child: FlipView(
                            child: SvgPicture.asset(
                              widget.details.is_favorite
                                  ? "assets/icons/fav_fill.svg"
                                  : "assets/icons/favourite_home.svg",
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        shareProductLink(widget.details.id);
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: white,
                        ),
                        child: const Center(
                          child: Icon(Icons.share, color: Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: heigth * 0.04,
                right: width * 0.04,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...List.generate(
                      min(widget.details.photos!.data.length, 5),
                      (index) {
                        final isSelected = selectIndexImage == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectIndexImage = index;
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            margin: EdgeInsets.only(bottom: heigth * 0.01),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    isSelected
                                        ? primaryColor
                                        : const Color(0xff898384),
                                width: isSelected ? 2 : 1,
                              ),
                              color: Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: CachedNetworkImage(
                                imageUrl:
                                    widget.details.photos!.data[index].url,
                                placeholder:
                                    (context, url) =>
                                        const LoadingWidgetImage(),
                                errorWidget:
                                    (context, url, error) => Image.asset(
                                      'assets/test/abaya.png',
                                      fit: BoxFit.cover,
                                    ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
