import 'dart:convert';

class CommentResponse {
  List<Comments>? data;
  Links? links;
  Meta? meta;
  bool? success;
  int? status;
  bool? result;
  int? code;

  CommentResponse({
    this.data,
    this.links,
    this.meta,
    this.success,
    this.status,
    this.result,
    this.code,
  });

  factory CommentResponse.fromRawJson(String str) =>
      CommentResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CommentResponse.fromJson(Map<String, dynamic> json) =>
      CommentResponse(
        data:
            json["data"] == null
                ? []
                : List<Comments>.from(
                  json["data"]!.map((x) => Comments.fromJson(x)),
                ),
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        success: json["success"],
        status: json["status"],
        result: json["result"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links?.toJson(),
    "meta": meta?.toJson(),
    "success": success,
    "status": status,
    "result": result,
    "code": code,
  };
}

class Comments {
  int? id;
  String? name;
  dynamic image;
  String? comment;
  dynamic likesCount;
  dynamic isLiked;
  int? productId;
  DateTime? createdAt;

  Comments({
    this.id,
    this.name,
    this.image,
    this.comment,
    this.likesCount,
    this.isLiked,
    this.productId,
    this.createdAt,
  });

  factory Comments.fromRawJson(String str) =>
      Comments.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    comment: json["comment"],
    likesCount: json["likes_count"],
    isLiked: json["is_liked"],
    productId: json["product_id"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "comment": comment,
    "likes_count": likesCount,
    "is_liked": isLiked,
    "product_id": productId,
    "created_at": createdAt?.toIso8601String(),
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
