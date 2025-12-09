// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/printer.dart';
import 'package:fils/utils/global_function/update_controller.dart';
import 'package:fils/utils/screen_catch/no_Internet_connection.dart';
import 'package:fils/widget/defulat_text.dart';

import '../../screen/Seller/store/create_store/screen/add_store.dart';
import '../../screen/general/chat_boot.dart';
import '../enum/message_type.dart';
import '../message_app/show_flash_message.dart';
import '../theme/color_manager.dart';
import 'http_helper.dart';

class PaginationDialogCustom<T> extends StatefulWidget {
  final String endpoint;
  final RequestType requestType;
  final T Function(dynamic)? parseResponse;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final UpdateController? updateController;
  final String title;
  final Function(T?) callback;
  bool isFirstData;
  bool isShop;
  final String? cacheKey;
  final String Function(T)? itemSearchString;
  final bool isShowSelect;
  final bool isSelect;
  PaginationDialogCustom({
    super.key,
    required this.endpoint,
    this.isShowSelect = false,
    this.isSelect = false,

    this.updateController,
    this.isShop = false,
    this.isFirstData = true,
    required this.requestType,
    required this.parseResponse,
    required this.itemBuilder,
    required this.title,
    required this.callback,
    this.cacheKey,
    this.itemSearchString,
  });

  @override
  _PaginationDialogCustomState<T> createState() =>
      _PaginationDialogCustomState<T>();
}

class _PaginationDialogCustomState<T> extends State<PaginationDialogCustom<T>> {
  late Future<List<T>> _futureData;
  List<T> items = [];
  List<T> allItems = [];
  T? selectedItem;
  TextEditingController searchController = TextEditingController();

  dynamic currentPage = 1;
  bool hasNextPage = true;
  bool isLoading = false;
  bool isFromCache = false;

  @override
  void initState() {
    if (widget.updateController != null) {
      widget.updateController!.update = update;
    }
    super.initState();
    _futureData = _fetchData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        items = List.from(allItems);
      } else {
        items =
            allItems.where((item) {
              final name =
                  widget.itemSearchString?.call(item) ?? item.toString();
              return name.toLowerCase().contains(query.toLowerCase());
            }).toList();
      }
    });
  }

  Future<List<T>> _loadCachedData() async {
    if (widget.cacheKey != null) {
      final cachedString = GetStorage().read(widget.cacheKey!);
      if (cachedString != null) {
        try {
          final List<dynamic> decoded = json.decode(cachedString);
          final cachedItems =
              decoded.map<T>((e) => widget.parseResponse!(e)).toList();
          return cachedItems;
        } catch (e) {
          printWarning("فشل قراءة الكاش: $e");
        }
      }
    }
    throw Exception("لا يوجد بيانات مخزنة في الكاش");
  }

  Future<List<T>> _fetchData({bool isRefresh = false}) async {
    if (isLoading) return items;

    try {
      setState(() {
        isLoading = true;
        isFromCache = false;
      });

      final response = await NetworkHelper.sendRequest(
        requestType: widget.requestType,
        endpoint: "${widget.endpoint}?page=$currentPage",
      );

      if (response['status'] == 200 || response['code'] == 200) {
        final data =
            widget.isFirstData
                ? response['data'] as List? ?? []
                : response['data']['data'] as List? ?? [];
        final meta =
            widget.isFirstData
                ? response['meta'] ?? {}
                : response['data']['meta'] ?? {};

        if (widget.cacheKey != null && (currentPage == 1 || isRefresh)) {
          try {
            final cacheDataString = json.encode(data);
            await GetStorage().write(widget.cacheKey!, cacheDataString);
          } catch (e) {
            printWarning(
              "\u0641\u0634\u0644 \u062d\u0641\u0638 \u0627\u0644\u0643\u0627\u0634: \$e",
            );
          }
        }

        setState(() {
          final newItems =
              data.map((item) => widget.parseResponse!(item)).toList();
          if (isRefresh) {
            items = newItems;
          } else {
            items.addAll(newItems);
          }
          allItems = List.from(items);

          currentPage = meta['current_page'] ?? currentPage;
          hasNextPage = meta['current_page'] < meta['last_page'];
          isFromCache = false;
        });

        return items;
      } else {
        throw Exception('Unexpected Error: Invalid response');
      }
    } catch (e) {
      printWarning(e.toString());

      try {
        final cachedItems = await _loadCachedData();
        setState(() {
          items = cachedItems;
          allItems = cachedItems;
          isFromCache = true;
          hasNextPage = false;
        });
        return items;
      } catch (cacheError) {
        printWarning(
          "\u0644\u0645 \u0623\u062a\u0645\u0643\u0646 \u0645\u0646 \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0628\u064a\u0627\u0646\u0627\u062a \u0645\u0646 \u0627\u0644\u0643\u0627\u0634: \$cacheError",
        );
      }

      if (e.toString().contains('No Internet Connection')) {
        throw const SocketException('No Internet Connection');
      } else if (e.toString().contains('Time Out Connection')) {
        throw const SocketException('Time Out Connection');
      }
      throw Exception('Error: \$e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadNextPage() async {
    if (hasNextPage && !isLoading && !isFromCache) {
      currentPage++;
      await _fetchData();
    }
  }

  update() {
    setState(() {
      currentPage = 1;
      hasNextPage = true;
      isFromCache = false;
      _futureData = _fetchData(isRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Row(
        children: [
          DefaultText(
            widget.title.tr(),
            color: primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset(
              "assets/icons/close.svg",
              color: getTheme() ? white : Colors.black,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.6,
        child: FutureBuilder<List<T>>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: TypingIndicator(color: primaryDarkColor));
            } else if (snapshot.hasError) {
              return NoInternetConnection(onTryAgain: update);
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              if (widget.isShop) {
                return Column(
                  children: [
                    Spacer(),
                    Center(
                      child: DefaultText(
                        'No Data Found'.tr(),
                        type: FontType.bold,
                      ),
                    ),
                    Spacer(),
                    ButtonWidget(
                      colorButton: primaryColor,
                      title: "Add Shop".tr(),
                      onTap: () {
                        if (getPackageInfo().data != null) {
                          if (getPackageInfo().data!.branch == 1) {
                            ToRemove(context, AddStoreSeller(isComeSignup: false,));
                          } else {
                            showCustomFlash(
                              message:
                                  "You are not allowed to add a shop. Develop a subscription package."
                                      .tr(),
                              messageType: MessageType.Faild,
                            );
                          }
                        } else {
                          showCustomFlash(
                            message:
                                "You are not allowed to add a shop. Develop a subscription package."
                                    .tr(),
                            messageType: MessageType.Faild,
                          );
                        }
                      },
                    ),
                  ],
                );
              } else {
                return Center(
                  child: DefaultText('No Data Found'.tr(), type: FontType.bold),
                );
              }
            } else {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...'.tr(),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: filterItems,
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => _fetchData(isRefresh: true),
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollInfo) {
                          if (scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                            _loadNextPage();
                          }
                          return false;
                        },
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: widget.itemBuilder(context, items[index]),
                              onTap: () {
                                setState(() => selectedItem = items[index]);
                                widget.callback(selectedItem);

                                 Navigator.of(context).pop();
                              },

                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  if (widget.isShop) ...[
                    SizedBox(height: heigth * 0.05),
                    ButtonWidget(
                      colorButton: primaryColor,
                      title: "Add Shop".tr(),
                      onTap: () {
                        if (getPackageInfo().data == null) {
                          showCustomFlash(
                            message:
                                "You are not allowed to add a shop. Develop a subscription package."
                                    .tr(),
                            messageType: MessageType.Faild,
                          );
                        } else {
                          if (getPackageInfo().data!.branch == 1) {
                            ToRemove(context, AddStoreSeller(isComeSignup: false,));
                          } else {
                            showCustomFlash(
                              message:
                                  "You are not allowed to add a shop. Develop a subscription package."
                                      .tr(),
                              messageType: MessageType.Faild,
                            );
                          }
                        }
                      },
                    ),
                  ],
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
