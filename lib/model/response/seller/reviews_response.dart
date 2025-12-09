// To parse this JSON data, do
//
//     final reviewsResponse = reviewsResponseFromJson(jsonString);


import 'dart:convert';

ReviewsResponse reviewsResponseFromJson(String str) => ReviewsResponse.fromJson(json.decode(str));

String reviewsResponseToJson(ReviewsResponse data) => json.encode(data.toJson());

class ReviewsResponse {
  List<Reviews> data;
  Links links;
  Meta meta;

  ReviewsResponse({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory ReviewsResponse.fromJson(Map<String, dynamic> json) => ReviewsResponse(
    data: List<Reviews>.from(json["data"].map((x) => Reviews.fromJson(x))),
    links: Links.fromJson(json["links"]),
    meta: Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "links": links.toJson(),
    "meta": meta.toJson(),
  };
}

class Reviews {
  String productId;
  String userId;
  num rating;
  String name;
  String avatar;
  String comment;

  Reviews({
    required this.productId,
    required this.userId,
    required this.rating,
    required this.name,
    required this.avatar,
    required this.comment,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
    productId: json["product_id"],
    userId: json["user_id"],
    rating: json["rating"],
    name: json["name"],
    avatar: json["avatar"],
    comment: json["comment"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "user_id": userId,
    "rating": rating,
    "name": name,
    "avatar": avatar,
    "comment": comment,
  };
}


class Links {
  String first;
  String last;
  dynamic prev;
  dynamic next;

  Links({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });

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
