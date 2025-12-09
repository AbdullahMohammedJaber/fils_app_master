import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/flip_view.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../controller/forget_password_notifire.dart';

class PinInputCodeScreen extends StatefulWidget {
  final String email;

  const PinInputCodeScreen({super.key, required this.email});

  @override
  State<PinInputCodeScreen> createState() => _PinInputCodeScreenState();
}

class _PinInputCodeScreenState extends State<PinInputCodeScreen> {
  final focusNode = FocusNode();

  TextEditingController pinController = TextEditingController();

  late Timer timer;

  dynamic remainingTime = 59;

  startTimer() {
    remainingTime = 59;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
        setState(() {});
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 40,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      textStyle: const TextStyle(
        fontSize: 18,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: grey6,
      ),
    );
    return ChangeNotifierProvider(
      create: (context) => ForgetPasswordNotifire(),
      child: Consumer<ForgetPasswordNotifire>(
        builder: (context, app, child) {
          return Scaffold(
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: width, height: heigth * 0.1),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: FlipView(
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/icons/back.svg",
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        DefaultText(
                          "FORGET PASSWORD".tr(),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        const Spacer(),
                      ],
                    ),
                    SizedBox(width: width, height: heigth * 0.08),
                    DefaultText(
                      "Enter the code sent to your phone number and email".tr(),
                      textAlign: TextAlign.start,
                      fontSize: 18,
                      overflow: TextOverflow.visible,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff433E3F),
                    ),
                    SizedBox(width: width, height: heigth * 0.02),
                    DefaultText(
                      "Add the 5-digit code to confirm your account".tr(),
                      textAlign: TextAlign.start,
                      fontSize: 14,
                      overflow: TextOverflow.visible,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                    SizedBox(width: width, height: heigth * 0.06),
                    Center(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Pinput(
                          length: 6,
                          controller: pinController,
                          focusNode: focusNode,
                          defaultPinTheme: defaultPinTheme,
                          validator: (value) {
                            return value!.isEmpty || value.length < 4
                                ? 'Pin is incorrect'.tr()
                                : null;
                          },
                          hapticFeedbackType: HapticFeedbackType.lightImpact,
                          onCompleted: (pin) {
                            pinController.text = pin;
                            setState(() {});
                          },
                          cursor: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(width: 15, height: 1, color: white),
                            ],
                          ),
                          focusedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              borderRadius: BorderRadius.circular(10),
                              color: white,
                              border: Border.all(color: primaryColor),
                            ),
                          ),
                          submittedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              borderRadius: BorderRadius.circular(10),
                              color: white,
                              border: Border.all(color: primaryColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: width, height: heigth * 0.02),
                    Center(
                      child: DefaultText(
                        "00:${remainingTime < 10 ? "0${remainingTime.toString()}" : remainingTime.toString()}",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    remainingTime == 0
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DefaultText(
                              "Code not received ?".tr(),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: textColor,
                            ),
                            const SizedBox(width: 2),
                            GestureDetector(
                              onTap: () async {
                                pinController.clear();
                                await app.resendCodeForgetPasswordRequest();
                                startTimer();
                              },
                              child: DefaultText(
                                "Resend".tr(),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: secondColor,
                              ),
                            ),
                          ],
                        )
                        : const SizedBox(),
                    SizedBox(width: width, height: heigth * 0.1),
                    pinController.text.isEmpty
                        ? const SizedBox()
                        : ButtonWidget(
                          title: "SUBMIT".tr(),
                          fontType: FontType.bold,
                          sizeTitle: 16,
                          onTap: () {
                            app.verifyCodeForgetPasswordRequest(
                              pinController.text,
                            );
                          },
                        ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
