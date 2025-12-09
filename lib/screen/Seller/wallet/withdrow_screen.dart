// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fils/controller/provider/wallet_notifire.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/defualt_text_form_faild.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

class WithdrowScreen extends StatelessWidget {
  final String wallet;

  const WithdrowScreen({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Consumer2<WalletNotifire, AppNotifire>(
      builder: (context, controller, app, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                SizedBox(width: width, height: heigth * 0.08),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.changeStepTow(false);
                      },
                      child: const StepCircle(stepNumber: '1', isActive: true),
                    ),
                    // Dotted Line
                    Expanded(
                      child: DottedLine(
                        dashLength: 5,
                        dashColor: controller.stepTow ? purpleColor : textColor,
                      ),
                    ),
                    // Second step (Inactive)
                    StepCircle(stepNumber: '2', isActive: controller.stepTow),
                  ],
                ),
                SizedBox(width: width, height: heigth * 0.03),
                DefaultText(
                  controller.stepTow
                      ? "In the tow step, you must enter the visa data you want to charge from."
                          .tr()
                      : "In the first step, enter the amount you want to charge to the wallet"
                          .tr(),
                  color: textColor,
                  overflow: TextOverflow.visible,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(width: width, height: heigth * 0.05),
                controller.stepTow
                    ? Container(
                      height: 40,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffFAFAFA),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/bank.svg",
                              color: Colors.black,
                            ),
                            const SizedBox(width: 10),
                            DefaultText(
                              ("**** ${getShopInfo().data!.bankAccNo.substring(getShopInfo().data!.bankAccNo.length - 4)}"),
                            ),
                            const Spacer(),
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: textColor),
                              ),
                              child: Container(
                                height: 20,
                                width: 20,
                                margin: const EdgeInsets.all(1.2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: purpleColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    : Container(
                      height: heigth * 0.12,
                      width: width,
                      decoration: BoxDecoration(
                        color: purpleColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DefaultText(
                                wallet,
                                color: white,
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(width: width * 0.015),
                              DefaultText(
                                "Usd",
                                color: white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                          SizedBox(height: heigth * 0.01),
                          DefaultText(
                            "+${app.currancy} 0.00 pending",
                            color: white,
                            fontSize: 8,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                SizedBox(width: width, height: heigth * 0.05),
                controller.stepTow
                    ? const SizedBox()
                    : Row(
                      children: [
                        ...List.generate(controller.walletList.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              controller.changeSelectValueWallet(
                                controller.walletList[index],
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsetsDirectional.only(
                                start: 5,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: purpleColor),
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    controller.walletList[index].isSelect
                                        ? purpleColor
                                        : white,
                              ),
                              child: Center(
                                child: DefaultText(
                                  "${app.currancy} ${controller.walletList[index].price.toString()}",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      controller.walletList[index].isSelect
                                          ? white
                                          : primaryDarkColor,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                controller.stepTow
                    ? const SizedBox()
                    : SizedBox(width: width, height: heigth * 0.05),
                controller.stepTow
                    ? const SizedBox()
                    : DefaultText(
                      "Amount".tr(),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                DefaultText(
                  "${app.currancy}${controller.priceController.text}",
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(width: width, height: heigth * 0.05),
                ButtonWidget(
                  onTap: () async {
                    if (controller.stepOne) {
                      if (controller.priceController.text == "0" ||
                          controller.priceController.text == "0.0" ||
                          controller.priceController.text.isEmpty) {
                        showCustomFlash(
                          message: "Please insert amount".tr(),
                          messageType: MessageType.Faild,
                        );
                      } else {
                        controller.changeStepTow(true);
                      }
                    } else {
                      await showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.only(
                            topEnd: Radius.circular(15),
                            topStart: Radius.circular(15),
                          ),
                        ),
                        builder: (context) {
                          return const DialogConfirmWidthrawal();
                        },
                      );
                    }
                  },
                  title:
                      controller.stepTow
                          ? "Confirm Withdrawal".tr()
                          : "Next step".tr(),
                  colorButton: secondColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class StepCircle extends StatelessWidget {
  final String stepNumber;
  final bool isActive;

  const StepCircle({
    super.key,
    required this.stepNumber,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? Colors.purple : Colors.grey,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            stepNumber,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class PriceInputDialog extends StatelessWidget {
  const PriceInputDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletNotifire>(
      builder: (context, controller, child) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultText(
                    "Enter amount withdraw".tr(),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: heigth * 0.02),
                  TextFormFieldWidget(
                    controller: controller.priceController,
                    isPreffix: true,
                    pathIconPrefix: "assets/icons/product_price.svg",
                    hintText: "0.0",
                    textInputType: TextInputType.number,
                  ),
                  SizedBox(height: heigth * 0.02),
                  ButtonWidget(
                    onTap: () {
                      Navigator.pop(context);
                      controller.changePrice();
                    },
                    title: "Done".tr(),
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

class DialogConfirmWidthrawal extends StatelessWidget {
  const DialogConfirmWidthrawal({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<WalletNotifire, AppNotifire>(
      builder: (context, controller, app, child) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  DefaultText(
                    "Confirm Withdrawal".tr(),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      color: Colors.transparent,
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/icons/x.svg",
                          color: blackColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: heigth * 0.02),
              DefaultText(
                "Summary".tr(),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: heigth * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.00),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffE8E2F8)),
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: heigth * 0.01),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            DefaultText(
                              "Method".tr(),
                              color: secondColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            const Spacer(),
                            DefaultText(
                              "Bank Transfer".tr(),
                              color: secondColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            DefaultText(
                              "Fee".tr(),
                              color: secondColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            const Spacer(),
                            DefaultText(
                              "${app.currancy} 2.00".tr(),
                              color: secondColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            DefaultText(
                              "Estimated Arrival".tr(),
                              color: secondColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            const Spacer(),
                            DefaultText(
                              "1-3 business days".tr(),
                              color: secondColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                      const Divider(thickness: 1),
                      SizedBox(height: heigth * 0.01),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            DefaultText(
                              "Amount".tr(),
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            const Spacer(),
                            DefaultText(
                              "${app.currancy}${controller.priceController.text}"
                                  .tr(),
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: heigth * 0.02),
                    ],
                  ),
                ),
              ),
              SizedBox(height: heigth * 0.03),
              Row(
                children: [
                  SvgPicture.asset("assets/icons/note.svg"),
                  SizedBox(width: width * 0.01),
                  DefaultText(
                    "Note".tr(),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ],
              ),
              SizedBox(height: heigth * 0.01),
              DefaultText(
                "Once submitted, withdrawals cannot be canceled.".tr(),
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
              SizedBox(height: heigth * 0.03),
              ButtonWidget(
                colorButton: secondColor,
                title: "Confirm Withdrawal".tr(),
                onTap: () {
                  Navigator.pop(context);
                  controller.withdrawalFunction(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
