// To parse this JSON data, do
//
//     final ProductListModelResponse = ProductListModelResponseFromJson(jsonString);

import 'dart:convert';

ProductListModelResponse ProductListModelResponseFromJson(String str) =>
    ProductListModelResponse.fromJson(json.decode(str));

String ProductListModelResponseToJson(ProductListModelResponse data) =>
    json.encode(data.toJson());

class ProductListModelResponse {
  bool status;
  dynamic code;
  Data data;

  ProductListModelResponse({
    required this.status,
    required this.code,
    required this.data,
  });

  factory ProductListModelResponse.fromJson(Map<String, dynamic> json) =>
      ProductListModelResponse(
        status: json["status"],
        code: json["code"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  List<ProductListModel> data;
  DataLinks links;
  Meta meta;
  bool success;
  dynamic status;

  Data({
    required this.data,
    required this.links,
    required this.meta,
    required this.success,
    required this.status,
  });

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
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "links": links.toJson(),
    "meta": meta.toJson(),
    "success": success,
    "status": status,
  };
}

class ProductListModel {
  dynamic id;
  String slug;
  String name;
  String shopName;
  String thumbnailImage;
  bool hasDiscount;
  String discount;
  String strokedPrice;
  String mainPrice;
  dynamic rating;
  dynamic sales;
  bool isWholesale;
  bool isFavorite;
  dynamic isAuction;
  DateTime auctionEndDateString;
  DatumLinks links;

  ProductListModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.shopName,
    required this.thumbnailImage,
    required this.hasDiscount,
    required this.discount,
    required this.strokedPrice,
    required this.mainPrice,
    required this.rating,
    required this.sales,
    required this.isWholesale,
    required this.isFavorite,
    required this.isAuction,
    required this.auctionEndDateString,
    required this.links,
  });

  factory ProductListModel.fromJson(Map<String, dynamic> json) =>
      ProductListModel(
        id: json["id"],
        slug: json["slug"],
        name: json["name"],
        shopName: json["shop_name"],
        thumbnailImage: json["thumbnail_image"],
        hasDiscount: json["has_discount"],
        discount: json["discount"],
        strokedPrice: json["stroked_price"],
        mainPrice: json["main_price"],
        rating: json["rating"],
        sales: json["sales"],
        isWholesale: json["is_wholesale"],
        isFavorite: json["is_favorite"],
        isAuction: json["is_auction"],
        auctionEndDateString: DateTime.parse(json["auction_end_date_string"]),
        links: DatumLinks.fromJson(json["links"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
    "name": name,
    "shop_name": shopName,
    "thumbnail_image": thumbnailImage,
    "has_discount": hasDiscount,
    "discount": discount,
    "stroked_price": strokedPrice,
    "main_price": mainPrice,
    "rating": rating,
    "sales": sales,
    "is_wholesale": isWholesale,
    "is_favorite": isFavorite,
    "is_auction": isAuction,
    "auction_end_date_string": auctionEndDateString.toIso8601String(),
    "links": links.toJson(),
  };
}

class DatumLinks {
  String details;

  DatumLinks({required this.details});

  factory DatumLinks.fromJson(Map<String, dynamic> json) =>
      DatumLinks(details: json["details"]);

  Map<String, dynamic> toJson() => {"details": details};
}

class DataLinks {
  String first;
  String last;
  dynamic prev;
  String next;

  DataLinks({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });

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

  Link({required this.url, required this.label, required this.active});

  factory Link.fromJson(Map<String, dynamic> json) =>
      Link(url: json["url"], label: json["label"], active: json["active"]);

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}
