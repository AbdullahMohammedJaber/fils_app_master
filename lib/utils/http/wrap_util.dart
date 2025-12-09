// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fils/screen/general/chat_boot.dart';
import 'package:fils/utils/global_function/printer.dart';
import 'package:fils/utils/global_function/update_controller.dart';
import 'package:fils/utils/http/service.dart';
import 'package:fils/utils/screen_catch/no_Internet_connection.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../enum/request_type.dart';
import 'package:http/http.dart' as http;

class StaticWrapView<T> extends StatefulWidget {
  String endpoint;
  final RequestType requestType;
  final Map<String, dynamic>? requestBody;
  final String? cacheKey;
  final T Function(dynamic) parseItem;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final UpdateController? updateController;
  final int rows; // عدد الصفوف
  final int columns; // عدد الأعمدة
  final Widget? emptyWidget;

  StaticWrapView({
    super.key,
    required this.endpoint,
    required this.requestType,
    required this.parseItem,
    required this.itemBuilder,
    this.cacheKey,
    this.requestBody,
    this.updateController,
    this.emptyWidget,
    this.rows = 3,
    this.columns = 3,
  });

  @override
  State<StaticWrapView<T>> createState() => _StaticWrapViewState<T>();
}

class _StaticWrapViewState<T> extends State<StaticWrapView<T>> {
  late Future<List<T>> _futureData;
  final PageController _pageController = PageController();

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
          int itemsPerPage = widget.rows * widget.columns;
          int pageCount = (snapshot.data!.length / itemsPerPage).ceil();

          return Column(
            children: [
              SizedBox(
                height: 150.0 * widget.rows,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pageCount,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, pageIndex) {
                    int start = pageIndex * itemsPerPage;
                    int end = (start + itemsPerPage).clamp(
                      0,
                      snapshot.data!.length,
                    );
                    List<T> pageItems = snapshot.data!.sublist(start, end);

                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: pageItems.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widget.columns,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        return widget.itemBuilder(context, pageItems[index]);
                      },
                    );
                  },
                ),
              ),

              SimplePageIndicator(
                controller: _pageController,
                count: pageCount,
                activeColor: primaryColor,
              ),
            ],
          );
        }
      },
    );
  }
}

class SimplePageIndicator extends StatelessWidget {
  final PageController controller;
  final int count;
  final Color activeColor;
  final Color inactiveColor;
  final double dotSize;
  final double spacing;

  const SimplePageIndicator({
    super.key,
    required this.controller,
    required this.count,
    this.activeColor = Colors.orange,
    this.inactiveColor = Colors.grey,
    this.dotSize = 10,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double page = 0;
        try {
          page = controller.page ?? controller.initialPage.toDouble();
        } catch (_) {
          page = controller.initialPage.toDouble();
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(count, (index) {
            double selectedness =
                (1.0 - ((page - index).abs().clamp(0.0, 1.0)));
            double size = dotSize + (dotSize * 0.5 * selectedness);
            return Container(
              width: size,
              height: size,
              margin: EdgeInsets.symmetric(horizontal: spacing / 2),
              decoration: BoxDecoration(
                color: Color.lerp(inactiveColor, activeColor, selectedness),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
