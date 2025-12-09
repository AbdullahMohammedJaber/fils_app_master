// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/utils/http/dialog_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';

import 'package:fils/screen/Seller/control_product/show_multi_image.dart';

import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';

import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/custom_validation.dart';
import 'package:fils/widget/defualt_text_form_faild.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/item_back.dart';
import 'package:provider/provider.dart';
import 'package:fils/model/response/category_response.dart';

import '../../../../../utils/global_function/image_view.dart';
import '../../../../../utils/route/route.dart';
import '../../../../../utils/strings_app.dart';
import '../controller/classifed_product.dart';

class FormAddProductOpenMarket extends StatefulWidget {
  final String? nameCategory;
  final int? idCategory;

  const FormAddProductOpenMarket({
    super.key,
    required this.idCategory,
    required this.nameCategory,
  });

  @override
  State<FormAddProductOpenMarket> createState() =>
      _FormAddProductOpenMarketState();
}

class _FormAddProductOpenMarketState extends State<FormAddProductOpenMarket> {
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return ChangeNotifierProvider(
      create: (context) => ClassifiedProductNotifire(),
      builder: (context, child) {
        final controller = context.watch<ClassifiedProductNotifire>();

        return Consumer<AppNotifire>(
          builder: (context, app, child) {
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SingleChildScrollView(
                  child: Form(
                    key: _key,
                    child: Column(
                      children: [
                        SizedBox(height: heigth * 0.06, width: width),
                        itemBackAndTitle(context, title: "Add Product".tr()),
                        SizedBox(height: heigth * 0.08),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DefaultText(
                              "Product Name".tr(),
                              color: blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            SizedBox(width: width, height: heigth * 0.01),
                            ValidateWidget(
                              validator: (value) {
                                if (controller
                                    .nameProductOpenMarket
                                    .text
                                    .isEmpty) {
                                  return requiredField;
                                } else {
                                  return null;
                                }
                              },
                              child: TextFormFieldWidget(
                                isPreffix: true,
                                controller: controller.nameProductOpenMarket,
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
                              "Product price".tr(),
                              color: blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            SizedBox(width: width, height: heigth * 0.01),
                            ValidateWidget(
                              validator: (value) {
                                if (controller
                                        .priceProductOpenMarket
                                        .text
                                        .isEmpty ||
                                    controller.priceProductOpenMarket.text ==
                                        "0") {
                                  return requiredField;
                                } else {
                                  return null;
                                }
                              },
                              child: TextFormFieldWidget(
                                isPreffix: true,
                                controller: controller.priceProductOpenMarket,
                                textInputType: TextInputType.number,
                                hintText: "500 " + app.currancy.tr(),
                                pathIconPrefix:
                                    "assets/icons/product_price.svg",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: heigth * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DefaultText(
                              "Address".tr(),
                              color: blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            SizedBox(width: width, height: heigth * 0.01),
                            ValidateWidget(
                              validator: (value) {
                                if (controller
                                    .locationProductOpenMarket
                                    .text
                                    .isEmpty) {
                                  return requiredField;
                                } else {
                                  return null;
                                }
                              },
                              child: TextFormFieldWidget(
                                isPreffix: true,
                                controller:
                                    controller.locationProductOpenMarket,
                                textInputType: TextInputType.name,
                                hintText: "Address".tr(),
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
                              "Discount %".tr(),
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
                                controller:
                                    controller.descountProductOpenMarket,
                                textInputType: TextInputType.number,
                                hintText: "0%",
                                pathIconPrefix:
                                    "assets/icons/product_price.svg",
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
                                if (controller.categoryIdOpenMarket == null) {
                                  return requiredField;
                                } else {
                                  return null;
                                }
                              },
                              child: TextFormFieldWidget(
                                isPreffix: true,
                                hintText: controller.categoryNameOpenMarket,
                                pathIconPrefix: "assets/icons/add_cir.svg",
                                isIcon: true,
                                onTap: () {
                                  showCupertinoDialog(
                                    context: context,
                                    builder:
                                        (context) => InfiniteScrollDialog(
                                          endpoint: 'categories',
                                          itemSearchString: (p0) => p0.name,

                                          callback: (Datum? item) {
                                            controller
                                                .changeListCategoryOpenMarket(
                                                  item!,
                                                );
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
                        SizedBox(height: heigth * 0.02),
                        // Upload Product Image Done
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
                                if (controller.imageFileOpenMarket == null) {
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
                                    controller.imageFileOpenMarket != null
                                        ? "Uploaded Images".tr()
                                        : "product image".tr(),
                                pathIconPrefix:
                                    "assets/icons/product_image.svg",
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
                            showImageOpenMarket(),
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
                                  controller.selectAndUploadImagesOpenMarket();
                                },
                                hintText:
                                    controller
                                            .imageFilesListOpenMarket
                                            .isNotEmpty
                                        ? "${controller.imageFilesListOpenMarket.length} " +
                                            "Images".tr()
                                        : "product image".tr(),
                                pathIconPrefix:
                                    "assets/icons/product_image.svg",
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
                            showMultiImage(),
                          ],
                        ),

                        SizedBox(height: heigth * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DefaultText(
                              "Product Quantity".tr(),
                              color: blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            SizedBox(width: width, height: heigth * 0.01),
                            ValidateWidget(
                              validator: (value) {
                                if (controller
                                    .quantityProductOpenMarket
                                    .text
                                    .isEmpty) {
                                  return requiredField;
                                } else {
                                  return null;
                                }
                              },
                              child: TextFormFieldWidget(
                                isPreffix: true,
                                controller:
                                    controller.quantityProductOpenMarket,
                                textInputType: TextInputType.number,
                                hintText: "2".tr(),
                                pathIconPrefix:
                                    "assets/icons/product_quantity.svg",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: width, height: heigth * 0.02),
                        Row(
                          children: [
                            SvgPicture.asset("assets/icons/note.svg"),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DefaultText(
                                "The entry must be a number only.".tr(),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                                overflow: TextOverflow.visible,
                              ),
                            ),
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
                                if (controller
                                    .descriptionProductOpenMarket
                                    .text
                                    .isEmpty) {
                                  return requiredField;
                                } else {
                                  return null;
                                }
                              },
                              child: TextFormFieldWidget(
                                maxLine: 5,
                                controller:
                                    controller.descriptionProductOpenMarket,
                                textInputType: TextInputType.name,
                                hintText: "".tr(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: heigth * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DefaultText(
                              "Upload Product video".tr(),
                              color: blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            SizedBox(width: width, height: heigth * 0.01),
                            ValidateWidget(
                              child: TextFormFieldWidget(
                                isPreffix: true,
                                onTap: () {
                                  controller.selectAndUploadVideo();
                                },
                                hintText: "video uploaded".tr(),
                                pathIconPrefix:
                                    "assets/icons/gellary_light.svg",
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
                            if (controller.videoFile != null)
                              Image.asset(
                                "assets/images/vedio.png",
                                height: 50,
                                width: 50,
                              ),
                          ],
                        ),
                        SizedBox(width: width, height: heigth * 0.02),
                        Row(
                          children: [
                            SvgPicture.asset("assets/icons/note.svg"),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DefaultText(
                                "Only videos up to 30 seconds are allowed".tr(),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: heigth * 0.05),
                        ButtonWidget(
                          onTap: () {
                            if (!_key.currentState!.validate()) {
                            } else {
                              controller.addProductOpenMarket(context);
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
      },
    );
  }

  Widget showMultiImageOpenMarket() {
    return Consumer<ClassifiedProductNotifire>(
      builder: (context, controller, child) {
        return Column(
          children: [
            SizedBox(
              width: width,
              height:
                  controller.imageFilesListOpenMarket.isNotEmpty
                      ? heigth * 0.01
                      : 0,
            ),
            controller.imageFilesListOpenMarket.isNotEmpty
                ? SizedBox(
                  height: 100,
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          GestureDetector(
                            child: Container(
                              width: 100,
                              height: 100,
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: textColor),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  controller.imageFilesListOpenMarket[index],
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                            ),
                            onTap: () {
                              controller.changeIndexSelectImageOpenMarket(
                                index,
                              );
                            },
                          ),
                          controller.selectImageOpenMarket == index
                              ? Row(
                                children: [
                                  GestureDetector(
                                    child: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Center(
                                        child: SvgPicture.asset(
                                          "assets/icons/solar_eye.svg",
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      ToWithFade(
                                        context,
                                        ImageView(
                                          images:
                                              controller
                                                  .imageFilesListOpenMarket,
                                          initialIndex: index,
                                        ),
                                      );
                                    },
                                  ),
                                  GestureDetector(
                                    child: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Center(
                                        child: SvgPicture.asset(
                                          "assets/icons/delete_white.svg",
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      controller.deleteImageSelectOpenMarket(
                                        index,
                                      );
                                    },
                                  ),
                                ],
                              )
                              : const SizedBox(),
                        ],
                      );
                    },
                    separatorBuilder:
                        (context, index) => SizedBox(width: width * 0.05),
                    itemCount: controller.imageFilesListOpenMarket.length,
                  ),
                )
                : const SizedBox(),
          ],
        );
      },
    );
  }

  Widget showImageOpenMarket() {
    return Consumer<ClassifiedProductNotifire>(
      builder: (context, controller, child) {
        return Column(
          children: [
            SizedBox(
              width: width,
              height:
                  controller.imageFileOpenMarket != null ? heigth * 0.01 : 0,
            ),
            controller.imageFileOpenMarket != null
                ? Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      width: width,
                      height: heigth * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: textColor),
                      ),
                      child: Image.file(
                        controller.imageFileOpenMarket!,
                        fit: BoxFit.contain,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.clearImageOpenMarket();
                      },
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: SvgPicture.asset("assets/icons/cancel.svg"),
                        ),
                      ),
                    ),
                  ],
                )
                : const SizedBox(),
          ],
        );
      },
    );
  }
}
