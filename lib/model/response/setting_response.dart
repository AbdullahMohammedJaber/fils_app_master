// To parse this JSON data, do
//
//     final settingResponse = settingResponseFromJson(jsonString);

import 'dart:convert';

SettingResponse settingResponseFromJson(String str) =>
    SettingResponse.fromJson(json.decode(str));

String settingResponseToJson(SettingResponse data) =>
    json.encode(data.toJson());

class SettingResponse {
  Data data;

  SettingResponse({
    required this.data,
  });

  factory SettingResponse.fromJson(Map<String, dynamic> json) =>
      SettingResponse(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  AboutUsDescription homeSliderImages;
  AboutUsDescription homeSliderLinks;
  AboutUsDescription homeBanner1Images;
  AboutUsDescription homeBanner1Links;
  AboutUsDescription homeBanner2Images;
  AboutUsDescription homeBanner2Links;
  FlashDealCardBgImage flashDealCardBgImage;
  FlashDealCardBgImage flashDealCardBgTitle;
  FlashDealCardBgImage flashDealCardBgSubtitle;
  FlashDealCardBgImage todaysDealCardBgImage;
  FlashDealCardBgImage todaysDealCardBgTitle;
  FlashDealCardBgImage todaysDealCardBgSubtitle;
  FlashDealCardBgImage newProductCardBgImage;
  FlashDealCardBgImage newProductCardBgTitle;
  FlashDealCardBgImage newProductCardBgSubtitle;
  AboutUsDescription sliderSectionFullWidth;
  AboutUsDescription sliderSectionBgColor;
  FlashDealCardBgImage homeBanner4Images;
  FlashDealCardBgImage homeBanner4Links;
  FlashDealCardBgImage homeBanner5Images;
  FlashDealCardBgImage homeBanner5Links;
  FlashDealCardBgImage homeBanner6Images;
  FlashDealCardBgImage homeBanner6Links;
  MobileIntro mobileIntro;
  AboutUsDescription aboutUsDescription;

  Data({
    required this.homeSliderImages,
    required this.homeSliderLinks,
    required this.homeBanner1Images,
    required this.homeBanner1Links,
    required this.homeBanner2Images,
    required this.homeBanner2Links,
    required this.flashDealCardBgImage,
    required this.flashDealCardBgTitle,
    required this.flashDealCardBgSubtitle,
    required this.todaysDealCardBgImage,
    required this.todaysDealCardBgTitle,
    required this.todaysDealCardBgSubtitle,
    required this.newProductCardBgImage,
    required this.newProductCardBgTitle,
    required this.newProductCardBgSubtitle,
    required this.sliderSectionFullWidth,
    required this.sliderSectionBgColor,
    required this.homeBanner4Images,
    required this.homeBanner4Links,
    required this.homeBanner5Images,
    required this.homeBanner5Links,
    required this.homeBanner6Images,
    required this.homeBanner6Links,
    required this.mobileIntro,
    required this.aboutUsDescription,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        homeSliderImages:
            AboutUsDescription.fromJson(json["home_slider_images"]),
        homeSliderLinks: AboutUsDescription.fromJson(json["home_slider_links"]),
        homeBanner1Images:
            AboutUsDescription.fromJson(json["home_banner1_images"]),
        homeBanner1Links:
            AboutUsDescription.fromJson(json["home_banner1_links"]),
        homeBanner2Images:
            AboutUsDescription.fromJson(json["home_banner2_images"]),
        homeBanner2Links:
            AboutUsDescription.fromJson(json["home_banner2_links"]),
        flashDealCardBgImage:
            FlashDealCardBgImage.fromJson(json["flash_deal_card_bg_image"]),
        flashDealCardBgTitle:
            FlashDealCardBgImage.fromJson(json["flash_deal_card_bg_title"]),
        flashDealCardBgSubtitle:
            FlashDealCardBgImage.fromJson(json["flash_deal_card_bg_subtitle"]),
        todaysDealCardBgImage:
            FlashDealCardBgImage.fromJson(json["todays_deal_card_bg_image"]),
        todaysDealCardBgTitle:
            FlashDealCardBgImage.fromJson(json["todays_deal_card_bg_title"]),
        todaysDealCardBgSubtitle:
            FlashDealCardBgImage.fromJson(json["todays_deal_card_bg_subtitle"]),
        newProductCardBgImage:
            FlashDealCardBgImage.fromJson(json["new_product_card_bg_image"]),
        newProductCardBgTitle:
            FlashDealCardBgImage.fromJson(json["new_product_card_bg_title"]),
        newProductCardBgSubtitle:
            FlashDealCardBgImage.fromJson(json["new_product_card_bg_subtitle"]),
        sliderSectionFullWidth:
            AboutUsDescription.fromJson(json["slider_section_full_width"]),
        sliderSectionBgColor:
            AboutUsDescription.fromJson(json["slider_section_bg_color"]),
        homeBanner4Images:
            FlashDealCardBgImage.fromJson(json["home_banner4_images"]),
        homeBanner4Links:
            FlashDealCardBgImage.fromJson(json["home_banner4_links"]),
        homeBanner5Images:
            FlashDealCardBgImage.fromJson(json["home_banner5_images"]),
        homeBanner5Links:
            FlashDealCardBgImage.fromJson(json["home_banner5_links"]),
        homeBanner6Images:
            FlashDealCardBgImage.fromJson(json["home_banner6_images"]),
        homeBanner6Links:
            FlashDealCardBgImage.fromJson(json["home_banner6_links"]),
        mobileIntro: MobileIntro.fromJson(json["mobile_intro"]),
        aboutUsDescription:
            AboutUsDescription.fromJson(json["about_us_description"]),
      );

  Map<String, dynamic> toJson() => {
        "home_slider_images": homeSliderImages.toJson(),
        "home_slider_links": homeSliderLinks.toJson(),
        "home_banner1_images": homeBanner1Images.toJson(),
        "home_banner1_links": homeBanner1Links.toJson(),
        "home_banner2_images": homeBanner2Images.toJson(),
        "home_banner2_links": homeBanner2Links.toJson(),
        "flash_deal_card_bg_image": flashDealCardBgImage.toJson(),
        "flash_deal_card_bg_title": flashDealCardBgTitle.toJson(),
        "flash_deal_card_bg_subtitle": flashDealCardBgSubtitle.toJson(),
        "todays_deal_card_bg_image": todaysDealCardBgImage.toJson(),
        "todays_deal_card_bg_title": todaysDealCardBgTitle.toJson(),
        "todays_deal_card_bg_subtitle": todaysDealCardBgSubtitle.toJson(),
        "new_product_card_bg_image": newProductCardBgImage.toJson(),
        "new_product_card_bg_title": newProductCardBgTitle.toJson(),
        "new_product_card_bg_subtitle": newProductCardBgSubtitle.toJson(),
        "slider_section_full_width": sliderSectionFullWidth.toJson(),
        "slider_section_bg_color": sliderSectionBgColor.toJson(),
        "home_banner4_images": homeBanner4Images.toJson(),
        "home_banner4_links": homeBanner4Links.toJson(),
        "home_banner5_images": homeBanner5Images.toJson(),
        "home_banner5_links": homeBanner5Links.toJson(),
        "home_banner6_images": homeBanner6Images.toJson(),
        "home_banner6_links": homeBanner6Links.toJson(),
        "mobile_intro": mobileIntro.toJson(),
        "about_us_description": aboutUsDescription.toJson(),
      };
}

class AboutUsDescription {
  String value;

  AboutUsDescription({
    required this.value,
  });

  factory AboutUsDescription.fromJson(Map<String, dynamic> json) =>
      AboutUsDescription(
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
      };
}

class FlashDealCardBgImage {
  dynamic value;

  FlashDealCardBgImage({
    required this.value,
  });

  factory FlashDealCardBgImage.fromJson(Map<String, dynamic> json) =>
      FlashDealCardBgImage(
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
      };
}

class MobileIntro {
  Value value;

  MobileIntro({
    required this.value,
  });

  factory MobileIntro.fromJson(Map<String, dynamic> json) => MobileIntro(
        value: Value.fromJson(json["value"]),
      );

  Map<String, dynamic> toJson() => {
        "value": value.toJson(),
      };
}

class Value {
  String splashStep1Title;
  String splashStep1Text;
  String splashStep1Img;
  String splashStep2Title;
  String splashStep2Text;
  String splashStep2Img;
  String splashStep3Title;
  String splashStep3Text;
  String splashStep3Img;

  Value({
    required this.splashStep1Title,
    required this.splashStep1Text,
    required this.splashStep1Img,
    required this.splashStep2Title,
    required this.splashStep2Text,
    required this.splashStep2Img,
    required this.splashStep3Title,
    required this.splashStep3Text,
    required this.splashStep3Img,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        splashStep1Title: json["splash_step1_title"],
        splashStep1Text: json["splash_step1_text"],
        splashStep1Img: json["splash_step1_img"],
        splashStep2Title: json["splash_step2_title"],
        splashStep2Text: json["splash_step2_text"],
        splashStep2Img: json["splash_step2_img"],
        splashStep3Title: json["splash_step3_title"],
        splashStep3Text: json["splash_step3_text"],
        splashStep3Img: json["splash_step3_img"],
      );

  Map<String, dynamic> toJson() => {
        "splash_step1_title": splashStep1Title,
        "splash_step1_text": splashStep1Text,
        "splash_step1_img": splashStep1Img,
        "splash_step2_title": splashStep2Title,
        "splash_step2_text": splashStep2Text,
        "splash_step2_img": splashStep2Img,
        "splash_step3_title": splashStep3Title,
        "splash_step3_text": splashStep3Text,
        "splash_step3_img": splashStep3Img,
      };
}
