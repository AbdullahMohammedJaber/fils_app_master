// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/utils/const.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/printer.dart';
import 'package:fils/utils/global_function/update_controller.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/screen_catch/no_Internet_connection.dart';
import 'package:fils/utils/screen_catch/crach_screen.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/defulat_text.dart';

import '../../screen/general/chat_boot.dart';
import '../theme/color_manager.dart';

class MultiSelectScrollDialog<T> extends StatefulWidget {
  final String endpoint;
  final RequestType requestType;
  final T Function(dynamic)? parseResponse;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final UpdateController? updateController;
  final String title;
  final Function(List<T>) callback;
  final String? cacheKey;

  /// دالة تستخدم لاستخراج قيمة النص التي يُبحث عنها في كل عنصر
  final String Function(T)? itemSearchString;

  const MultiSelectScrollDialog({
    super.key,
    required this.endpoint,
    this.updateController,
    required this.requestType,
    required this.parseResponse,
    required this.itemBuilder,
    required this.title,
    required this.callback,
    this.cacheKey,
    this.itemSearchString,
  });

  @override
  _MultiSelectScrollDialogState<T> createState() =>
      _MultiSelectScrollDialogState<T>();
}

class _MultiSelectScrollDialogState<T>
    extends State<MultiSelectScrollDialog<T>> {
  late Future<List<T>> _futureData;
  List<T> items = [];
  List<T> allItems = [];
  List<T> selectedItems = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    changeDomain1();
    if (widget.updateController != null) {
      widget.updateController!.update = update;
    }
    super.initState();
    _futureData = _fetchData();
  }

  @override
  void dispose() {
    searchController.dispose();
    changeDomain2();
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

  Future<List<T>> _fetchData() async {
    items = [];
    selectedItems = [];
    try {
      final response = await NetworkHelper.sendRequest(
        requestType: widget.requestType,
        endpoint: widget.endpoint,
      );
      printBlue("response : ${response.toString()}");

      if (response['code'] == 200 || response['status'] == 200) {
        final data = response['data'] as List;

        if (widget.cacheKey != null) {
          try {
            final cacheDataString = json.encode(data);
            await GetStorage().write(widget.cacheKey!, cacheDataString);
          } catch (e) {
            printWarning("فشل حفظ الكاش: $e");
          }
        }

        setState(() {
          allItems = data.map((item) => widget.parseResponse!(item)).toList();
          items = List.from(allItems);
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
          allItems = cachedItems;
          items = List.from(allItems);
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

  update() {
    setState(() {
      _futureData = _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            DefaultText(
              widget.title.tr(),
              color: primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                if (isLogin()) {
                  if (getUser()!.user!.type == "customer") {
                    changeDomain1();
                  } else {
                    changeDomain2();
                  }
                }
                Navigator.pop(context);
              },
              child: SizedBox(
                height: 40,
                width: 40,
                child: Center(
                  child: SvgPicture.asset(
                    "assets/icons/close.svg",
                    color: getTheme() ? white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      content: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.5,
        child: FutureBuilder<List<T>>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: TypingIndicator(color: primaryDarkColor));
            } else if (snapshot.hasError) {
              if (snapshot.error.toString().contains(
                    'No Internet Connection',
                  ) ||
                  snapshot.error.toString().contains("Time Out Connection") ||
                  snapshot.error.toString().contains(
                    "Unexpected Error: Invalid response",
                  )) {
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
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: DefaultText('No Data Found'.tr(), type: FontType.bold),
              );
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
                      onRefresh: () async {
                        _futureData = _fetchData();
                        setState(() {});
                      },
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final isSelected = selectedItems.contains(item);
                          return Row(
                            children: [
                              widget.itemBuilder(context, item),
                              const Spacer(),
                              Checkbox(
                                value: isSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedItems.add(item);
                                    } else {
                                      selectedItems.remove(item);
                                    }
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ButtonWidget(
                      onTap: () {
                        if (isLogin()) {
                          if (getUser()!.user!.type == "customer") {
                            changeDomain1();
                          } else {
                            changeDomain2();
                          }
                        }
                        widget.callback(selectedItems);
                        Navigator.of(context).pop();
                      },
                      title: "Done".tr(),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
