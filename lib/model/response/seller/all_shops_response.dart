import 'dart:convert';

class AllShopsResponse {
  Data? data;
  String? message;
  bool? result;
  dynamic code;

  AllShopsResponse({this.data, this.message, this.result, this.code});

  factory AllShopsResponse.fromRawJson(String str) =>
      AllShopsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AllShopsResponse.fromJson(Map<String, dynamic> json) =>
      AllShopsResponse(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
        result: json["result"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "message": message,
    "result": result,
    "code": code,
  };
}

class Data {
  List<ShopsAll>? data;
  Links? links;
  Meta? meta;
  bool? success;
  dynamic status;

  Data({this.data, this.links, this.meta, this.success, this.status});

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    data:
        json["data"] == null
            ? []
            : List<ShopsAll>.from(
              json["data"]!.map((x) => ShopsAll.fromJson(x)),
            ),
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links?.toJson(),
    "meta": meta?.toJson(),
    "success": success,
    "status": status,
  };
}

class ShopsAll {
  dynamic id;
  String? slug;
  String? name;
  String? logo;
  dynamic rating;
  dynamic productsCount;
  dynamic totalSales;
  String? address;
  bool select = false;
  ShopsAll({
    this.id,
    this.slug,
    this.name,
    this.logo,
    this.rating,
    this.productsCount,
    this.totalSales,
    this.address,
    this.select = false,
  });

  factory ShopsAll.fromRawJson(String str) =>
      ShopsAll.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ShopsAll.fromJson(Map<String, dynamic> json) => ShopsAll(
    id: json["id"],
    slug: json["slug"],
    name: json["name"],
    logo: json["logo"],
    select: json["select"] ?? false,

    rating: json["rating"],
    productsCount: json["products_count"],
    totalSales: json["total_sales"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
    "name": name,
    "logo": logo,
    "rating": rating,
    "select": select,
    "products_count": productsCount,
    "total_sales": totalSales,
    "address": address,
  };
}

class Links {
  String? first;
  String? last;
  dynamic prev;
  dynamic next;

  Links({this.first, this.last, this.prev, this.next});

  factory Links.fromRawJson(String str) => Links.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Links.fromJson(Map<String, dynamic> json) => Links(
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

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links:
        json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links":
        links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
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

  Link({this.url, this.label, this.active});

  factory Link.fromRawJson(String str) => Link.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Link.fromJson(Map<String, dynamic> json) =>
      Link(url: json["url"], label: json["label"], active: json["active"]);

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}
