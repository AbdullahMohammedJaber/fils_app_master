// ignore_for_file: missing_return, unused_local_variable, unrelated_type_equality_checks

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:fils/screen/auth/login/screen/login_screen.dart';
import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/route/route.dart';
import 'package:flutter/foundation.dart';

// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fils/model/response/base_response.dart';

import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fils/utils/enum/error_type.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/http/http_override.dart';
import 'package:fils/utils/http/service.dart';
import 'package:fils/utils/global_function/printer.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

httpHelperIni() {
  HttpOverrides.global = MyHttpOverrides();
  changeDomain1();
}

String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

class NetworkHelper {
  static Future<OAuthCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      printGreen(googleUser!.email);

      if (googleUser == null) {
        debugPrint("🔴 Google sign-in canceled by user");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        debugPrint("🔴 Google auth tokens are null");
        return null;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      return credential;
    } catch (e) {
      debugPrint("❌ Google Sign-In Error: $e");
      return null;
    }
  }

  static Future<AuthorizationCredentialAppleID?> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider(
        "apple.com",
      ).credential(idToken: appleCredential.identityToken, rawNonce: rawNonce);

      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      return appleCredential;
    } catch (e) {
      debugPrint("❌ Apple Sign-In Error: $e");
      return null;
    }
  }

  static Future<OAuthCredential?> signInWithFacebook() async {
    return null;

    // try {
    //   final LoginResult loginResult = await FacebookAuth.instance.login();
    //
    //   if (loginResult.status == LoginStatus.success) {
    //     final AccessToken? accessToken = loginResult.accessToken;
    //
    //     if (accessToken != null) {
    //       final OAuthCredential credential =
    //           FacebookAuthProvider.credential(accessToken.token);
    //
    //       await FirebaseAuth.instance.signInWithCredential(credential);
    //
    //       return credential;
    //     }
    //   } else if (loginResult.status == LoginStatus.cancelled) {
    //     log('Facebook sign-in was cancelled by the user.');
    //   } else {
    //     log('Facebook sign-in failed: ${loginResult.message}');
    //   }
    // } catch (e) {
    //   log('Error during Facebook sign-in: $e');
    // }
    // return null;
  }

  static Future<Map<String, dynamic>> sendRequest({
    required RequestType requestType,
    required String endpoint,
    Map<String, dynamic>? fields,
    Map<String, File>? files,
  }) async {
    printGreen("======> Url: $domain/$endpoint");
    printGreen("======> requestType: $requestType");
    printGreen("======> fields: ${fields.toString()}");
    printGreen("======> Files: ${files.toString()}");
    printGreen("===> Fcm-Token: ${getFcmToken()}");
    printGreen("===> User-Token: ${getUserToken().toString()}");
    printGreen("===>shop_id: ${getAllShop().id}");
    if (isLogin()) {
      printGreen("===> User-ID: ${getUser()!.user!.id}");
    }
    printGreen('''
     ===> Header
     'Accept': 'application/json',
     'Accept-Language': ${getLocal() ?? 'ar'},
     'Authorization': 'Bearer ${getUserToken().toString()}',
     'fcmToken': ${getFcmToken() ?? "123"},
     'Content-Type': 'application/json',
     'shop_id': ${getAllShop().id.toString()},
    ''');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      printWarning("======> No Access Internet");
      return {
        'errorMessage': "No Internet Connection".tr(),
        'statusCode': "500",
        'errorType': ErrorType.noInternetConnection,
      };
    }
    final url = Uri.parse('$domain/$endpoint');
    late http.Response response;
    try {
      switch (requestType) {
        case RequestType.get:
          final request =
              http.Request('GET', url)
                ..headers.addAll({
                  'Accept': 'application/json',
                  'Accept-Language': getLocal(),
                  'Authorization': 'Bearer ${getUserToken()}',
                  'fcmToken': getFcmToken() ?? "123",
                  'device_token': getFcmToken() ?? "123",
                  'Content-Type': 'application/json',
                  'API-KEY': '123456',
                  'shop_id': getAllShop().id.toString(),
                })
                ..body = fields == null ? jsonEncode({}) : jsonEncode(fields);
          final streamedResponse = await request.send().timeout(
            const Duration(seconds: 15),
          );
          response = await http.Response.fromStream(streamedResponse);
          break;

        case RequestType.post:
          response = await _postOrPutRequest(
            url,
            fields,
            files,
            getUserToken()!,
          );
          break;

        case RequestType.put:
          response = await _postOrPutRequest(
            url,
            fields,
            files,
            getUserToken()!,
          );
          break;

        case RequestType.delete:
          final request =
              http.Request('DELETE', url)
                ..headers.addAll({
                  'Accept': 'application/json',
                  'Accept-Language': getLocal(),
                  'Authorization': 'Bearer ${getUserToken()}',
                  'fcmToken': getFcmToken() ?? "123",
                  'device_token': getFcmToken() ?? "123",
                  'Content-Type': 'application/json',
                  'API-KEY': '123456',
                  'shop_id': getAllShop().id.toString(),
                })
                ..body = fields == null ? jsonEncode({}) : jsonEncode(fields);
          final streamedResponse = await request.send().timeout(
            const Duration(seconds: 15),
          );
          response = await http.Response.fromStream(streamedResponse);
          break;
        case RequestType.patch:
          break;
      }
      log("response.general ${response.statusCode}");
      if (response.statusCode == 200) {
        printGreen(
          "response.status $url ${json.decode(response.body)['status']}",
        );
        log("response.body ${json.decode(response.body)}");

        if (json.decode(response.body)['status'] == true ||
            json.decode(response.body)['status'] == '200' ||
            json.decode(response.body)['status'] == 200 ||
            json.decode(response.body)['status'] == null) {
          return json.decode(response.body);
        } else {
          return {
            'errorMessage': "${json.decode(response.body)['message']}",
            'statusCode': '400',
            'errorType': ErrorType.notSuccess,
          };
        }
      } else if (response.statusCode == 429) {
        var errorMessage =
            "You have exceeded the maximum number of attempts. Please try again after 43 seconds.";
        showCustomFlash(message: errorMessage, messageType: MessageType.Faild);
        return {};
      }
      else if (response.statusCode == 401) {
        BaseResponse baseResponse = BaseResponse.fromJson(
          json.decode(response.body),
        );
        setLogin(false);
        changeDomain1();
        showCustomFlash(
          message: baseResponse.message,
          messageType: MessageType.Faild,
        );
        toRemoveAll(
          NavigationService.navigatorKey.currentContext!,
          const LoginScreen(),
        );
        return {};
      }
      else {
        printWarning("======> Response Error");
        printWarningLong("$url  ${json.decode(response.body).toString()}");
        BaseResponse baseResponse = BaseResponse.fromJson(
          json.decode(response.body),
        );
        String? combinedMessage;
        if (baseResponse.message is List) {
          combinedMessage = baseResponse.message!.join('\n');
        } else {
          combinedMessage = baseResponse.message;
        }

        showCustomFlash(
          message: combinedMessage!,
          messageType: MessageType.Faild,
        );

        return {
          'errorMessage': baseResponse.message,
          'statusCode': baseResponse.code,
          'errorType': ErrorType.notSuccess,
        };
      }
    } on SocketException {
      printWarning("======> No Access Internet");
      /* showCustomFlash(
        messageType: MessageType.Faild,
        message: "No Internet Connection".tr(),
      );*/

      return {
        'errorMessage': "No Internet Connection".tr(),
        'statusCode': "500",
        'errorType': ErrorType.noInternetConnection,
      };
    } on TimeoutException {
      printWarning("======> Time Out Connection");
      /* showCustomFlash(
        messageType: MessageType.Faild,
        message: "No Internet Connection".tr(),
      );*/

      return {
        'errorMessage': "Time Out Connection".tr(),
        'statusCode': "500",
        'errorType': ErrorType.timeOut,
      };
    } catch (e) {
      printWarning("======> Crash Error $e");
      return {
        'errorMessage': e,
        'statusCode': '404',
        'errorType': ErrorType.crachError,
      };
    }
  }

  static Future<http.Response> _postOrPutRequest(
    Uri url,
    Map<String, dynamic>? fields,
    Map<String, File>? files,
    String userToken,
  ) async {
    http.BaseRequest request;

    if (files != null && files.isNotEmpty) {
      var multipartRequest = http.MultipartRequest('POST', url);

      multipartRequest.headers.addAll({
        'Accept': 'application/json',
        'Accept-Language': getLocal(),
        'Authorization': 'Bearer $userToken',
        'fcmToken': getFcmToken() ?? "123",
        'device_token': getFcmToken() ?? "123",
        'API-KEY': '123456',
        'shop_id': getAllShop().id.toString(),
      });

      if (fields != null) {
        fields.forEach((key, value) {
          if (value is List) {
            multipartRequest.fields[key] = jsonEncode(value);
          } else {
            multipartRequest.fields[key] = value.toString();
          }
        });
      }

      for (var entry in files.entries) {
        String fieldName = entry.key;
        File file = entry.value;
        multipartRequest.files.add(
          await http.MultipartFile.fromPath(fieldName, file.path),
        );
      }

      request = multipartRequest;
    } else {
      var simpleRequest = http.Request('POST', url);

      simpleRequest.headers.addAll({
        'Accept': 'application/json',
        'Accept-Language': getLocal(),
        'Authorization': 'Bearer $userToken',
        'fcmToken': getFcmToken() ?? "123",
        'Content-Type': 'application/json',
        'API-KEY': '123456',
        'shop_id': getAllShop().id.toString(),
      });

      if (fields != null) {
        simpleRequest.body = jsonEncode(fields);
      }

      request = simpleRequest;
    }

    if (kDebugMode) {
      print('Fields Sent: ${fields != null ? jsonEncode(fields) : "{}"}');
    }

    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 20),
    );
    final response = await http.Response.fromStream(streamedResponse);

    printGreenLong('===> Response Body: ${response.body}');

    return response;
  }
}
