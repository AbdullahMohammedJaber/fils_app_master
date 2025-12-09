import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/utils/const.dart';

import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/item_back.dart';
import 'package:provider/provider.dart';

import '../../../utils/enum/language_type.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).show();
    });
    return Consumer<AppNotifire>(
      builder: (context, app, child) {
        return Scaffold(
          appBar: AppBar(automaticallyImplyLeading: false , toolbarHeight: 0),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  SizedBox(height: heigth * 0.06),

                  itemBackAndTitle(context, title: "Language".tr()),
                  SizedBox(height: heigth * 0.07),
                  GestureDetector(
                    onTap: () {
                      app.changeLanguage(
                        context,
                        languageType: LanguageType.ARABIC,
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      height: 50,
                      width: width,
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xffBA27B7).withOpacity(0.4),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/icons/arabic.svg",
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          DefaultText(
                            "اللغة العربية",
                            fontSize: 14,
                            color: blackColor,
                            fontWeight: FontWeight.w500,
                          ),
                          const Spacer(),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: textColor),
                            ),
                            child:
                                getLocal() == 'sa'
                                    ? Container(
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: purpleColor,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    )
                                    : const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: width * 0.02),
                    child: const Divider(thickness: 1),
                  ),
                  GestureDetector(
                    onTap: () {
                      app.changeLanguage(
                        context,
                        languageType: LanguageType.ENGLISH,
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      height: 50,
                      width: width,
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xffBA27B7).withOpacity(0.4),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/icons/english.svg",
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          DefaultText(
                            "English Language",
                            fontSize: 14,
                            color: blackColor,
                            fontWeight: FontWeight.w500,
                          ),
                          const Spacer(),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: textColor),
                            ),
                            child:
                                getLocal() == 'en'
                                    ? Container(
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: purpleColor,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    )
                                    : const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: width * 0.02),
                    child: const Divider(thickness: 1),
                  ),
                  GestureDetector(
                    onTap: () {
                      app.changeLanguage(
                        context,
                        languageType: LanguageType.Urdu,
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      height: 50,
                      width: width,
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xffBA27B7).withOpacity(0.4),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/icons/english.svg",
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          DefaultText(
                            "اردو",
                            fontSize: 14,
                            color: blackColor,
                            fontWeight: FontWeight.w500,
                          ),
                          const Spacer(),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: textColor),
                            ),
                            child:
                                getLocal() == 'pk'
                                    ? Container(
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: purpleColor,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    )
                                    : const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: width * 0.02),
                    child: const Divider(thickness: 1),
                  ),
                  GestureDetector(
                    onTap: () {
                      app.changeLanguage(
                        context,
                        languageType: LanguageType.Hindi,
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      height: 50,
                      width: width,
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xffBA27B7).withOpacity(0.4),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/icons/english.svg",
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          DefaultText(
                            "हिंदी भाषा",
                            fontSize: 14,
                            color: blackColor,
                            fontWeight: FontWeight.w500,
                          ),
                          const Spacer(),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: textColor),
                            ),
                            child:
                                getLocal() == 'in'
                                    ? Container(
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: purpleColor,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    )
                                    : const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: width * 0.02),
                    child: const Divider(thickness: 1),
                  ),
                  GestureDetector(
                    onTap: () {
                      app.changeLanguage(
                        context,
                        languageType: LanguageType.Farsi,
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      height: 50,
                      width: width,
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xffBA27B7).withOpacity(0.4),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/icons/english.svg",
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          DefaultText(
                            "فارسي",
                            fontSize: 14,
                            color: blackColor,
                            fontWeight: FontWeight.w500,
                          ),
                          const Spacer(),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: textColor),
                            ),
                            child:
                                getLocal() == 'ir'
                                    ? Container(
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: purpleColor,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    )
                                    : const SizedBox(),
                          ),
                        ],
                      ),
                    ),
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
