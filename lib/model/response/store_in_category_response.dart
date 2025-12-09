// To parse this JSON data, do
//
//     final storeInCategoryResponse = storeInCategoryResponseFromJson(jsonString);

import 'dart:convert';

import 'item_store.dart';

StoreInCategoryResponse storeInCategoryResponseFromJson(String str) =>
    StoreInCategoryResponse.fromJson(json.decode(str));

String storeInCategoryResponseToJson(StoreInCategoryResponse data) =>
    json.encode(data.toJson());

class StoreInCategoryResponse {
  bool result;
  Data data;
  dynamic code;

  StoreInCategoryResponse({
    required this.result,
    required this.data,
    required this.code,
  });

  factory StoreInCategoryResponse.fromJson(Map<String, dynamic> json) =>
      StoreInCategoryResponse(
        result: json["result"],
        data: Data.fromJson(json["data"]),
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "data": data.toJson(),
        "code": code,
      };
}

class Data {
  Shops shops;

  Data({
    required this.shops,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        shops: Shops.fromJson(json["shops"]),
      );

  Map<String, dynamic> toJson() => {
        "shops": shops.toJson(),
      };
}

class Shops {
  List<TopStoresDatum> data;

  Shops({
    required this.data,
  });

  factory Shops.fromJson(Map<String, dynamic> json) => Shops(
        data: List<TopStoresDatum>.from(
            json["data"].map((x) => TopStoresDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
