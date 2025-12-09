import 'dart:convert';

class SubCategoryFilterProductResponse {
  List<SubFilter>? data;
  SubCategoryFilterProductResponseLinks? links;
  Meta? meta;
  bool? success;
  int? status;

  SubCategoryFilterProductResponse({
    this.data,
    this.links,
    this.meta,
    this.success,
    this.status,
  });

  factory SubCategoryFilterProductResponse.fromRawJson(String str) => SubCategoryFilterProductResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubCategoryFilterProductResponse.fromJson(Map<String, dynamic> json) => SubCategoryFilterProductResponse(
    data: json["data"] == null ? [] : List<SubFilter>.from(json["data"]!.map((x) => SubFilter.fromJson(x))),
    links: json["links"] == null ? null : SubCategoryFilterProductResponseLinks.fromJson(json["links"]),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links?.toJson(),
    "meta": meta?.toJson(),
    "success": success,
    "status": status,
  };
}

class SubFilter {
  int? id;
  String? slug;
  String? name;
  String? shopName;
  String? thumbnailImage;
  bool? hasDiscount;
  String? discount;
  String? strokedPrice;
  String? mainPrice;
  int? rating;
  int? sales;
  bool? isWholesale;
  bool? isFavorite;
  int? isAuction;
  DateTime? auctionEndDateString;
  DatumLinks? links;

  SubFilter({
    this.id,
    this.slug,
    this.name,
    this.shopName,
    this.thumbnailImage,
    this.hasDiscount,
    this.discount,
    this.strokedPrice,
    this.mainPrice,
    this.rating,
    this.sales,
    this.isWholesale,
    this.isFavorite,
    this.isAuction,
    this.auctionEndDateString,
    this.links,
  });

  factory SubFilter.fromRawJson(String str) => SubFilter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubFilter.fromJson(Map<String, dynamic> json) => SubFilter(
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
    auctionEndDateString: json["auction_end_date_string"] == null ? null : DateTime.parse(json["auction_end_date_string"]),
    links: json["links"] == null ? null : DatumLinks.fromJson(json["links"]),
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
    "auction_end_date_string": auctionEndDateString?.toIso8601String(),
    "links": links?.toJson(),
  };
}

class DatumLinks {
  String? details;

  DatumLinks({
    this.details,
  });

  factory DatumLinks.fromRawJson(String str) => DatumLinks.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatumLinks.fromJson(Map<String, dynamic> json) => DatumLinks(
    details: json["details"],
  );

  Map<String, dynamic> toJson() => {
    "details": details,
  };
}

class SubCategoryFilterProductResponseLinks {
  String? first;
  String? last;
  dynamic prev;
  dynamic next;

  SubCategoryFilterProductResponseLinks({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory SubCategoryFilterProductResponseLinks.fromRawJson(String str) => SubCategoryFilterProductResponseLinks.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubCategoryFilterProductResponseLinks.fromJson(Map<String, dynamic> json) => SubCategoryFilterProductResponseLinks(
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
  int? currentPage;
  int? from;
  int? lastPage;
  List<Link>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

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

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
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

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromRawJson(String str) => Link.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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
