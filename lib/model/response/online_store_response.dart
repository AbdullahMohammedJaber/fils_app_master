// To parse this JSON data, do
//
//     final onlineStoreResponse = onlineStoreResponseFromJson(jsonString);

import 'dart:convert';

OnlineStoreResponse onlineStoreResponseFromJson(String str) =>
    OnlineStoreResponse.fromJson(json.decode(str));

String onlineStoreResponseToJson(OnlineStoreResponse data) =>
    json.encode(data.toJson());

class OnlineStoreResponse {
  List<Category> data;
  bool success;
  dynamic status;

  OnlineStoreResponse({
    required this.data,
    required this.success,
    required this.status,
  });

  factory OnlineStoreResponse.fromJson(Map<String, dynamic> json) =>
      OnlineStoreResponse(
        data: List<Category>.from(
          json["data"].map((x) => Category.fromJson(x)),
        ),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class Category {
  dynamic id;
  String slug;
  String name;
  String banner;
  String icon;
  dynamic numberOfChildren;
  Links links;

  Category({
    required this.id,
    required this.slug,
    required this.name,
    required this.banner,
    required this.icon,
    required this.numberOfChildren,
    required this.links,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    slug: json["slug"],
    name: json["name"],
    banner: json["banner"],
    icon: json["icon"],
    numberOfChildren: json["number_of_children"],
    links: Links.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
    "name": name,
    "banner": banner,
    "icon": icon,
    "number_of_children": numberOfChildren,
    "links": links.toJson(),
  };
}

class Links {
  String products;
  String subCategories;
  String stores;

  Links({
    required this.products,
    required this.subCategories,
    required this.stores,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    products: json["products"],
    subCategories: json["sub_categories"],
    stores: json["stores"],
  );

  Map<String, dynamic> toJson() => {
    "products": products,
    "sub_categories": subCategories,
    "stores": stores,
  };
}
