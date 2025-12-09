import 'dart:convert';

class AdsResponse {
  bool? status;
  dynamic code;
  List<Datum>? data;

  AdsResponse({this.status, this.code, this.data});

  factory AdsResponse.fromRawJson(dynamic str) =>
      AdsResponse.fromJson(json.decode(str));

  dynamic toRawJson() => json.encode(toJson());

  factory AdsResponse.fromJson(Map<dynamic, dynamic> json) => AdsResponse(
    status: json["status"],
    code: json["code"],
    data:
        json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<dynamic, dynamic> toJson() => {
    "status": status,
    "code": code,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  dynamic id;
  dynamic name;
  dynamic place;
  dynamic maxSlots;
  dynamic pricePerDay;
  bool? isAvailable;
  dynamic countDay = 1;
  dynamic productId;
  dynamic productName;
  dynamic auctionId;
  dynamic auctionName;
  bool isSelect = false;
  dynamic idImage;
  dynamic urlImage;

  Datum({
    this.id,
    this.name,
    this.place,
    this.maxSlots,
    this.pricePerDay,
    this.isAvailable,
  });

  factory Datum.fromRawJson(dynamic str) => Datum.fromJson(json.decode(str));

  dynamic toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<dynamic, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    place: json["place"],
    maxSlots: json["max_slots"],
    pricePerDay: json["price_per_day"],
    isAvailable: json["is_available"],
  );

  Map<dynamic, dynamic> toJson() => {
    "id": id,
    "name": name,
    "place": place,
    "max_slots": maxSlots,
    "price_per_day": pricePerDay,
    "is_available": isAvailable,
  };
}
