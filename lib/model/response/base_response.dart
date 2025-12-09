// ignore_for_file: prefer_if_null_operators

class BaseResponse {
  bool? result;
  dynamic message;
  dynamic code;

  BaseResponse({this.result, required this.message, this.code});

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      result: json["result"] == null ? null : json["result"],
      message:
          json["message"] is List
              ? List<String>.from(json["message"].map((x) => x))
              : json["message"],
      code: json["code"] == null ? null : json["code"],
      //0597080363   سلطان
    );
  }

  Map<String, dynamic> toJson() => {
    "result": result,
    "message":
        message is List
            ? List<dynamic>.from(message.map((x) => x))
            : message, // إذا كانت نصًا
    "code": code,
  };
}
