// To parse this JSON data, do
//
//     final startLiveSellerResponse = startLiveSellerResponseFromJson(jsonString);

import 'dart:convert';

StartLiveSellerResponse startLiveSellerResponseFromJson(String str) =>
    StartLiveSellerResponse.fromJson(json.decode(str));

String startLiveSellerResponseToJson(StartLiveSellerResponse data) =>
    json.encode(data.toJson());

class StartLiveSellerResponse {
  Data data;
  String message;
  bool result;
  dynamic code;

  StartLiveSellerResponse({
    required this.data,
    required this.message,
    required this.result,
    required this.code,
  });

  factory StartLiveSellerResponse.fromJson(Map<String, dynamic> json) =>
      StartLiveSellerResponse(
        data: Data.fromJson(json["data"]),
        message: json["message"],
        result: json["result"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "result": result,
        "code": code,
      };
}

class Data {
  dynamic id;
  Auction auction;
  String streamKey;
  String channelArn;
  String playbackUrl;
  String rtmpUrl;

  Data({
    required this.id,
    required this.auction,
    required this.streamKey,
    required this.channelArn,
    required this.playbackUrl,
    required this.rtmpUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        auction: Auction.fromJson(json["auction"]),
        streamKey: json["stream_key"],
        channelArn: json["channel_arn"],
        playbackUrl: json["playback_url"],
        rtmpUrl: json["rtmp_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "auction": auction.toJson(),
        "stream_key": streamKey,
        "channel_arn": channelArn,
        "playback_url": playbackUrl,
        "rtmp_url": rtmpUrl,
      };
}

class Auction {
  dynamic id;
  String slug;
  dynamic sellerId;
  dynamic shopId;
  dynamic shopSlug;
  dynamic shopName;
  dynamic shopLogo;
  dynamic name;
  dynamic thumbnailImage;
  List<dynamic> photos;
  dynamic description;
  bool hasDiscount;
  String mainPrice;
  dynamic rating;
  dynamic sales;
  String status;
  AuctionPeriodClass auctionPeriod;
  AuctionPeriodClass auctionTimeLeft;
  DateTime auctionEndDateString;
  bool isFavorite;
  dynamic assuranceFee;
  bool isPaidAssuranceFee;
  dynamic isLive;
  dynamic isPaused;
  Links links;

  Auction({
    required this.id,
    required this.slug,
    required this.sellerId,
    required this.shopId,
    required this.shopSlug,
    required this.shopName,
    required this.shopLogo,
    required this.name,
    required this.thumbnailImage,
    required this.photos,
    required this.description,
    required this.hasDiscount,
    required this.mainPrice,
    required this.rating,
    required this.sales,
    required this.status,
    required this.auctionPeriod,
    required this.auctionTimeLeft,
    required this.auctionEndDateString,
    required this.isFavorite,
    required this.assuranceFee,
    required this.isPaidAssuranceFee,
    required this.isLive,
    required this.isPaused,
    required this.links,
  });

  factory Auction.fromJson(Map<String, dynamic> json) => Auction(
        id: json["id"],
        slug: json["slug"],
        sellerId: json["seller_id"],
        shopId: json["shop_id"],
        shopSlug: json["shop_slug"],
        shopName: json["shop_name"],
        shopLogo: json["shop_logo"],
        name: json["name"],
        thumbnailImage: json["thumbnail_image"],
        photos: List<dynamic>.from(json["photos"].map((x) => x)),
        description: json["description"],
        hasDiscount: json["has_discount"],
        mainPrice: json["main_price"],
        rating: json["rating"],
        sales: json["sales"],
        status: json["status"],
        auctionPeriod: AuctionPeriodClass.fromJson(json["auction_period"]),
        auctionTimeLeft: AuctionPeriodClass.fromJson(json["auction_time_left"]),
        auctionEndDateString: DateTime.parse(json["auction_end_date_string"]),
        isFavorite: json["is_favorite"],
        assuranceFee: json["assurance_fee"],
        isPaidAssuranceFee: json["is_paid_assurance_fee"],
        isLive: json["is_live"],
        isPaused: json["is_paused"],
        links: Links.fromJson(json["links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slug": slug,
        "seller_id": sellerId,
        "shop_id": shopId,
        "shop_slug": shopSlug,
        "shop_name": shopName,
        "shop_logo": shopLogo,
        "name": name,
        "thumbnail_image": thumbnailImage,
        "photos": List<dynamic>.from(photos.map((x) => x)),
        "description": description,
        "has_discount": hasDiscount,
        "main_price": mainPrice,
        "rating": rating,
        "sales": sales,
        "status": status,
        "auction_period": auctionPeriod.toJson(),
        "auction_time_left": auctionTimeLeft.toJson(),
        "auction_end_date_string": auctionEndDateString.toIso8601String(),
        "is_favorite": isFavorite,
        "assurance_fee": assuranceFee,
        "is_paid_assurance_fee": isPaidAssuranceFee,
        "is_live": isLive,
        "is_paused": isPaused,
        "links": links.toJson(),
      };
}

class AuctionPeriodClass {
  dynamic days;
  dynamic hours;
  dynamic minutes;
  dynamic seconds;

  AuctionPeriodClass({
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  factory AuctionPeriodClass.fromJson(Map<String, dynamic> json) =>
      AuctionPeriodClass(
        days: json["days"],
        hours: json["hours"],
        minutes: json["minutes"],
        seconds: json["seconds"],
      );

  Map<String, dynamic> toJson() => {
        "days": days,
        "hours": hours,
        "minutes": minutes,
        "seconds": seconds,
      };
}

class Links {
  String details;

  Links({
    required this.details,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        details: json["details"],
      );

  Map<String, dynamic> toJson() => {
        "details": details,
      };
}
