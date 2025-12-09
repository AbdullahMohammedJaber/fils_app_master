import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/auth_notifire.dart';
import 'package:fils/controller/provider/user_notefire.dart';
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

class EditPersonalInformationScreen extends StatefulWidget {
  const EditPersonalInformationScreen({super.key});

  @override
  State<EditPersonalInformationScreen> createState() =>
      _EditPersonalInformationScreenState();
}

class _EditPersonalInformationScreenState
    extends State<EditPersonalInformationScreen> {
  @override
  void initState() {

    context.read<AuthNotifire>().nameControllerForEdit.text =
        getUser()!.user!.name;
    context.read<AuthNotifire>().emailControllerForEdit.text =
        getUser()!.user!.email;
    super.initState();
    if(getUser()!.user!.phone!.isNotEmpty){
      context.read<AuthNotifire>().mobileControllerForEdit.text = getUser()!
          .user!
          .phone!
          .substring(3, getUser()!.user!.phone!.length);
      _setCountryFromPhone(getUser()!.user!.phone!);
    }

  }

  Country? _selectedCountry;

  void _pickCountry() {
    showCountryPicker(
      useSafeArea: true,
      context: context,
      showPhoneCode: true,

      onSelect: (Country country) {
        print(country.toJson().toString());
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
  void _setCountryFromPhone(String fullNumber) {

    fullNumber = fullNumber.replaceAll("+", "");
     print(fullNumber);

    List<String> possibleCodes = [
      fullNumber.substring(0, 1),
      if (fullNumber.length >= 2) fullNumber.substring(0, 2),
      if (fullNumber.length >= 3) fullNumber.substring(0, 3),
    ];

     final allCountries = CountryService().getAll();

    for (String code in possibleCodes) {
      try {
        final match = allCountries.firstWhere(
              (c) => c.phoneCode == code,

        );
        print(match);
        if (match.countryCode != 'WORLD') {
          setState(() {
            _selectedCountry = match;
          });
          print("Country detected: ${match.name}");
          return;
        }
      } catch (_) {}
    }

    print("No country matched");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthNotifire, UserNotifier>(
      builder: (context, auth, user, child) {
        return Scaffold(
          appBar: AppBar(automaticallyImplyLeading: false, toolbarHeight: 0),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: auth.keyForEdit,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: heigth * 0.06),
                    itemBackAndTitle(
                      context,
                      title: "Edit Personal information".tr(),
                    ),
                    SizedBox(height: heigth * 0.08),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          "Full Name".tr(),
                          color: blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        SizedBox(width: width, height: heigth * 0.01),
                        ValidateWidget(
                          validator: (value) {
                            if (auth.nameControllerForEdit.text.isEmpty) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            controller: auth.nameControllerForEdit,
                            isPreffix: true,
                            textInputType: TextInputType.name,
                            hintText: "Full Name".tr(),
                            pathIconPrefix: "assets/icons/user.svg",
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
                          "E - mail".tr(),
                          color: blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        SizedBox(width: width, height: heigth * 0.01),
                        ValidateWidget(
                          validator: (value) {
                            if (auth.emailControllerForEdit.text.isEmpty) {
                              return requiredField;
                            } else {
                              return null;
                            }
                          },
                          child: TextFormFieldWidget(
                            controller: auth.emailControllerForEdit,
                            isPreffix: true,
                            textInputType: TextInputType.emailAddress,
                            hintText: "E - mail".tr(),
                            pathIconPrefix: "assets/icons/sms.svg",
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
                          "Mobile Number".tr(),
                          color: blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        SizedBox(width: width, height: heigth * 0.01),
                        ValidateWidget(
                          validator: (value) {
                            if (auth.mobileControllerForEdit.text.isEmpty) {
                              return requiredField;
                            } else if (_selectedCountry == null) {
                              return "Please select a country".tr();
                            } else if (!RegExp(
                              r'^[0-9]+$',
                            ).hasMatch(auth.mobileControllerForEdit.text)) {
                              return "The number must contain only numbers."
                                  .tr();
                            } else if (auth
                                        .mobileControllerForEdit
                                        .text
                                        .length <
                                    6 ||
                                auth.mobileControllerForEdit.text.length > 12) {
                              return "Please enter a valid number".tr();
                            } else {
                              return null;
                            }
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormFieldWidget(
                                  controller: auth.mobileControllerForEdit,
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
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          _selectedCountry != null
                                              ? '${_selectedCountry!.countryCode} (+${_selectedCountry!.phoneCode})'
                                              : 'Select Country'.tr(),
                                          style: const TextStyle(fontSize: 12),
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
                    /*SizedBox(width: width, height: heigth * 0.02),
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
                          if (auth.passwordControllerForEdit.text.isEmpty) {
                            return requiredField;
                          } else if (auth
                                  .passwordControllerForEdit.text.length <
                              8) {
                            return passwordLessDigit;
                          } else {
                            return null;
                          }
                        },
                        child: TextFormFieldWidget(
                          controller: auth.passwordControllerForEdit,
                          isPreffix: true,
                          hintText: "Password".tr(),
                          pathIconPrefix: "assets/icons/lock.svg",
                          textInputType: TextInputType.visiblePassword,
                          isIcon: true,
                          pathIcon: "assets/icons/edit.svg",
                        ),
                      ),
                    ],
                  ),*/
                    SizedBox(height: heigth * 0.1),
                    ButtonWidget(
                      title: "Save Change".tr(),
                      colorButton: secondColor,
                      fontType: FontType.bold,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        auth.editPersonAccount(
                          context,
                          _selectedCountry!.phoneCode,
                        );
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
}
