// To parse this JSON data, do
//
//     final allProductResponse = allProductResponseFromJson(jsonString);

import 'dart:convert';

import 'item_product.dart';

AllProductResponse allProductResponseFromJson(String str) =>
    AllProductResponse.fromJson(json.decode(str));

String allProductResponseToJson(AllProductResponse data) =>
    json.encode(data.toJson());

class AllProductResponse {
  bool? result;
  Data? data;
  dynamic code;

  AllProductResponse({
    required this.result,
    required this.data,
    required this.code,
  });

  factory AllProductResponse.fromJson(Map<String, dynamic> json) =>
      AllProductResponse(
        result: json["result"],
        data: Data.fromJson(json["data"]),
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
    "result": result,
    "data": data!.toJson(),
    "code": code,
  };
}

class Data {
  List<ProductListModel>? data;
  DataLinks? links;
  Meta? meta;
  bool? success;
  dynamic status;

  Data({this.data, this.links, this.meta, this.success, this.status});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    data: List<ProductListModel>.from(
      json["data"].map((x) => ProductListModel.fromJson(x)),
    ),
    links: DataLinks.fromJson(json["links"]),
    meta: Meta.fromJson(json["meta"]),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links!.toJson(),
    "meta": meta!.toJson(),
    "success": success,
    "status": status,
  };
}

class DatumLinks {
  String? details;

  DatumLinks({this.details});

  factory DatumLinks.fromJson(Map<String, dynamic> json) =>
      DatumLinks(details: json["details"]);

  Map<String, dynamic> toJson() => {"details": details};
}

class DataLinks {
  String? first;
  String? last;
  dynamic prev;
  dynamic next;

  DataLinks({this.first, this.last, this.prev, this.next});

  factory DataLinks.fromJson(Map<String, dynamic> json) => DataLinks(
    first: json["first"],
    last: json["last"],
    prev: json["prev"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "first": first,
    "last": last,
    "prev": prev,
    "next": next,
  };
}

class Meta {
  dynamic currentPage;
  dynamic from;
  dynamic lastPage;
  List<Link>? links;
  String? path;
  dynamic perPage;
  dynamic to;
  dynamic total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links": List<dynamic>.from(links!.map((x) => x.toJson())),
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}

class Link {
  String? url;
  String? label;
  bool? active;

  Link({required this.url, required this.label, required this.active});

  factory Link.fromJson(Map<String, dynamic> json) =>
      Link(url: json["url"], label: json["label"], active: json["active"]);

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}
