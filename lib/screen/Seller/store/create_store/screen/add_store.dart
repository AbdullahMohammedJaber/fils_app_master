import 'package:easy_localization/easy_localization.dart';
import 'package:fils/main.dart';
import 'package:fils/utils/strings_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/item_back.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/storage/storage.dart';
import '../../../../../widget/custom_validation.dart';
import '../../../../../widget/defualt_text_form_faild.dart';
import '../../../../../widget/flip_view.dart';
import '../controller/create_store_notifire.dart';

class AddStoreSeller extends StatefulWidget {
  final bool isComeSignup;

  const AddStoreSeller({super.key, required this.isComeSignup});

  @override
  State<AddStoreSeller> createState() => _AddStoreSellerState();
}

class _AddStoreSellerState extends State<AddStoreSeller> {
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreateStoreNotifire(),
      lazy: true,
      builder: (context, child) {
        final controller = Provider.of<CreateStoreNotifire>(
          context,
          listen: true,
        );
        return Scaffold(
          appBar: AppBar(toolbarHeight: 0),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _key,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: heigth * 0.06, width: width),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (widget.isComeSignup) {
                              RestartWidget.restartApp(context);
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: SizedBox(
                            height: getLang() == 'ar' ? 30 : 28,
                            width: 40,
                            child: FlipView(
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/icons/back.svg",
                                  color: getTheme() ? white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: width * 0.01),
                        DefaultText(
                          "Add about store".tr(),
                          color: primaryDarkColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),

                    SizedBox(height: heigth * 0.03),
                    DefaultText(
                      "Store Add".tr(),
                      color: primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: heigth * 0.02),
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
                            if (controller.nameStoreC.text.isEmpty) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            controller: controller.nameStoreC,
                            textInputType: TextInputType.name,
                            hintText: "Online store name".tr(),
                            pathIconPrefix: "assets/icons/store.svg",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: heigth * 0.02),
                    // Upload Product Image Done
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
                            if (controller.imageFileC == null) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            onTap: () {
                              controller.selectAndUploadImageC();
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
                        showImageStoreCreate(),
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
                            if (controller.addressStoreC.text.isEmpty) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            controller: controller.addressStoreC,
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
                            if (controller.passportNumberC.text.isEmpty) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            controller: controller.passportNumberC,
                            textInputType: TextInputType.number,
                            hintText: "298354875".tr(),
                            pathIconPrefix: "assets/icons/identety.svg",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: heigth * 0.02),
                    Row(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.changeTypeStore(1);
                              },
                              child: Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                  border: Border.all(color: textColor),
                                ),
                                child:
                                    controller.typeStore == 1
                                        ? Container(
                                          height: 15,
                                          width: 15,
                                          margin: EdgeInsets.all(2),
                                          color: primaryColor,
                                        )
                                        : null,
                              ),
                            ),
                            SizedBox(width: 15),
                            DefaultText(
                              "${"Home Store".tr()}\n${"(not license)".tr()}",
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.changeTypeStore(2);
                              },
                              child: Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                  border: Border.all(color: textColor),
                                ),
                                child:
                                    controller.typeStore == 2
                                        ? Container(
                                          height: 15,
                                          width: 15,
                                          margin: EdgeInsets.all(2),
                                          color: primaryColor,
                                        )
                                        : null,
                              ),
                            ),
                            SizedBox(width: 15),
                            DefaultText(
                              "${"Store out".tr()}\n${"(license)".tr()}",
                            ),
                          ],
                        ),
                      ],
                    ),
                    controller.typeStore == 1
                        ? SizedBox()
                        : Column(
                          children: [
                            SizedBox(height: heigth * 0.02),
                            // Upload Product Image Done
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
                                    if (controller
                                            .licenseNumberC
                                            .text
                                            .isEmpty &&
                                        controller.typeStore == 2) {
                                      return requiredField;
                                    } else {
                                      return null;
                                    }
                                  },
                                  child: TextFormFieldWidget(
                                    isPreffix: true,
                                    controller: controller.licenseNumberC,
                                    textInputType: TextInputType.name,
                                    hintText: "License Number".tr(),
                                    pathIconPrefix:
                                        "assets/icons/product_image.svg",
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
                                    if (controller.fileLicenseC == null &&
                                        controller.typeStore == 2) {
                                      return requiredField;
                                    } else {
                                      return null;
                                    }
                                  },
                                  child: TextFormFieldWidget(
                                    isPreffix: true,
                                    onTap: () {
                                      controller.selectAndUploadFileC();
                                    },
                                    hintText: "License Image".tr(),
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
                              ],
                            ),
                          ],
                        ),

                    SizedBox(height: heigth * 0.04),

                    ButtonWidget(
                      title: "Send".tr(),
                      onTap: () {
                        if (!_key.currentState!.validate()) {
                        } else {
                          controller.createStoreFunction(widget.isComeSignup);
                        }
                      },
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

  Widget showImageStoreCreate() {
    return Consumer<CreateStoreNotifire>(
      builder: (context, controller, child) {
        return Column(
          children: [
            SizedBox(
              width: width,
              height: controller.imageFileC != null ? heigth * 0.01 : 0,
            ),
            controller.imageFileC != null
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
                        controller.imageFileC!,
                        fit: BoxFit.contain,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.clearImageCreate();
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
