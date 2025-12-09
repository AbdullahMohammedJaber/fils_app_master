import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:fils/controller/provider/wallet_notifire.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/strings_app.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/custom_validation.dart';
import 'package:fils/widget/defualt_text_form_faild.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/item_back.dart';
import 'package:provider/provider.dart';

class BankSetting extends StatefulWidget {
  const BankSetting({super.key});

  @override
  State<BankSetting> createState() => _BankSettingState();
}

class _BankSettingState extends State<BankSetting> {
  final _key = GlobalKey<FormState>();

  _init() {
    if (getShopInfo().data!.bankName.toString() == "null" ||
        getShopInfo().data!.bankName == null) {
      context.read<WalletNotifire>().bankName.clear();
    } else {
      context.read<WalletNotifire>().bankName.text =
          getShopInfo().data!.bankName;
    }

    context.read<WalletNotifire>().ownerName.text = getUser()!.user!.name;
    if (getShopInfo().data!.bankAccNo.toString() == "null" ||
        getShopInfo().data!.bankAccNo == null) {
      context.read<WalletNotifire>().bankNo.clear();
    } else {
      context.read<WalletNotifire>().bankNo.text =
          getShopInfo().data!.bankAccNo;
    }
  }

  @override
  void initState() {
    _init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletNotifire>(
      builder: (context, controller, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Form(
              key: _key,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: heigth * 0.06, width: width),
                    itemBackAndTitle(context, title: "Bank Settings".tr()),
                    SizedBox(height: heigth * 0.05, width: width),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          "Bank Name".tr(),
                          color: blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        SizedBox(width: width, height: heigth * 0.01),
                        ValidateWidget(
                          validator: (value) {
                            if (controller.bankName.text.isEmpty) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            controller: controller.bankName,
                            onTap: () async {
                              controller
                                  .bankName
                                  .text = await selectStringDialog(
                                context,
                                list: bankList,
                                title: "Select Bank".tr(),
                              );
                            },
                            hintText: "Central Bank of kuweit".tr(),
                            pathIconPrefix: "assets/icons/bank.svg",
                            isIcon: true,
                            pathIcon: "assets/icons/edit.svg",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: width, height: heigth * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          "Owner Name".tr(),
                          color: blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        SizedBox(width: width, height: heigth * 0.01),
                        ValidateWidget(
                          validator: (value) {
                            if (controller.ownerName.text.isEmpty) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            controller: controller.ownerName,
                            textInputType: TextInputType.name,
                            hintText: "Owner Name".tr(),
                            pathIconPrefix: "assets/icons/bank.svg",
                            isIcon: true,
                            pathIcon: "assets/icons/edit.svg",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: width, height: heigth * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          "Bank account number".tr(),
                          color: blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        SizedBox(width: width, height: heigth * 0.01),
                        ValidateWidget(
                          validator: (value) {
                            if (controller.bankNo.text.isEmpty) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            controller: controller.bankNo,
                            textInputType: TextInputType.number,
                            hintText: "********".tr(),
                            pathIconPrefix: "assets/icons/product_image.svg",
                            isIcon: true,
                            pathIcon: "assets/icons/edit.svg",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: width, height: heigth * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          "IBAN Number".tr(),
                          color: blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        SizedBox(width: width, height: heigth * 0.01),
                        ValidateWidget(
                          validator: (value) {
                            if (controller.bankIban.text.isEmpty) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            isPreffix: true,
                            controller: controller.bankIban,
                            textInputType: TextInputType.name,
                            hintText: "AHD996865854096055".tr(),
                            pathIconPrefix: "assets/icons/bank.svg",
                            isIcon: true,
                            pathIcon: "assets/icons/edit.svg",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: width, height: heigth * 0.02),
                    SizedBox(width: width, height: heigth * 0.1),
                    ButtonWidget(
                      onTap: () {
                        if (!_key.currentState!.validate()) {
                        } else {
                          controller.setupBankAccount(context);
                        }
                      },
                      title: "Save Change".tr(),
                      colorButton: secondColor,
                    ),
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
