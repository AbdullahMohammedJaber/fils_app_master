// To parse this JSON data, do
//
//     final searchResponse = searchResponseFromJson(jsonString);

import 'package:fils/model/response/item_product.dart';
import 'dart:convert';

SearchResponse searchResponseFromJson(String str) =>
    SearchResponse.fromJson(json.decode(str));

String searchResponseToJson(SearchResponse data) => json.encode(data.toJson());

class SearchResponse {
  List<ProductListModel> data;
  SearchResponseLinks links;
  Meta meta;
  bool success;
  dynamic status;

  SearchResponse({
    required this.data,
    required this.links,
    required this.meta,
    required this.success,
    required this.status,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        data: List<ProductListModel>.from(
            json["data"].map((x) => ProductListModel.fromJson(x))),
        links: SearchResponseLinks.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "links": links.toJson(),
        "meta": meta.toJson(),
        "success": success,
        "status": status,
      };
}

class DatumLinks {
  String details;

  DatumLinks({
    required this.details,
  });

  factory DatumLinks.fromJson(Map<String, dynamic> json) => DatumLinks(
        details: json["details"],
      );

  Map<String, dynamic> toJson() => {
        "details": details,
      };
}

class SearchResponseLinks {
  String first;
  String last;
  dynamic prev;
  dynamic next;

  SearchResponseLinks({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });

  factory SearchResponseLinks.fromJson(Map<String, dynamic> json) =>
      SearchResponseLinks(
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
  List<Link> links;
  String path;
  dynamic perPage;
  dynamic to;
  dynamic total;

  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
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
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}

class Link {
  String url;
  String label;
  bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
