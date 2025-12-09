class Gift {
  final String amount;
  final String auctionId;
  final int giftId;
  final String message;
  final String title;
  final User receiver;
  final User sender;
  final String status;

  Gift({
    required this.amount,
    required this.auctionId,
    required this.giftId,
    required this.message,
    required this.title,
    required this.receiver,
    required this.sender,
    required this.status,
  });

  factory Gift.fromJson(Map<dynamic, dynamic> json) {
    Map<String, dynamic> safe(Map<dynamic, dynamic>? map) {
      if (map == null) return {};
      final result = <String, dynamic>{};
      map.forEach((key, value) {
        if (key != null) result[key.toString()] = value;
      });
      return result;
    }

    return Gift(
      amount: json['amount']?.toString() ?? '',
      auctionId: json['auction_id']?.toString() ?? '',
      giftId: int.tryParse(json['gift_id']?.toString() ?? '') ?? 0,
      message: json['message']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      receiver: User.fromJson(safe(json['receiver'])),
      sender: User.fromJson(safe(json['sender'])),
      status: safe(json['status'])['status']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'auction_id': auctionId,
      'gift_id': giftId,
      'message': message,
      'title': title,
      'receiver': receiver.toJson(),
      'sender': sender.toJson(),
      'status': {'status': status},
    };
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String type;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.type,
  });

  factory User.fromJson(Map<dynamic, dynamic> json) {
    Map<String, dynamic> safe(Map<dynamic, dynamic>? map) {
      if (map == null) return {};
      final result = <String, dynamic>{};
      map.forEach((key, value) {
        if (key != null) result[key.toString()] = value;
      });
      return result;
    }

    final map = safe(json);
    return User(
      id: int.tryParse(map['id']?.toString() ?? '') ?? 0,
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      type: map['type']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'type': type,
    };
  }
}
