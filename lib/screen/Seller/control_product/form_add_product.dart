// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/utils/http/dialog_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/controller/provider/product_notifire.dart';
import 'package:fils/screen/Seller/control_product/list_variant.dart';
import 'package:fils/screen/Seller/control_product/show_image.dart';
import 'package:fils/screen/Seller/control_product/show_multi_image.dart';
import 'package:fils/screen/Seller/control_product/variants.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/http/dialog_reauest_multi.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/custom_validation.dart';
import 'package:fils/widget/defualt_text_form_faild.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/item_back.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../model/response/category_response.dart';
import '../../../utils/strings_app.dart';

class FormAddProduct extends StatelessWidget {
  FormAddProduct({super.key});

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return Consumer2<ProductNotifire, AppNotifire>(
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
                            if (controller.productName.text.isEmpty) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            controller: controller.productName,
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
                            if (controller.productPrice.text.isEmpty ||
                                controller.productPrice.text == "0") {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            controller: controller.productPrice,
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
                            controller: controller.productDiscount,
                            textInputType: TextInputType.number,
                            hintText: "0%",
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
                                              controller.changeListCategory(
                                                item,
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
                        showImage(),
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
                                controller.imageFilesList.isNotEmpty
                                    ? "${controller.imageFilesList.length} " +
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
                        showMultiImage(),
                      ],
                    ),
                    SizedBox(height: heigth * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          "Options".tr(),
                          color: blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        SizedBox(width: width, height: heigth * 0.01),
                        ValidateWidget(
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            onTap: () {
                              TowithTrans(
                                context,
                                const OptionScreen(),
                                PageTransitionType.rightToLeft,
                              );
                            },
                            hintText: controller.hintOption.tr(),
                            pathIconPrefix: "assets/icons/add_cir.svg",
                            isIcon: true,
                            pathIcon: "assets/icons/goo.svg",
                          ),
                        ),
                      ],
                    ),
                    controller.sizeSelect.isEmpty &&
                            controller.colorSelect.isEmpty
                        ? const SizedBox()
                        : SizedBox(height: heigth * 0.02),
                    controller.sizeSelect.isEmpty &&
                            controller.colorSelect.isEmpty
                        ? const SizedBox()
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DefaultText(
                              "Variants".tr(),
                              color: blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            SizedBox(width: width, height: heigth * 0.01),
                            ValidateWidget(
                              validator: (value) {
                                bool flag = false;
                                if (controller.variantList.isEmpty) {
                                  return requiredField;
                                } else {
                                  for (var element in controller.variantList) {

                                    if (element.price == null ||
                                        element.qty == null) {
                                      flag = true;
                                      break;
                                    }
                                  }
                                }
                                if (flag) {
                                  return requiredField;
                                } else {
                                  return null;
                                }

                              },
                              child: TextFormFieldWidget(
                                isPreffix: true,
                                onTap: () {
                                  TowithTrans(
                                    context,
                                    const ListVariant(),
                                    PageTransitionType.rightToLeft,
                                  );
                                },
                                hintText:
                                    controller.sizeSelect.isNotEmpty &&
                                            controller.colorSelect.isNotEmpty
                                        ? "${controller.sizeSelect.length * controller.colorSelect.length} "
                                        : controller.sizeSelect.isNotEmpty
                                        ? "${controller.sizeSelect.length} "
                                        : "${controller.colorSelect.length} " +
                                            "Variants".tr(),
                                pathIconPrefix: "assets/icons/gellary.svg",
                                isIcon: true,
                                pathIcon: "assets/icons/goo.svg",
                              ),
                            ),
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
                            if (controller.productQuantity.text.isEmpty) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            controller: controller.productQuantity,
                            textInputType: TextInputType.number,
                            hintText: "2".tr(),
                            pathIconPrefix: "assets/icons/product_quantity.svg",
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
                            if (controller.productDetails.text.isEmpty) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            maxLine: 5,
                            controller: controller.productDetails,
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
                            hintText:
                                controller.videoFile != null
                                    ? "video uploaded".tr()
                                    : "Upload Video".tr(),
                            pathIconPrefix: "assets/icons/gellary_light.svg",
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
                          controller.addProduct();
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
