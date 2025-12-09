import 'package:fils/utils/enum/error_type.dart';

class ErrorResponse {
  dynamic errorMessage;
  dynamic statusCode;
  ErrorType? errorType;
  ErrorResponse({
    required this.errorMessage,
    required this.statusCode,
    required this.errorType,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      errorMessage: json['message'],
      statusCode: json['status'],
      errorType: json['errorType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "errorMessage": errorMessage,
      "statusCode": statusCode,
      "errorType": errorType,
    };
  }
}
