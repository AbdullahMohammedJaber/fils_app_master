import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/global_function/validation.dart';
import 'package:fils/utils/strings_app.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/custom_validation.dart';
import 'package:fils/widget/defualt_text_form_faild.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/flip_view.dart';
import 'package:provider/provider.dart';

import '../controller/forget_password_notifire.dart';

class ForgetPasswordScreen extends StatefulWidget {
  ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _key = GlobalKey<FormState>();

  Country? _selectedCountry;

  void _pickCountry() {
    showCountryPicker(
      useSafeArea: true,
      context: context,
      showPhoneCode: true, // يعرض الكود بجانب اسم الدولة
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
    return ChangeNotifierProvider(
      create: (context) => ForgetPasswordNotifire(),
      builder: (context, child) {
        return Consumer<ForgetPasswordNotifire>(
          builder: (context, auth, child) {
            return Scaffold(
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _key,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: width, height: heigth * 0.10),
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
                          "Enter your mobile number".tr(),
                          textAlign: TextAlign.start,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff433E3F),
                        ),
                        SizedBox(width: width, height: heigth * 0.02),
                        DefaultText(
                          "to send the code and follow the steps to change your password"
                              .tr(),
                          textAlign: TextAlign.start,
                          fontSize: 14,
                          overflow: TextOverflow.visible,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),

                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     DefaultText(
                        //       "E - mail".tr(),
                        //       color: blackColor,
                        //       fontWeight: FontWeight.w600,
                        //       fontSize: 14,
                        //     ),
                        //     SizedBox(width: width, height: heigth * 0.01),
                        //     ValidateWidget(
                        //       validator: (value) {
                        //         if (auth.emailForgetPassword.text.isEmpty &&
                        //             auth.mobileForgetPassword.text.isEmpty) {
                        //           return requiredField;
                        //         } else if (!isEmailValid(
                        //               auth.emailForgetPassword.text,
                        //             ) &&
                        //             auth.emailForgetPassword.text.isNotEmpty) {
                        //           return emailFalse;
                        //         } else {
                        //           return null;
                        //         }
                        //       },
                        //       child: TextFormFieldWidget(
                        //         controller: auth.emailForgetPassword,
                        //         isPreffix: true,
                        //         textInputType: TextInputType.emailAddress,
                        //         hintText: "E - mail".tr(),
                        //         pathIconPrefix: "assets/icons/sms.svg",
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: heigth * 0.03),
                        // Row(
                        //   children: [
                        //     Expanded(child: Container(height: 1, color: grey2)),
                        //     Padding(
                        //       padding: const EdgeInsets.symmetric(
                        //         horizontal: 10,
                        //       ),
                        //       child: DefaultText(
                        //         "OR".tr(),
                        //         color: grey2,
                        //         type: FontType.medium,
                        //         fontSize: 14,
                        //       ),
                        //     ),
                        //     Expanded(child: Container(height: 1, color: grey2)),
                        //   ],
                        // ),
                        SizedBox(width: width, height: heigth * 0.05),
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
                                if (auth.mobileForgetPassword
                                    .text
                                    .isEmpty) {
                                  return requiredField;
                                } else if (_selectedCountry == null) {
                                  return "Please select a country".tr();
                                } else if (!RegExp(r'^[0-9]+$').hasMatch(
                                  auth.mobileForgetPassword.text,
                                )) {
                                  return "The number must contain only numbers."
                                      .tr();
                                } else if (auth.mobileForgetPassword
                                    .text
                                    .length <
                                    6 ||
                                    auth.mobileForgetPassword
                                        .text
                                        .length >
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
                                      controller:
                                      auth.mobileForgetPassword,
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
                        SizedBox(width: width, height: heigth * 0.02),
                        SizedBox(width: width, height: heigth * 0.1),
                        ButtonWidget(
                          title: "CONTINUO".tr(),
                          colorButton: secondColor,
                          colorTitle: white,
                          fontType: FontType.bold,
                          sizeTitle: 18,
                          onTap: () {
                            if (!_key.currentState!.validate()) {
                            } else {
                              auth.forgetPasswordRequest(_selectedCountry!.phoneCode);
                            }
                          },
                        ),
                        SizedBox(width: width, height: heigth * 0.1),
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
}
