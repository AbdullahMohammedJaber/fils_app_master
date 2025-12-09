// To parse this JSON data, do
//
//     final introResponse = introResponseFromJson(jsonString);

 import 'dart:convert';

IntroResponse introResponseFromJson(String str) => IntroResponse.fromJson(json.decode(str));

String introResponseToJson(IntroResponse data) => json.encode(data.toJson());

class IntroResponse {
  List<Datum> data;
  bool success;
  dynamic status;

  IntroResponse({
    required this.data,
    required this.success,
    required this.status,
  });

  factory IntroResponse.fromJson(Map<String, dynamic> json) => IntroResponse(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class Datum {
  String type;
  Value value;

  Datum({
    required this.type,
    required this.value,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    type: json["type"],
    value: Value.fromJson(json["value"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
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
