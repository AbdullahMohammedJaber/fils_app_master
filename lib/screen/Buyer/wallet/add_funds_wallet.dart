// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/widget/item_back.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/wallet_notifire.dart';
import 'package:fils/model/response/paymant_response.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/http/get_object_widget.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/strings_app.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/custom_validation.dart';
import 'package:fils/widget/defualt_text_form_faild.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

class AddFundsWallet extends StatelessWidget {
  AddFundsWallet({super.key});

  TextEditingController balance = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletNotifire>(
      builder: (context, app, child) {
        return Scaffold(
          appBar: AppBar(automaticallyImplyLeading: false, toolbarHeight: 0),
          body: Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: heigth * 0.06),
                    itemBackAndTitle(context, title: "Add Funds".tr()),
                    SizedBox(height: heigth * 0.03),
                    DefaultText(
                      "You must charge your wallet balance in order to enjoy the application features"
                          .tr(),
                      overflow: TextOverflow.visible,
                      color: textColor,
                    ),
                    SizedBox(height: heigth * 0.05),
                    SizedBox(
                      height: heigth * 0.4,
                      child: CustomRequestWidget(
                        url: 'payment-types',
                        requestType: RequestType.get,
                        buildResponse: (p0, p1) {
                          PaymentResponse? pay = p1;

                          return Column(
                            children: [
                              ...List.generate(pay!.data!.length, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    app.selectPaymentMethode(
                                      pay,
                                      pay.data![index].paymentType!,
                                    );
                                  },
                                  child: Container(
                                    height: 60,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color:
                                          getTheme()
                                              ? Colors.black
                                              : const Color(0xffFAFAFA),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: const Color(0xffFAFAFA),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          width: 50,
                                          height: 40,
                                          child: Image.network(
                                            pay.data![index].image!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        DefaultText(
                                          pay.data![index].name,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        const Spacer(),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                            border: Border.all(
                                              color: const Color(0xff898384),
                                            ),
                                          ),
                                          child: Container(
                                            height: 15,
                                            width: 15,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color:
                                                  pay.data![index].isSelect
                                                      ? purpleColor
                                                      : Colors.transparent,
                                            ),
                                            margin: const EdgeInsets.all(2),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          );
                        },
                        parseResponse: (p0) => PaymentResponse.fromJson(p0),
                      ),
                    ),
                    ValidateWidget(
                      validator: (v) {
                        if (balance.text.isEmpty) {
                          return requiredField;
                        } else {
                          return null;
                        }
                      },
                      child: TextFormFieldWidget(
                        hintText: "enter balance".tr(),
                        controller: balance,
                        textInputType: TextInputType.number,
                        textInputAction: TextInputAction.send,
                        onTapDoneKey: (p0) {
                          if (app.paymentMethode == null) {
                            showCustomFlash(
                              message: "Please select payment methode".tr(),
                              messageType: MessageType.Faild,
                            );
                          } else {
                            app.addBalanceRequest(context, balance.text);
                          }
                        },
                      ),
                    ),
                    SizedBox(height: heigth * 0.05),
                    ButtonWidget(
                      title: "Confirm".tr(),
                      onTap: () {
                        if (!_key.currentState!.validate()) {
                        } else {
                          if (app.paymentMethode == null) {
                            showCustomFlash(
                              message: "Please select payment methode".tr(),
                              messageType: MessageType.Faild,
                            );
                          } else {
                            app.addBalanceRequest(context, balance.text);
                          }
                        }
                      },
                    ),
                    SizedBox(height: heigth * 0.05),
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
