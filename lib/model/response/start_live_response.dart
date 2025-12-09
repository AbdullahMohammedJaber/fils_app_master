// To parse this JSON data, do
//
//     final startLiveResponse = startLiveResponseFromJson(jsonString);

import 'dart:convert';

StartLiveResponse startLiveResponseFromJson(String str) =>
    StartLiveResponse.fromJson(json.decode(str));

String startLiveResponseToJson(StartLiveResponse data) =>
    json.encode(data.toJson());

class StartLiveResponse {
  Data data;
  String message;
  bool result;
  dynamic code;

  StartLiveResponse({
    required this.data,
    required this.message,
    required this.result,
    required this.code,
  });

  factory StartLiveResponse.fromJson(Map<String, dynamic> json) =>
      StartLiveResponse(
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
  String name;
  dynamic thumbnailImage;
  bool hasDiscount;
  String mainPrice;
  dynamic rating;
  dynamic sales;
  AuctionEndDate auctionEndDate;
  DateTime auctionEndDateString;
  dynamic isLive;
  dynamic isPaused;
  Links links;

  Auction({
    required this.id,
    required this.slug,
    required this.name,
    required this.thumbnailImage,
    required this.hasDiscount,
    required this.mainPrice,
    required this.rating,
    required this.sales,
    required this.auctionEndDate,
    required this.auctionEndDateString,
    required this.isLive,
    required this.isPaused,
    required this.links,
  });

  factory Auction.fromJson(Map<String, dynamic> json) => Auction(
        id: json["id"],
        slug: json["slug"],
        name: json["name"],
        thumbnailImage: json["thumbnail_image"],
        hasDiscount: json["has_discount"],
        mainPrice: json["main_price"],
        rating: json["rating"],
        sales: json["sales"],
        auctionEndDate: AuctionEndDate.fromJson(json["auction_end_date"]),
        auctionEndDateString: DateTime.parse(json["auction_end_date_string"]),
        isLive: json["is_live"],
        isPaused: json["is_paused"],
        links: Links.fromJson(json["links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slug": slug,
        "name": name,
        "thumbnail_image": thumbnailImage,
        "has_discount": hasDiscount,
        "main_price": mainPrice,
        "rating": rating,
        "sales": sales,
        "auction_end_date": auctionEndDate.toJson(),
        "auction_end_date_string": auctionEndDateString.toIso8601String(),
        "is_live": isLive,
        "is_paused": isPaused,
        "links": links.toJson(),
      };
}

class AuctionEndDate {
  dynamic days;
  dynamic hours;
  dynamic minutes;
  dynamic seconds;

  AuctionEndDate({
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  factory AuctionEndDate.fromJson(Map<String, dynamic> json) => AuctionEndDate(
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
