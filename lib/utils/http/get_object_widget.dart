// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unrelated_type_equality_checks

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fils/utils/animation/custom_fade_animation.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/printer.dart';
import 'package:fils/utils/global_function/update_controller.dart';
import 'package:fils/utils/http/service.dart';
import 'package:fils/utils/screen_catch/crach_screen.dart';
import 'package:fils/utils/screen_catch/no_Internet_connection.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../model/response/base_response.dart';
import '../../screen/auth/login/screen/login_screen.dart';
import '../../screen/general/chat_boot.dart';
import '../NavigatorObserver/Navigator_observe.dart';
import '../const.dart';
import '../enum/message_type.dart';
import '../message_app/show_flash_message.dart';
import '../route/route.dart';
import '../storage/storage.dart';
import '../theme/color_manager.dart';

class CustomRequestWidget<T> extends StatefulWidget {
  String? url;
  final RequestType? requestType;
  final Map<String, dynamic>? requestBody;
  final Widget Function(BuildContext?, T?)? buildResponse;
  final T Function(dynamic)? parseResponse;
  UpdateController? updateController;
  Widget? customLoading;
  final String? cacheKey;

  CustomRequestWidget({
    super.key,
    required this.url,
    this.customLoading,
    required this.requestType,
    required this.buildResponse,
    required this.parseResponse,
    this.updateController,
    this.requestBody,
    this.cacheKey,
  });

  @override
  _CustomRequestWidgetState<T> createState() => _CustomRequestWidgetState<T>();
}

class _CustomRequestWidgetState<T> extends State<CustomRequestWidget<T>> {
  late Future<T> _futureData;

  Future<T> _fetchData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      if (widget.cacheKey != null) {
        final cachedData = GetStorage().read(widget.cacheKey!);
        if (cachedData != null) {
          return widget.parseResponse!(json.decode(cachedData));
        }
      }
      throw const SocketException('No Internet Connection');
    }

    var uri = Uri.parse('$domain/${widget.url}');
    print(uri.toString());

    late http.Response response;
    String token = getUserToken()!;
    try {
      switch (widget.requestType) {
        case RequestType.get:
          final request =
              http.Request('GET', uri)
                ..headers.addAll({
                  'Accept': 'application/json',
                  'Accept-Language': getLocal(),
                  'Authorization': 'Bearer $token',
                  'fcmToken': getFcmToken() ?? "123",
                  'Content-Type': 'application/json',
                  'API-KEY': '123456',
                  'shop_id': getAllShop().id.toString(),
                })
                ..body =
                    widget.requestBody == null
                        ? jsonEncode({})
                        : jsonEncode(widget.requestBody);
          final streamedResponse = await request.send().timeout(
            const Duration(seconds: 15),
          );
          response = await http.Response.fromStream(streamedResponse);

          break;

        case RequestType.post:
          response = await http
              .post(
                uri,
                body:
                    widget.requestBody != null
                        ? json.encode(widget.requestBody)
                        : null,
                headers: {
                  'Accept': 'application/json',
                  'Accept-Language': getLang() ?? 'ar',
                  'Authorization': 'Bearer $token',
                  'fcmToken': getFcmToken() ?? "123",
                  'Content-Type': 'application/json',
                  'API-KEY': '123456',
                  'shop_id': getAllShop().id.toString(),
                },
              )
              .timeout(const Duration(seconds: 15));
          break;

        case RequestType.put:
          response = await http
              .put(
                uri,
                body:
                    widget.requestBody != null
                        ? json.encode(widget.requestBody)
                        : null,
                headers: {
                  'Accept': 'application/json',
                  'Accept-Language': getLang() ?? 'ar',
                  'Authorization': 'Bearer $token',
                  'fcmToken': getFcmToken() ?? "123",
                  'Content-Type': 'application/json',
                  'API-KEY': '123456',
                  'shop_id': getAllShop().id.toString(),
                },
              )
              .timeout(const Duration(seconds: 15));
          break;

        case RequestType.delete:
          response = await http
              .delete(uri)
              .timeout(const Duration(seconds: 15));
          break;

        case RequestType.patch:
        case null:
          throw Exception("Unsupported request type");
      }

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        print(decoded);

        if (widget.cacheKey != null) {
          await GetStorage().write(widget.cacheKey!, response.body);
        }
        return widget.parseResponse!(decoded);
      }
      else if(response.statusCode==401){
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
        throw Exception('Unexpected error: ${response.statusCode}');


      }
      else {
        log("===>Error ${json.decode(response.body)}");
        throw Exception('Unexpected error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No Internet Connection');
    } on TimeoutException {
      throw Exception('Request Timed Out');
    } catch (e) {
      printWarning('Error: $e');
      throw Exception('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.updateController != null) {
      widget.updateController!.updateWithNewUrl = updateWithNewUrl;
      widget.updateController!.update = update;
    }
    _futureData = _fetchData();
  }

  updateWithNewUrl(url) {
    widget.url = url;
    setState(() {
      _futureData = _fetchData();
    });
  }

  update() {
    setState(() {
      _futureData = _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          if (widget.customLoading != null) {
            return widget.customLoading!;
          } else {
            return Center(child: TypingIndicator(color: primaryDarkColor));
          }
        } else if (snapshot.hasError) {
          final errorMsg = snapshot.error.toString();
          final isOfflineError =

              errorMsg.contains('No Internet Connection') ||
              errorMsg.contains('No Access Internet') ||
              errorMsg.contains('Request Timed Out') ||
              errorMsg.contains('Connection terminated during handshake');

          if (isOfflineError && widget.cacheKey != null) {
            final cachedData = GetStorage().read(widget.cacheKey!);
            if (cachedData != null) {
              try {
                final parsed = widget.parseResponse!(json.decode(cachedData));
                return CustomFadeAnimationComponent(
                  1,
                  RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _futureData = _fetchData();
                      });
                      await _futureData;
                    },
                    child: widget.buildResponse!(context, parsed),
                  ),
                );
              } catch (e) {
                printWarning("فشل التحويل من الكاش: $e");
                // نتابع إلى شاشة NoInternet
              }
            }
          }

          if (isOfflineError) {
            return NoInternetConnection(
              onTryAgain: () {
                setState(() {
                  _futureData = _fetchData();
                });
              },
            );
          } else {
            return CrachScreen(
              onTryAgain: () {
                setState(() {
                  _futureData = _fetchData();
                });
              },
            );
          }
        } else if (!snapshot.hasData) {
          return Center(child: DefaultText('No Data Found'.tr()));
        } else {
          return CustomFadeAnimationComponent(
            1,
            RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _futureData = _fetchData();
                });
                await _futureData;
              },
              child: widget.buildResponse!(context, snapshot.data),
            ),
          );
        }
      },
    );
  }
}
