// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/utils/http/dialog_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/aucation_notifier.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/screen/Seller/control_product/show_image.dart';
import 'package:fils/screen/Seller/control_product/show_multi_image.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/timer_format.dart';
import 'package:fils/utils/http/dialog_reauest_multi.dart';

import 'package:fils/utils/strings_app.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/custom_validation.dart';
import 'package:fils/widget/defualt_text_form_faild.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/item_back.dart';
import 'package:provider/provider.dart';

import '../../../model/response/category_response.dart';
import '../../../utils/enum/message_type.dart';
import '../../../utils/message_app/show_flash_message.dart';
import '../../../utils/storage/storage.dart';
import '../../../widget/button_widget.dart';

class FormAddAuction extends StatelessWidget {
  FormAddAuction({super.key});

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return Consumer2<AuctionNotifier, AppNotifire>(
      builder: (context, controller, app, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    SizedBox(height: heigth * 0.06, width: width),
                    itemBackAndTitle(context, title: "Add Auction".tr()),
                    SizedBox(height: heigth * 0.08),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          "Auction Name".tr(),
                          color: blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        SizedBox(width: width, height: heigth * 0.01),
                        ValidateWidget(
                          validator: (value) {
                            if (controller.auctionName.text.isEmpty) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            controller: controller.auctionName,
                            textInputType: TextInputType.name,
                            hintText: "Toyota car".tr(),
                            pathIconPrefix: "assets/icons/product_name.svg",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: heigth * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          "Initial price".tr(),
                          color: blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        SizedBox(width: width, height: heigth * 0.01),
                        ValidateWidget(
                          validator: (value) {
                            if (controller.auctionPrice.text.isEmpty ||
                                controller.auctionPrice.text == "0") {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            isDouble: true,
                            controller: controller.auctionPrice,
                            textInputType: TextInputType.number,
                            hintText: "500 " + app.currancy.tr(),
                            pathIconPrefix: "assets/icons/product_price.svg",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: heigth * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          "Assurance Fee".tr(),
                          color: blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        SizedBox(width: width, height: heigth * 0.01),
                        ValidateWidget(
                          validator: (value) {
                            return null;
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            isDouble: true,
                            controller: controller.assurance_fee,
                            textInputType: TextInputType.number,
                            hintText: "0 ${app.currancy.tr()}".tr(),
                            pathIconPrefix: "assets/icons/product_price.svg",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: heigth * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          "Category".tr(),
                          color: blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        SizedBox(width: width, height: heigth * 0.01),
                        ValidateWidget(
                          validator: (value) {
                            if (controller.categoryIdSelect == null) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            hintText: controller.categoryNameSelect,
                            pathIconPrefix: "assets/icons/add_cir.svg",
                            isIcon: true,
                            onTap: () {
                              showCupertinoDialog(
                                context: context,
                                builder:
                                    (context) => InfiniteScrollDialog(
                                      endpoint: 'categories',
                                      itemSearchString: (p0) => p0.name,

                                      callback: (item) {
                                        controller.changeCategoryId(
                                          item!.id,
                                          item.name,
                                        );
                                        controller.categoryId = [];
                                        controller.categoryName = [];
                                        controller.category = "";
                                      },
                                      requestType: RequestType.get,
                                      title: "Category".tr(),
                                      itemBuilder: (context, item) {
                                        return DefaultText(
                                          item.name,
                                          overflow: TextOverflow.visible,
                                          fontSize: 12,
                                        );
                                      },
                                      parseResponse: (p0) => Datum.fromJson(p0),
                                    ),
                              );
                            },
                            pathIcon: "assets/icons/drob.svg",
                          ),
                        ),
                        SizedBox(height: heigth * 0.02),
                        if (controller.categoryIdSelect != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DefaultText(
                                "Category".tr(),
                                color: blackColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              SizedBox(width: width, height: heigth * 0.01),
                              ValidateWidget(
                                validator: (value) {
                                  if (controller.categoryId.isEmpty) {
                                    return requiredField;
                                  } else {
                                    return null;
                                  }
                                },
                                child: TextFormFieldWidget(
                                  isPreffix: true,
                                  hintText: controller.category,
                                  pathIconPrefix: "assets/icons/add_cir.svg",
                                  isIcon: true,
                                  onTap: () {
                                    showCupertinoDialog(
                                      context: context,
                                      builder:
                                          (context) => MultiSelectScrollDialog(
                                            endpoint:
                                                'sub-categories/${controller.categoryIdSelect}',
                                            itemSearchString: (p0) => p0.name,

                                            callback: (item) {
                                              controller.changeListCategory(item);
                                            },
                                            requestType: RequestType.get,
                                            title: "Category".tr(),
                                            itemBuilder: (context, item) {
                                              return DefaultText(
                                                item.name,
                                                overflow: TextOverflow.visible,
                                                fontSize: 12,
                                              );
                                            },
                                            parseResponse:
                                                (p0) => Datum.fromJson(p0),
                                          ),
                                    );
                                  },
                                  pathIcon: "assets/icons/drob.svg",
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    SizedBox(height: heigth * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          "Auction type".tr(),
                          color: blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        SizedBox(width: width, height: heigth * 0.01),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (getPackageInfo().data!.liveAuction == 1) {
                                  controller.changeTypeAuction(0);
                                } else {
                                  showCustomFlash(
                                    message:
                                        "You are not allowed to add interactive selling. Develop a subscription package."
                                            .tr(),
                                    messageType: MessageType.Faild,
                                  );
                                }
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: grey4),
                                  color:
                                      controller.auctionType == 0
                                          ? secondColor
                                          : white,
                                ),
                                child:
                                    controller.auctionType == 0
                                        ? Center(
                                          child: SvgPicture.asset(
                                            "assets/icons/check.svg",
                                          ),
                                        )
                                        : null,
                              ),
                            ),
                            const SizedBox(width: 5),
                            DefaultText("Live Auction".tr(), color: textColor),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                if (getPackageInfo().data!.normalAuction == 1) {
                                  controller.changeTypeAuction(1);
                                } else {
                                  showCustomFlash(
                                    message:
                                        "You are not allowed to add a regular auction. Develop a subscription package."
                                            .tr(),
                                    messageType: MessageType.Faild,
                                  );
                                }
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: grey4),
                                  color:
                                      controller.auctionType == 1
                                          ? secondColor
                                          : white,
                                ),
                                child:
                                    controller.auctionType == 1
                                        ? Center(
                                          child: SvgPicture.asset(
                                            "assets/icons/check.svg",
                                          ),
                                        )
                                        : null,
                              ),
                            ),
                            const SizedBox(width: 5),
                            DefaultText(
                              "Product Auction".tr(),
                              color: textColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: heigth * 0.02),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DefaultText(
                                "Start Date".tr(),
                                color: blackColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              SizedBox(width: width, height: heigth * 0.01),
                              ValidateWidget(
                                validator: (value) {
                                  return null;
                                },
                                child: TextFormFieldWidget(
                                  isPreffix: true,
                                  hintText: formatDate2(controller.dataStart),
                                  pathIconPrefix: "assets/icons/calendar.svg",
                                  onTap: () async {
                                    controller.selectStartDate(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DefaultText(
                                "End Date".tr(),
                                color: blackColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              SizedBox(width: width, height: heigth * 0.01),
                              ValidateWidget(
                                validator: (value) {
                                  return null;
                                },
                                child: TextFormFieldWidget(
                                  isPreffix: true,
                                  onTap: () {
                                    controller.selectEndDate(context);
                                  },
                                  hintText: formatDate2(controller.dataEnd),
                                  pathIconPrefix: "assets/icons/calendar.svg",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: heigth * 0.02),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DefaultText(
                                "Start Time".tr(),
                                color: blackColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              SizedBox(width: width, height: heigth * 0.01),
                              ValidateWidget(
                                validator: (value) {
                                  return null;
                                },
                                child: TextFormFieldWidget(
                                  isPreffix: true,
                                  onTap: () {
                                    controller.selectStartTime(context);
                                  },
                                  hintText: formatTimeOfDay2(
                                    controller.timeStart,
                                  ),
                                  pathIconPrefix: "assets/icons/clock.svg",
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DefaultText(
                                "End Time".tr(),
                                color: blackColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              SizedBox(width: width, height: heigth * 0.01),
                              ValidateWidget(
                                validator: (value) {
                                  return null;
                                },
                                child: TextFormFieldWidget(
                                  isPreffix: true,
                                  onTap: () {
                                    controller.selectEndTime(context);
                                  },
                                  hintText: formatTimeOfDay2(
                                    controller.timeEnd,
                                  ),
                                  pathIconPrefix: "assets/icons/clock.svg",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: heigth * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            DefaultText(
                              "Upload Product image".tr(),
                              color: blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            DefaultText(
                              " * ".tr(),
                              color: error40,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ],
                        ),
                        SizedBox(width: width, height: heigth * 0.01),
                        ValidateWidget(
                          validator: (value) {
                            if (controller.imageFile == null) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            onTap: () {
                              controller.selectAndUploadImage();
                            },
                            hintText:
                                controller.imageFile != null
                                    ? "Uploaded Images".tr()
                                    : "product image".tr(),
                            pathIconPrefix: "assets/icons/product_image.svg",
                            customIcon: Container(
                              width: width * 0.1,
                              height: heigth * 0.06,
                              decoration: BoxDecoration(
                                color: greyLight,
                                borderRadius:
                                    const BorderRadiusDirectional.only(
                                      bottomEnd: Radius.circular(12),
                                      topEnd: Radius.circular(12),
                                    ),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/icons/gellary_black.svg",
                                ),
                              ),
                            ),
                          ),
                        ),
                        showImageAuction(),
                      ],
                    ),
                    SizedBox(height: heigth * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          "Upload many Product image (optional)".tr(),
                          color: blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        SizedBox(width: width, height: heigth * 0.01),
                        ValidateWidget(
                          validator: (value) {
                            return null;
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            onTap: () {
                              controller.selectAndUploadImages();
                            },
                            hintText:
                                controller.idImagesLogo.isNotEmpty
                                    ? "${controller.idImagesLogo.length} " +
                                        "Images".tr()
                                    : "product image".tr(),
                            pathIconPrefix: "assets/icons/product_image.svg",
                            customIcon: Container(
                              width: width * 0.1,
                              height: heigth * 0.06,
                              decoration: BoxDecoration(
                                color: greyLight,
                                borderRadius:
                                    const BorderRadiusDirectional.only(
                                      bottomEnd: Radius.circular(12),
                                      topEnd: Radius.circular(12),
                                    ),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/icons/gellary_black.svg",
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: width, height: heigth * 0.01),
                        showMultiImageAuction(),
                      ],
                    ),
                    SizedBox(height: heigth * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          "Product details".tr(),
                          color: blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        SizedBox(width: width, height: heigth * 0.01),
                        ValidateWidget(
                          validator: (value) {
                            if (controller.auctionDetails.text.isEmpty) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            maxLine: 5,
                            controller: controller.auctionDetails,
                            textInputType: TextInputType.text,
                            hintText: "".tr(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: heigth * 0.05),
                    ButtonWidget(
                      onTap: () async {
                        if (!_key.currentState!.validate()) {
                        } else {
                          controller.addAuction();
                        }
                      },
                      title: "Add".tr(),
                      fontType: FontType.SemiBold,
                      colorButton: secondColor,
                    ),
                    SizedBox(height: heigth * 0.1),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
