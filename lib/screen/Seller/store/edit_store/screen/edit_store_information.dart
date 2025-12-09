import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fils/utils/const.dart';

import 'package:fils/utils/strings_app.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/item_back.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/theme/color_manager.dart';
import '../../../../../widget/custom_validation.dart';
import '../../../../../widget/defualt_text_form_faild.dart';
import '../../../../../widget/defulat_text.dart';
import '../controller/edit_store_notifire.dart';

class EditStoreInformation extends StatelessWidget {
  EditStoreInformation({super.key});

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return ChangeNotifierProvider(
      create: (context) => EditStoreNotifire(),
      lazy: true,
      builder: (context, child) {
        final controller = Provider.of<EditStoreNotifire>(
          context,
          listen: true,
        );
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    SizedBox(height: heigth * 0.08),
                    itemBackAndTitle(
                      context,
                      title: "Edit Store Information".tr(),
                    ),
                    SizedBox(height: heigth * 0.04),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          "Online store name".tr(),
                          color: blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        SizedBox(width: width, height: heigth * 0.01),
                        ValidateWidget(
                          validator: (value) {
                            if (controller.nameStore.text.isEmpty) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            controller: controller.nameStore,
                            textInputType: TextInputType.name,
                            hintText: "Online store name".tr(),
                            pathIconPrefix: "assets/icons/store.svg",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: heigth * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          "Upload Logo Image".tr(),
                          color: blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        SizedBox(width: width, height: heigth * 0.01),
                        ValidateWidget(
                          validator: (value) {
                            if (controller.imageFile == null && controller.logoUrl == null) {
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
                            hintText: "Logo Image".tr(),
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
                        showImageStore(),
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
                            if (controller.addressStore.text.isEmpty) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            controller: controller.addressStore,
                            textInputType: TextInputType.name,
                            hintText: "Address".tr(),
                            pathIconPrefix: "assets/icons/address.svg",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: heigth * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          "description".tr(),
                          color: blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        SizedBox(width: width, height: heigth * 0.01),
                        ValidateWidget(
                          validator: (value) {
                            if (controller.dec.text.isEmpty) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: false,
                            controller: controller.dec,
                            textInputType: TextInputType.name,
                            hintText: "description".tr(),

                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: heigth * 0.02),
                    Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          "ID or passport number".tr(),
                          color: blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        SizedBox(width: width, height: heigth * 0.01),
                        ValidateWidget(
                          validator: (value) {
                            if (controller.idNumber.text.isEmpty) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            controller: controller.idNumber,
                            textInputType: TextInputType.number,
                            hintText: "ID or passport number".tr(),
                            pathIconPrefix: "assets/icons/product_image.svg",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: heigth * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          "License Number".tr(),
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
                            controller: controller.licenseNumber,
                            textInputType: TextInputType.text,
                            hintText: "License Number".tr(),
                            pathIconPrefix: "assets/icons/product_image.svg",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: heigth * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          "Upload License Image".tr(),
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
                              controller.selectAndUploadFile();
                            },
                            hintText: "License Image".tr(),
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
                        showImageStoreLin(),
                      ],
                    ),
                    SizedBox(height: heigth * 0.04),
                    ButtonWidget(
                      onTap: () {
                        if (!_key.currentState!.validate()) {
                        } else {
                          controller.functionEditDataStore(context);
                        }
                      },
                      colorButton: secondColor,
                      title: "Save Change".tr(),
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

  Widget showImageStore() {
    return Consumer<EditStoreNotifire>(
      builder: (context, controller, child) {
        return Column(
          children: [
            SizedBox(
              width: width,
              height: controller.imageFile != null ? heigth * 0.01 : 0,
            ),
            if (controller.logoUrl != null && controller.imageFile == null)
              Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Container(
                    width: width,
                    height: heigth * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: textColor),
                    ),
                    child: Image.network(
                      controller.logoUrl!,
                      fit: BoxFit.contain,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.clearImage();
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
              ),
            controller.imageFile != null
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
                        controller.imageFile!,
                        fit: BoxFit.contain,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.clearImage();
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

  Widget showImageStoreLin() {
    return Consumer<EditStoreNotifire>(
      builder: (context, controller, child) {
        return Column(
          children: [
            SizedBox(
              width: width,
              height: controller.fileLicense != null ? heigth * 0.01 : 0,
            ),
            controller.fileLicense != null
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
                        controller.fileLicense!,
                        fit: BoxFit.contain,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.clearImageL();
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
