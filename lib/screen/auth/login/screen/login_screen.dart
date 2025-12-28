// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fils/screen/Buyer/about_us/about_us_screen.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:fils/controller/provider/floating_button_provider.dart';

import 'package:fils/screen/auth/signup/screen/signup_screen.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/message_type.dart';

import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/strings_app.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/custom_validation.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:fils/widget/defualt_text_form_faild.dart';
import '../../forget_password/screen/forget_password.dart';
import '../controller/login_notifire.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Country? _selectedCountry;

  void _pickCountry() {
    showCountryPicker(
      useSafeArea: true,
      context: context,
      showPhoneCode: true,
      // يعرض الكود بجانب اسم الدولة
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
        });
      },
      countryListTheme: CountryListThemeData(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        inputDecoration: const InputDecoration(
          labelText: 'بحث عن الدولة',
          hintText: 'اكتب اسم الدولة هنا...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return ChangeNotifierProvider(
      create: (context) => LoginNotifire(),
      builder: (context, child) {
        return Consumer<LoginNotifire>(
          builder: (context, login, child) {
            return SafeArea(
              child: Form(
                key: login.keyForLogin,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        SizedBox(width: width, height: heigth * 0.08),
                        DefaultText(
                          "SIGN IN".tr(),
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                        SizedBox(width: width, height: heigth * 0.05),
                       /* Container(
                          height: 50,
                          width: width,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xffB5B3B3)),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    login.changeUserType("customer");
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 100),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color:
                                          login.userType == "customer"
                                              ? primaryDarkColor
                                              : getTheme()
                                              ? Colors.black
                                              : white,
                                    ),
                                    child: Center(
                                      child: DefaultText(
                                        "Buyer".tr(),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            login.userType == "customer"
                                                ? white
                                                : getTheme()
                                                ? white
                                                : const Color(0xff433E3F),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    login.changeUserType("seller");
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 100),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color:
                                          login.userType != "customer"
                                              ? primaryDarkColor
                                              : getTheme()
                                              ? Colors.black
                                              : white,
                                    ),
                                    child: Center(
                                      child: DefaultText(
                                        "Seller".tr(),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            login.userType != "customer"
                                                ? white
                                                : getTheme()
                                                ? white
                                                : const Color(0xff433E3F),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                        SizedBox(width: width, height: heigth * 0.05),*/
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DefaultText(
                              "Mobile Number".tr(),
                              color: blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            SizedBox(width: width, height: heigth * 0.01),
                            ValidateWidget(
                              validator: (value) {
                                if (login
                                    .emailControllerForLogin
                                    .text
                                    .isEmpty) {
                                  return requiredField;
                                } else if (_selectedCountry == null) {
                                  return "Please select a country".tr();
                                } else if (!RegExp(r'^[0-9]+$').hasMatch(
                                  login.emailControllerForLogin.text,
                                )) {
                                  return "The number must contain only numbers."
                                      .tr();
                                } else if (login
                                            .emailControllerForLogin
                                            .text
                                            .length <
                                        6 ||
                                    login.emailControllerForLogin.text.length >
                                        12) {
                                  return "Please enter a valid number".tr();
                                } else {
                                  return null;
                                }
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormFieldWidget(
                                      controller: login.emailControllerForLogin,
                                      isPreffix: true,
                                      textInputType: TextInputType.phone,
                                      hintText: "Mobile Number".tr(),
                                      pathIconPrefix: "assets/icons/mobile.svg",
                                    ),
                                  ),
                                  InkWell(
                                    onTap: _pickCountry,
                                    child: Container(
                                      width: 100,
                                      height: 50,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade400,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          if (_selectedCountry != null)
                                            Text(
                                              _selectedCountry!.flagEmoji,
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              _selectedCountry != null
                                                  ? '${_selectedCountry!.countryCode} (+${_selectedCountry!.phoneCode})'
                                                  : 'Select Country'.tr(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          const Icon(Icons.arrow_drop_down),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: width, height: heigth * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DefaultText(
                              "Password".tr(),
                              color: blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            SizedBox(width: width, height: heigth * 0.01),
                            ValidateWidget(
                              validator: (value) {
                                if (login
                                    .passwordControllerForLogin
                                    .text
                                    .isEmpty) {
                                  return requiredField;
                                } else if (login
                                        .passwordControllerForLogin
                                        .text
                                        .length <
                                    8) {
                                  return passwordLessDigit;
                                }
                                /*else if (!isPasswordValid(
                                  login.passwordControllerForLogin.text)) {
                                return passwordNotContainChar;
                              } */
                                else {
                                  return null;
                                }
                              },
                              child: TextFormFieldWidget(
                                controller: login.passwordControllerForLogin,
                                isPreffix: true,
                                hintText: "Password".tr(),
                                isShow: login.visiblePasswordForLogin,
                                pathIconPrefix: "assets/icons/lock.svg",
                                isIcon: true,
                                ontapIcon: () {
                                  login.changeVisabiltyPasswordForLogin();
                                },
                                textInputType: TextInputType.visiblePassword,
                                pathIcon: "assets/icons/eye-slash.svg",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: heigth * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                TowithTrans(
                                  context,
                                  ForgetPasswordScreen(),
                                  PageTransitionType.rightToLeft,
                                );
                              },
                              child: DefaultText(
                                "Forget Password ?".tr(),
                                color: textColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: heigth * 0.08),
                        ButtonWidget(
                          colorButton: secondColor,
                          title: "SIGN IN".tr(),
                          fontType: FontType.bold,
                          sizeTitle: 16,
                          radius: 14,
                          onTap: () async {
                            if (!login.keyForLogin.currentState!.validate()) {
                            } else {
                              if (login.checkP) {
                                login.signIn(
                                  context,
                                  _selectedCountry!.phoneCode,
                                );
                              } else {
                                showCustomFlash(
                                  message:
                                      "You must agree to the privacy policy and terms of use"
                                          .tr(),
                                  messageType: MessageType.Faild,
                                );
                              }
                            }
                          },
                        ),
                        SizedBox(height: heigth * 0.02),

                        Row(
                          children: [
                            Checkbox(
                              value: login.checkP,
                              onChanged: (value) {
                                login.changeCheckP();
                              },
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: blackColor,
                                    fontFamily: 'Almarai',
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "I agree to".tr(),

                                      style: TextStyle(
                                        color: blackColor,
                                        fontFamily: 'Almarai',
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' '.tr(),
                                      style: TextStyle(
                                        color: secondColor,
                                        fontFamily: 'Almarai',
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'privacy policy'.tr(),
                                      style: TextStyle(
                                        color: secondColor,
                                        fontFamily: 'Almarai',
                                      ),
                                      recognizer:
                                          TapGestureRecognizer()
                                            ..onTap = () {
                                              To(
                                                context,
                                                PrivacyPolicyScreen(),
                                              );
                                            },
                                    ),
                                    TextSpan(
                                      text: ' '.tr(),
                                      style: TextStyle(
                                        color: secondColor,
                                        fontFamily: 'Almarai',
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'and terms of use'.tr(),
                                      style: TextStyle(
                                        color: blackColor,
                                        fontFamily: 'Almarai',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (Platform.isAndroid ) ...[
                          SizedBox(height: heigth * 0.03),
                          Row(
                            children: [
                              Expanded(
                                child: Container(height: 1, color: grey2),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: DefaultText(
                                  "OR".tr(),
                                  color: grey2,
                                  type: FontType.medium,
                                  fontSize: 14,
                                ),
                              ),
                              Expanded(
                                child: Container(height: 1, color: grey2),
                              ),
                            ],
                          ),
                          SizedBox(height: heigth * 0.023),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              buildSocialMediaAuth(
                                path: "assets/icons/apple.svg",
                                onTap: () async {
                                  if (Platform.isAndroid) {
                                    showCustomFlash(
                                      message:
                                          "Your phone does not support this technology."
                                              .tr(),
                                      messageType: MessageType.Faild,
                                    );
                                  } else {
                                    loginApple(
                                      context,
                                      userType: login.userType,
                                    );
                                  }
                                },
                              ),
                              buildSocialMediaAuth(
                                path: "assets/icons/google.svg",
                                onTap: () async {
                                  loginGoogle(
                                    context,
                                    userType: login.userType,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],

                        SizedBox(height: heigth * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                              child: DefaultText(
                                "Don't have an account ?".tr(),
                                type: FontType.medium,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                ToWithFade(context, SignupScreen());
                              },
                              child: SizedBox(
                                height: 50,
                                child: DefaultText(
                                  "SIGN UP".tr(),
                                  type: FontType.medium,
                                  fontSize: 14,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: heigth * 0.08),
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

  Widget buildSocialMediaAuth({
    required String? path,
    required Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: grey2),
        ),
        child: Center(
          child: SvgPicture.asset(
            path!,
            color: path.endsWith("apple.svg") ? blackColor : null,
          ),
        ),
      ),
    );
  }
}
