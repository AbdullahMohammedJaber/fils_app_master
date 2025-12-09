// ignore_for_file: prefer_final_fields, must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/printer.dart';
import 'package:fils/utils/global_function/update_controller.dart';
import 'package:fils/utils/screen_catch/no_Internet_connection.dart';

import 'package:fils/widget/defulat_text.dart';
import 'package:get_storage/get_storage.dart';

import '../../screen/general/chat_boot.dart';
import '../theme/color_manager.dart';
import 'http_helper.dart';

class PaginatedListWidget<T> extends StatefulWidget {
  String endpoint;
  final RequestType requestType;
  final T Function(dynamic json) parseItem;
  final Widget Function(BuildContext context, T item) itemBuilder;
  UpdateController? updateController;
  final bool isParam;
  final bool isFirstData;
  final Widget? emptyWidget;
  final Map<String, dynamic>? requestBody;
  final Axis axis;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final String? cacheKey;

  PaginatedListWidget({
    super.key,
    required this.endpoint,
    this.isParam = false,
    this.physics,
    this.shrinkWrap = false,
    this.axis = Axis.vertical,
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
  State<PaginatedListWidget<T>> createState() => _PaginatedListWidgetState<T>();
}

// (فقط الكلاس المُحدّث — استبدِل كلاس _PaginatedListWidgetState الموجود عندك بهذه النسخة)

class _PaginatedListWidgetState<T> extends State<PaginatedListWidget<T>> {
  late Future<List<T>> _futureData;
  List<T> items = [];
  int currentPage = 1;
  bool hasMore = true;
  bool isLoading = false;
  bool isFromCache = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    if (widget.updateController != null) {
      widget.updateController!.update = update;
      widget.updateController!.updateWithNewUrl = updateWithNewUrl;
    }

    super.initState();
    _futureData = _fetchData();

    // only add listener when this ListView will handle its own scrolling
    if (!widget.shrinkWrap) {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
            hasMore &&
            !isLoading &&
            !isFromCache) {
          _fetchData();
        }
      });
    }
  }

  Future<List<T>> _fetchData({bool isRefresh = false}) async {
    if (isLoading) return items;

    if (isRefresh) {
      currentPage = 1;
      items.clear();
      hasMore = true;
      isFromCache = false;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final endpointWithPage = widget.isParam
          ? "${widget.endpoint}&page=$currentPage"
          : "${widget.endpoint}?page=$currentPage";

      final response = await NetworkHelper.sendRequest(
        requestType: widget.requestType,
        fields: widget.requestBody,
        endpoint: endpointWithPage,
      );

      if (widget.cacheKey != null && currentPage == 1) {
        await GetStorage().write(widget.cacheKey!, jsonEncode(response));
      }

      List<dynamic> data;
      Map<String, dynamic> meta;

      if (widget.isFirstData) {
        data = response['data'] as List? ?? [];
        meta = response['meta'] ?? {};
      } else {
        data = response['data']?['data'] as List? ?? [];
        meta = response['data']?['meta'] ?? {};
      }

      setState(() {
        items.addAll(data.map((item) => widget.parseItem(item)).toList());
        currentPage++;
        // guard in case meta fields are missing or not int
        final current = (meta['current_page'] is int) ? meta['current_page'] as int : currentPage - 1;
        final last = (meta['last_page'] is int) ? meta['last_page'] as int : current;
        hasMore = current < last;
        isLoading = false;
        isFromCache = false;
      });

      return items;
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log("Error fetching data: $e");

      try {
        final cachedData = await _loadCachedData();
        setState(() {
          items = cachedData;
          hasMore = false;
          isFromCache = true;
        });
        return items;
      } catch (_) {
        if (e.toString().contains('No Internet Connection') ||
            e.toString().contains('Time Out Connection')) {
          throw const SocketException('No Internet Connection');
        }
        throw Exception('Error: $e');
      }
    }
  }

  Future<List<T>> _loadCachedData() async {
    if (widget.cacheKey != null) {
      final cached = GetStorage().read(widget.cacheKey!);
      if (cached != null) {
        final jsonMap = json.decode(cached);
        final List<dynamic> data = widget.isFirstData
            ? jsonMap['data'] as List? ?? []
            : jsonMap['data']?['data'] as List? ?? [];

        return data.map<T>((e) => widget.parseItem(e)).toList();
      }
    }
    throw Exception('No cached data available');
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // when shrinkWrap is true we should not let inner ListView scroll independently
    final listPhysics = widget.shrinkWrap ? const NeverScrollableScrollPhysics() : widget.physics;

    return FutureBuilder<List<T>>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && items.isEmpty) {
          // show initial loading only when there are no items yet
          return Center(child: TypingIndicator(color: primaryDarkColor));
        } else if (snapshot.hasError && items.isEmpty) {
          // show error only when no cached/loaded items exist
          return NoInternetConnection(
            onTryAgain: () => setState(() => _futureData = _fetchData(isRefresh: true)),
          );
        } else if (items.isEmpty) {
          // no data after attempts
          return widget.emptyWidget ??
              Center(
                child: DefaultText('No Data Found'.tr(), type: FontType.SemiBold),
              );
        } else {
          // if this widget is shrinkWrapped and there are more pages, schedule loading next page
          if (widget.shrinkWrap && hasMore && !isLoading && !isFromCache) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // double-check mounted because callback might run after dispose
              if (mounted && hasMore && !isLoading && !isFromCache) {
                _fetchData();
              }
            });
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() => _futureData = _fetchData(isRefresh: true));
              await _futureData;
            },
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: widget.shrinkWrap,
              scrollDirection: widget.axis,
              physics: listPhysics,
              itemCount: items.length + 1,
              itemBuilder: (context, index) {
                if (index < items.length) {
                  return widget.itemBuilder(context, items[index]);
                } else {
                  if (hasMore && !isFromCache) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Center(
                        child: DefaultText(
                          'All results are shown'.tr(),
                          type: FontType.SemiBold,
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          );
        }
      },
    );
  }
}
