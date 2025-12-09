

import 'dart:convert';

class PageSettingResponse {
  Page? page;
  bool? status;
  int? code;

  PageSettingResponse({
    this.page,
    this.status,
    this.code,
  });

  factory PageSettingResponse.fromRawJson(String str) => PageSettingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PageSettingResponse.fromJson(Map<String, dynamic> json) => PageSettingResponse(
    page: json["page"] == null ? null : Page.fromJson(json["page"]),
    status: json["status"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "page": page?.toJson(),
    "status": status,
    "code": code,
  };
}

class Page {
  int? id;
  String? type;
  String? title;
  String? slug;
  String? content;
  dynamic metaTitle;
  dynamic metaDescription;
  dynamic keywords;
  dynamic metaImage;
  DateTime? createdAt;
  DateTime? updatedAt;

  Page({
    this.id,
    this.type,
    this.title,
    this.slug,
    this.content,
    this.metaTitle,
    this.metaDescription,
    this.keywords,
    this.metaImage,
    this.createdAt,
    this.updatedAt,
  });

  factory Page.fromRawJson(String str) => Page.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Page.fromJson(Map<String, dynamic> json) => Page(
    id: json["id"],
    type: json["type"],
    title: json["title"],
    slug: json["slug"],
    content: json["content"],
    metaTitle: json["meta_title"],
    metaDescription: json["meta_description"],
    keywords: json["keywords"],
    metaImage: json["meta_image"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "title": title,
    "slug": slug,
    "content": content,
    "meta_title": metaTitle,
    "meta_description": metaDescription,
    "keywords": keywords,
    "meta_image": metaImage,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
