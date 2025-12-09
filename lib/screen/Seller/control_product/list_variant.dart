import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/strings_app.dart';
import 'package:fils/widget/custom_validation.dart';
import 'package:flutter/material.dart';

import 'package:fils/controller/provider/product_notifire.dart';
import 'package:fils/screen/Seller/control_product/variants_details.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/item_back.dart';
import 'package:provider/provider.dart';

import '../../../widget/defualt_text_form_faild.dart';

class ListVariant extends StatefulWidget {
  const ListVariant({super.key});

  @override
  State<ListVariant> createState() => _ListVariantState();
}

class _ListVariantState extends State<ListVariant> {
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductNotifire>(
      builder: (context, controller, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: heigth * 0.06, width: width),
                  itemBackAndTitle(context, title: "Variants".tr()),
                  SizedBox(height: heigth * 0.08, width: width),
                  DefaultText(
                    "Variants".tr(),
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: heigth * 0.03),
                  if (controller.colorSelect.isNotEmpty &&
                      controller.sizeSelect.isEmpty)
                    for (
                      dynamic color = 0;
                      color < controller.colorSelect.length;
                      color++
                    )
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ValidateWidget(
                          validator: (value) {
                            if (controller.checkVaireantList(
                              controller.colorSelect[color].name,
                            )) {
                              return null;
                            } else {
                              return requiredField;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            onTap: () {
                              ToWithFade(
                                context,
                                VariantsDetails(
                                  color: controller.colorSelect[color].name,
                                  size: "",
                                ),
                              );
                            },
                            hintText: controller.colorSelect[color].name,
                            pathIconPrefix: "assets/icons/gellary.svg",
                            isIcon: true,
                            pathIcon: "assets/icons/goo.svg",
                          ),
                        ),
                      )
                  else if (controller.colorSelect.isEmpty &&
                      controller.sizeSelect.isNotEmpty)
                    for (
                      dynamic color = 0;
                      color < controller.sizeSelect.length;
                      color++
                    )
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ValidateWidget(
                          validator: (value) {
                            if (controller.checkVaireantList(
                              controller.sizeSelect[color].value,
                            )) {
                              return null;
                            } else {
                              return requiredField;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            onTap: () {
                              ToWithFade(
                                context,
                                VariantsDetails(
                                  color: controller.sizeSelect[color].value,
                                  size: "",
                                ),
                              );
                            },
                            hintText: controller.sizeSelect[color].value,
                            pathIconPrefix: "assets/icons/gellary.svg",
                            isIcon: true,
                            pathIcon: "assets/icons/goo.svg",
                          ),
                        ),
                      )
                  else
                    for (
                      dynamic color = 0;
                      color < controller.colorSelect.length;
                      color++
                    )
                      for (
                        dynamic size = 0;
                        size < controller.sizeSelect.length;
                        size++
                      )
                        ValidateWidget(
                          validator: (value) {
                            if (controller.checkVaireantList(
                              "${controller.colorSelect[color].name}-${controller.sizeSelect[size].value}",
                            )) {
                              return null;
                            } else {
                              return requiredField;
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: TextFormFieldWidget(
                              isPreffix: true,
                              onTap: () {
                                ToWithFade(
                                  context,
                                  VariantsDetails(
                                    color: controller.colorSelect[color].name,
                                    size: controller.sizeSelect[size].value,
                                  ),
                                );
                              },
                              hintText:
                                  "${controller.colorSelect[color].name}/${controller.sizeSelect[size].value}",
                              pathIconPrefix: "assets/icons/gellary.svg",
                              isIcon: true,
                              pathIcon: "assets/icons/goo.svg",
                            ),
                          ),
                        ),
                  // ...List.generate(
                  //   controller.sizeSelect.length * controller.colorSelect.length,
                  //   (index) {
                  //     return Container(
                  //       margin: const EdgeInsets.only(bottom: 10),
                  //       child: TextFormFieldWidget(
                  //         isPreffix: true,
                  //         onTap: () {},
                  //         hintText: "",
                  //         pathIconPrefix: "assets/icons/gellary.svg",
                  //         isIcon: true,
                  //         pathIcon: "assets/icons/goo.svg",
                  //       ),
                  //     );
                  //   },
                  // ),
                  SizedBox(height: 15),
                  ButtonWidget(
                    title: "Done".tr(),
                    onTap: () {
                      if (_key.currentState!.validate()) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
