// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'dart:io';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../screen/general/chat_boot.dart';
import '../../utils/enum/request_type.dart';
import '../../utils/global_function/printer.dart';
import '../../utils/global_function/update_controller.dart';
import '../../utils/http/service.dart';
import '../../utils/screen_catch/no_Internet_connection.dart';
import '../../utils/storage/storage.dart';
import '../../widget/defulat_text.dart';
import '../theme/color_manager.dart';

class StaticGridView<T> extends StatefulWidget {
  String endpoint;
  final RequestType requestType;
  final Map<String, dynamic>? requestBody;
  final String? cacheKey;
  final T Function(dynamic) parseItem;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final SliverGridDelegate sliverGridDelegate;
  final UpdateController? updateController;
  final bool shrinkWrap;
  final ScrollPhysics? scrollPhysics;
  final Widget? emptyWidget;
  Axis scrollDirection = Axis.vertical;
  StaticGridView({
    super.key,
    required this.endpoint,
    required this.requestType,
    required this.scrollDirection,
    required this.parseItem,
    required this.itemBuilder,
    required this.sliverGridDelegate,
    this.cacheKey,
    this.scrollPhysics,
    this.requestBody,
    this.updateController,
    this.emptyWidget,
    this.shrinkWrap = false,
  });

  @override
  State<StaticGridView<T>> createState() => _StaticGridViewState<T>();
}

class _StaticGridViewState<T> extends State<StaticGridView<T>> {
  late Future<List<T>> _futureData;

  @override
  void initState() {
    super.initState();
    if (widget.updateController != null) {
      widget.updateController!.update = _reloadData;
      widget.updateController!.updateWithNewUrl = _updateWithNewUrl;
    }
    _futureData = _fetchData();
  }

  Future<List<T>> _loadCachedDataOrThrow() async {
    if (widget.cacheKey != null) {
      final cached = GetStorage().read(widget.cacheKey!);
      if (cached != null) {
        try {
          final decoded = json.decode(cached);
          if (decoded is List) {
            return decoded.map<T>((e) => widget.parseItem(e)).toList();
          } else if (decoded is Map && decoded['data'] is List) {
            return (decoded['data'] as List)
                .map<T>((e) => widget.parseItem(e))
                .toList();
          }
        } catch (e) {
          printWarning("Cache parsing failed: $e");
        }
      }
    }
    throw const SocketException("No cached data available");
  }

  Future<List<T>> _fetchData() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.none) {
        printWarning('No internet - using cache');
        return await _loadCachedDataOrThrow();
      }

      var uri = Uri.parse('$domain/${widget.endpoint}');
      late http.Response response;
      String token = getUserToken()!;

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

        default:
          throw UnimplementedError("Request type not implemented");
      }

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
          printBlueLong(decoded.toString());
        if (widget.cacheKey != null) {
          await GetStorage().write(widget.cacheKey!, response.body);
        }

        if (decoded is List) {
          return decoded.map<T>((e) => widget.parseItem(e)).toList();
        } else if (decoded is Map && decoded['data'] is List) {
          return (decoded['data'] as List)
              .map<T>((e) => widget.parseItem(e))
              .toList();
        } else {
          throw Exception("Invalid response format");
        }
      } else {
        throw Exception('Unexpected status: ${response.statusCode}');
      }
    } catch (e) {
      printWarning("Error occurred, loading from cache: $e");
      return await _loadCachedDataOrThrow();
    }
  }

  void _reloadData() {
    setState(() {
      _futureData = _fetchData();
    });
  }

  void _updateWithNewUrl(String url) {
    setState(() {
      widget.endpoint = url;
      _futureData = _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: TypingIndicator(color: primaryDarkColor));
        } else if (snapshot.hasError) {
          return NoInternetConnection(onTryAgain: _reloadData);
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return widget.emptyWidget ??
              Center(
                child: DefaultText('No Data Found'.tr(), type: FontType.bold),
              );
        } else {
          return RefreshIndicator(
            onRefresh: () async => _reloadData(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                physics: widget.scrollPhysics,
                shrinkWrap: widget.shrinkWrap,
                itemCount: snapshot.data!.length,
                gridDelegate: widget.sliverGridDelegate,
                scrollDirection: widget.scrollDirection,
                itemBuilder: (context, index) {
                  return widget.itemBuilder(context, snapshot.data![index]);
                },
              ),
            ),
          );
        }
      },
    );
  }
}
