// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/product_notifire.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/strings_app.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/custom_validation.dart';
import 'package:fils/widget/defualt_text_form_faild.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/item_back.dart';
import 'package:provider/provider.dart';

import '../../../utils/NavigatorObserver/Navigator_observe.dart';
import '../../../utils/global_function/unit8list.dart';
import '../../general/edit_crob_filter_image.dart';

class VariantsDetails extends StatefulWidget {
  final String color;
  final String size;

  const VariantsDetails({super.key, required this.color, required this.size});

  @override
  State<VariantsDetails> createState() => _VariantsDetailsState();
}

class _VariantsDetailsState extends State<VariantsDetails> {
  TextEditingController price = TextEditingController();
  TextEditingController quantity = TextEditingController();
  File? imageFile;

  String? idImageLogo;

  void selectAndUploadImage() async {
    imageFile = await uploadImage();

    if (imageFile != null) {
      setState(() {});
      final edited = await Navigator.push(
        NavigationService.navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (_) => FullImageEditorScreen(imageFile: imageFile!),
        ),
      );
      imageFile = await uint8ListToFile(edited, "${DateTime.now()}.png");
      if (edited != null) {
        uploadImageServer(imageFile!);
      }
    } else {}
    setState(() {});
  }

  clearImage() {
    imageFile = null;
    setState(() {});
  }

  uploadImageServer(File file) async {
    Future.delayed(const Duration(seconds: 1), () async {
      showBoatToast();
      final json = await NetworkHelper.sendRequest(
        requestType: RequestType.post,
        endpoint: "file/upload",
        files: {"aiz_file": file},
      );
      closeAllLoading();
      if (json.containsKey("errorMessage")) {
        clearImage();
      } else {
        idImageLogo = json['data']['id'].toString();
      }
    });
  }

  @override
  void initState() {
    dynamic index = context.read<ProductNotifire>().variantList.indexWhere(
      (element) => element.name == "${widget.color}-${widget.size}",
    );
    if (index != -1) {
      price.text = context.read<ProductNotifire>().variantList[index].price!;
      quantity.text = context.read<ProductNotifire>().variantList[index].qty!;
      imageFile = context.read<ProductNotifire>().variantList[index].fileImage!;
      idImageLogo = context.read<ProductNotifire>().variantList[index].img!;
    }
    super.initState();
  }

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                    itemBackAndTitle(
                      context,
                      title:
                          "Variants details".tr() +
                          " ${widget.color}/${widget.size}",
                    ),
                    SizedBox(height: heigth * 0.05, width: width),
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
                            if (price.text.isEmpty || price.text == "0") {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            isDouble: true,
                            controller: price,
                            textInputType: TextInputType.number,
                            hintText: "500 ${app.currancy}".tr(),
                            pathIconPrefix: "assets/icons/product_price.svg",
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
                            if (imageFile == null) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            onTap: () {
                              selectAndUploadImage();
                            },
                            hintText: "product image".tr(),
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
                        Column(
                          children: [
                            SizedBox(
                              width: width,
                              height: imageFile != null ? heigth * 0.01 : 0,
                            ),
                            imageFile != null
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
                                        imageFile!,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        clearImage();
                                      },
                                      child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: Center(
                                          child: SvgPicture.asset(
                                            "assets/icons/cancel.svg",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                : const SizedBox(),
                          ],
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
                            if (quantity.text.isEmpty) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            controller: quantity,
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
                    SizedBox(height: heigth * 0.1),
                    ButtonWidget(
                      onTap: () {
                        if (!_key.currentState!.validate()) {
                        } else {
                          String name = "";
                          if (widget.size.isEmpty) {
                            name = widget.color;
                          } else if (widget.color.isEmpty) {
                            name = widget.size;
                          } else {
                            name = "${widget.color}-${widget.size}";
                          }
                          controller.addDetailsVariants(
                            price: price.text,
                            img: idImageLogo,
                            qty: quantity.text,
                            name: name,
                            file: imageFile,
                          );
                          Navigator.pop(context);
                        }
                      },
                      title: "Add".tr(),
                    ),
                    SizedBox(height: heigth * 0.02),
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
