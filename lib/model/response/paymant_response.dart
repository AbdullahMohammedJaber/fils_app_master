// ignore_for_file: unnecessary_this, prefer_collection_literals

class PaymentResponse {
  bool? result;
  List<Data>? data;
  dynamic code;

  PaymentResponse({this.result, this.data, this.code});

  PaymentResponse.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['result'] = this.result;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    return data;
  }
}

class Data {
  String? paymentType;
  String? paymentTypeKey;
  String? image;
  String? name;
  String? title;
  dynamic offlinePaymentId;
  String? details;
  bool isSelect = false;
  Data({
    this.paymentType,
    this.paymentTypeKey,
    this.image,
    this.name,
    this.title,
    this.offlinePaymentId,
    this.details,
  });

  Data.fromJson(Map<String, dynamic> json) {
    paymentType = json['payment_type'];
    paymentTypeKey = json['payment_type_key'];
    image = json['image'];
    name = json['name'];
    title = json['title'];
    offlinePaymentId = json['offline_payment_id'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['payment_type'] = this.paymentType;
    data['payment_type_key'] = this.paymentTypeKey;
    data['image'] = this.image;
    data['name'] = this.name;
    data['title'] = this.title;
    data['offline_payment_id'] = this.offlinePaymentId;
    data['details'] = this.details;
    return data;
  }
}
