// To parse this JSON data, do
//
//     final categoryTabBar = categoryTabBarFromJson(jsonString);

import 'dart:convert';

CategoryTabBar categoryTabBarFromJson(String str) => CategoryTabBar.fromJson(json.decode(str));

String categoryTabBarToJson(CategoryTabBar data) => json.encode(data.toJson());

class CategoryTabBar {
  bool result;
  TabBarCategory data;
  int code;

  CategoryTabBar({
    required this.result,
    required this.data,
    required this.code,
  });

  factory CategoryTabBar.fromJson(Map<String, dynamic> json) => CategoryTabBar(
    result: json["result"],
    data: TabBarCategory.fromJson(json["data"]),
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "data": data.toJson(),
    "code": code,
  };
}

class TabBarCategory {
  List<TabBarModel> data;
  bool success;
  int status;

  TabBarCategory({
    required this.data,
    required this.success,
    required this.status,
  });

  factory TabBarCategory.fromJson(Map<String, dynamic> json) => TabBarCategory(
    data: List<TabBarModel>.from(json["data"].map((x) => TabBarModel.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class TabBarModel {
  int id;
  String slug;
  String name;
  String banner;
  String icon;
  int numberOfChildren;
  Links links;

  TabBarModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.banner,
    required this.icon,
    required this.numberOfChildren,
    required this.links,
  });

  factory TabBarModel.fromJson(Map<String, dynamic> json) => TabBarModel(
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
