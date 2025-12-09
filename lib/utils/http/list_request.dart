// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/printer.dart';
import 'package:fils/utils/global_function/update_controller.dart';
import 'package:fils/utils/screen_catch/no_Internet_connection.dart';
import 'package:fils/utils/screen_catch/crach_screen.dart';
import 'package:fils/widget/defulat_text.dart';

import '../../screen/general/chat_boot.dart';
import '../theme/color_manager.dart';
import 'http_helper.dart';

class ListWidgetRequest<T> extends StatefulWidget {
  String endpoint;
  final RequestType requestType;
  final T Function(dynamic json) parseItem;
  final Widget Function(BuildContext context, T item) itemBuilder;
  UpdateController? updateController;
  final bool isParam;
  final bool isFirstData;
  final Widget? emptyWidget;
  final Map<String, dynamic>? requestBody;

  /// المفتاح الذي سيُستخدم لحفظ واسترجاع البيانات من الكاش
  final String? cacheKey;

  ListWidgetRequest({
    super.key,
    required this.endpoint,
    this.isParam = false,
    required this.requestType,
    required this.parseItem,
    required this.itemBuilder,
    required this.isFirstData,
    this.updateController,
    this.emptyWidget,
    this.requestBody,
    this.cacheKey,
  });

  @override
  State<ListWidgetRequest<T>> createState() => _ListWidgetRequestState<T>();
}

class _ListWidgetRequestState<T> extends State<ListWidgetRequest<T>> {
  late Future<List<T>> _futureData;
  List<T> items = [];
  bool isLoading = false; // To avoid multiple loads

  @override
  void initState() {
    super.initState();

    if (widget.updateController != null) {
      widget.updateController!.update = update;
      widget.updateController!.updateWithNewUrl = updateWithNewUrl;
    }

    _futureData = _fetchData();
  }

  Future<List<T>> _loadCachedData() async {
    if (widget.cacheKey != null) {
      final cachedString = GetStorage().read(widget.cacheKey!);
      if (cachedString != null) {
        try {
          final decoded = json.decode(cachedString);
          final List<dynamic> rawList =
              widget.isFirstData
                  ? (decoded as List<dynamic>)
                  : (decoded is Map && decoded['data'] is List)
                  ? decoded['data']
                  : decoded;

          final cachedItems =
              rawList.map<T>((e) => widget.parseItem(e)).toList();
          return cachedItems;
        } catch (e) {
          printWarning("فشل قراءة الكاش: $e");
        }
      }
    }
    throw Exception("لا يوجد بيانات مخزنة في الكاش");
  }

  Future<List<T>> _fetchData({bool isRefresh = false}) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response =
          widget.isParam
              ? await NetworkHelper.sendRequest(
                requestType: widget.requestType,
                endpoint: widget.endpoint,
                fields: widget.requestBody,
              )
              : await NetworkHelper.sendRequest(
                requestType: widget.requestType,
                endpoint: widget.endpoint,
                fields: widget.requestBody,
              );

      final data =
          widget.isFirstData
              ? response['data'] as List? ?? []
              : response['data']['data'] as List? ?? [];

      if (widget.cacheKey != null) {
        try {
          // خزّن النسخة النصية JSON للرد كاملًا (عادة response['data'] أو data)
          String cacheDataString;
          if (widget.isFirstData) {
            cacheDataString = json.encode(data);
          } else {
            cacheDataString = json.encode(response['data']);
          }
          await GetStorage().write(widget.cacheKey!, cacheDataString);
        } catch (e) {
          printWarning("فشل حفظ الكاش: $e");
        }
      }

      setState(() {
        items = data.map((item) => widget.parseItem(item)).toList();
        isLoading = false;
      });

      return items;
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      printWarning("حدث خطأ: $e");

      // حاول استرجاع البيانات من الكاش
      try {
        final cachedItems = await _loadCachedData();
        setState(() {
          items = cachedItems;
        });
        return items;
      } catch (cacheError) {
        printWarning("لم أتمكن من تحميل البيانات من الكاش: $cacheError");
      }

      if (e.toString().contains('No Internet Connection')) {
        throw const SocketException('No Internet Connection');
      } else if (e.toString().contains('Time Out Connection')) {
        throw const SocketException('Time Out Connection');
      }

      throw Exception('Error: $e');
    }
  }

  void update() {
    setState(() {
      _futureData = _fetchData(isRefresh: true);
    });
  }

  void updateWithNewUrl(String url) {
    widget.endpoint = url;
    setState(() {
      _futureData = _fetchData(isRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<T>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: TypingIndicator(color: primaryDarkColor));
          } else if (snapshot.hasError) {
            if (snapshot.error.toString().contains('No Internet Connection') ||
                snapshot.error.toString().contains("Time Out Connection") ||
                snapshot.error.toString().contains("Invalid response")) {
              // عند الخطأ حاول عرض البيانات المخزنة أو شاشة انترنت غير متوفر
              if (items.isNotEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _futureData = _fetchData(isRefresh: true);
                    });
                    await _futureData;
                  },
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder:
                        (context, index) =>
                            widget.itemBuilder(context, items[index]),
                  ),
                );
              } else {
                return NoInternetConnection(
                  onTryAgain: () {
                    setState(() {
                      _futureData = _fetchData(isRefresh: true);
                    });
                  },
                );
              }
            } else {
              return CrachScreen(
                onTryAgain: () {
                  setState(() {
                    _futureData = _fetchData(isRefresh: true);
                  });
                },
              );
            }
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            if (widget.emptyWidget != null) {
              return widget.emptyWidget!;
            } else {
              return Center(
                child: DefaultText(
                  'No Data Found'.tr(),
                  type: FontType.SemiBold,
                ),
              );
            }
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _futureData = _fetchData(isRefresh: true);
                });
                await _futureData;
              },
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return widget.itemBuilder(context, items[index]);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
