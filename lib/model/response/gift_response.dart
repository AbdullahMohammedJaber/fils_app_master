// To parse this JSON data, do
//
//     final giftResponse = giftResponseFromJson(jsonString);

import 'dart:convert';

GiftResponse giftResponseFromJson(String str) =>
    GiftResponse.fromJson(json.decode(str));

String giftResponseToJson(GiftResponse data) => json.encode(data.toJson());

class GiftResponse {
  dynamic amount;
  String auctionId;
  dynamic giftId;
  String message;
  Receiver receiver;
  String receiverId;
  Sender sender;
  dynamic senderId;
  String status;
  String title;

  GiftResponse({
    required this.amount,
    required this.auctionId,
    required this.giftId,
    required this.message,
    required this.receiver,
    required this.receiverId,
    required this.sender,
    required this.senderId,
    required this.status,
    required this.title,
  });

  factory GiftResponse.fromJson(Map<String, dynamic> json) => GiftResponse(
    amount: json["amount"],
    auctionId: json["auction_id"],
    giftId: json["gift_id"],
    message: json["message"],
    receiver: Receiver.fromJson(json["receiver"]),
    receiverId: json["receiver_id"],
    sender: Sender.fromJson(json["sender"]),
    senderId: json["sender_id"],
    status: json["status"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "auction_id": auctionId,
    "gift_id": giftId,
    "message": message,
    "receiver": receiver.toJson(),
    "receiver_id": receiverId,
    "sender": sender.toJson(),
    "sender_id": senderId,
    "status": status,
    "title": title,
  };
}

class Receiver {
  String email;
  dynamic id;
  String name;
  String phone;
  String type;

  Receiver({
    required this.email,
    required this.id,
    required this.name,
    required this.phone,
    required this.type,
  });

  factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
    email: json["email"],
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "id": id,
    "name": name,
    "phone": phone,
    "type": type,
  };
}

class Sender {
  String avatarOriginal;
  String email;
  dynamic id;
  String name;
  String phone;
  String type;

  Sender({
    required this.avatarOriginal,
    required this.email,
    required this.id,
    required this.name,
    required this.phone,
    required this.type,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
    avatarOriginal: json["avatar_original"],
    email: json["email"],
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "avatar_original": avatarOriginal,
    "email": email,
    "id": id,
    "name": name,
    "phone": phone,
    "type": type,
  };
}
