// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/update_controller.dart';
import 'package:fils/utils/screen_catch/no_Internet_connection.dart';
import 'package:fils/utils/screen_catch/crach_screen.dart';
import 'package:fils/widget/defulat_text.dart';

import '../../screen/general/chat_boot.dart';
import '../theme/color_manager.dart';
import 'http_helper.dart';

class InfiniteScrollGridView<T> extends StatefulWidget {
  String endpoint;
  final RequestType requestType;
  final T Function(dynamic json) parseItem;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final SliverGridDelegate sliverGridDelegate;
  final bool isDataFirstList;
  UpdateController? updateController;
  final bool isParameter;
  final Map<String, dynamic>? data;
  final Widget? emptyWidget;
  Widget? customLoading;
  bool shwrinkWrap;
  final String? cacheKey;

  InfiniteScrollGridView({
    super.key,
    required this.endpoint,
    this.data,
    this.customLoading,
    this.shwrinkWrap = false,
    this.isParameter = false,
    this.updateController,
    required this.isDataFirstList,
    required this.requestType,
    required this.sliverGridDelegate,
    required this.parseItem,
    required this.itemBuilder,
    this.emptyWidget,
    this.cacheKey,
  });

  @override
  _InfiniteScrollGridViewState<T> createState() =>
      _InfiniteScrollGridViewState<T>();
}

class _InfiniteScrollGridViewState<T> extends State<InfiniteScrollGridView<T>> {
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

    if (!widget.shwrinkWrap) {
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
      final endpointWithPage =
          widget.isParameter
              ? "${widget.endpoint}&page=$currentPage"
              : "${widget.endpoint}?page=$currentPage";

      final response = await NetworkHelper.sendRequest(
        requestType: widget.requestType,
        fields: widget.data,
        endpoint: endpointWithPage,
      );

      if (widget.cacheKey != null && currentPage == 1) {
        await GetStorage().write(widget.cacheKey!, jsonEncode(response));
      }

      List<dynamic> data;
      Map<String, dynamic> meta;

      if (widget.isDataFirstList) {
        data = response['data'] as List? ?? [];
        meta = response['meta'] ?? {};
      } else {
        data = response['data']?['data'] as List? ?? [];
        meta = response['data']?['meta'] ?? {};
      }

      setState(() {
        items.addAll(data.map((item) => widget.parseItem(item)).toList());
        currentPage++;
        hasMore = meta['current_page'] < meta['last_page'];
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
        final List<dynamic> data =
            widget.isDataFirstList
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
    final listPhysics =
        widget.shwrinkWrap
            ? const NeverScrollableScrollPhysics()
            : BouncingScrollPhysics();

    return FutureBuilder<List<T>>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          if (widget.customLoading != null) {
            return widget.customLoading!;
          } else {
            return Center(child: TypingIndicator(color: primaryDarkColor));
          }
        } else if (snapshot.hasError) {
          if (snapshot.error.toString().contains('No Internet Connection') ||
              snapshot.error.toString().contains("Time Out Connection") ||
              snapshot.error.toString().contains("Invalid response")) {
            return NoInternetConnection(
              onTryAgain: () {
                setState(() {
                  _futureData = _fetchData(isRefresh: true);
                });
              },
            );
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
              child: DefaultText('No Data Found'.tr(), type: FontType.bold),
            );
          }
        } else {
          if (widget.shwrinkWrap && hasMore && !isLoading && !isFromCache) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // double-check mounted because callback might run after dispose
              if (mounted && hasMore && !isLoading && !isFromCache) {
                _fetchData();
              }
            });
          }
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _futureData = _fetchData(isRefresh: true);
              });
              await _futureData;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                controller: _scrollController,
                shrinkWrap: widget.shwrinkWrap,
                gridDelegate: widget.sliverGridDelegate,
                itemCount: items.length + 1,
                itemBuilder: (context, index) {
                  if (index < items.length) {
                    return widget.itemBuilder(context, items[index]);
                  } else if (hasMore && !isFromCache) {
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
                },
              ),
            ),
          );
        }
      },
    );
  }
}
