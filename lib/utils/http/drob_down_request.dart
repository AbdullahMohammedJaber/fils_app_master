// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/printer.dart';
import 'package:fils/utils/global_function/update_controller.dart';
import 'package:fils/utils/screen_catch/no_Internet_connection.dart';
import 'package:fils/utils/screen_catch/crach_screen.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/widget/defulat_text.dart';

import 'http_helper.dart';

class InfiniteScrollDropdown<T> extends StatefulWidget {
  String endpoint;
  final RequestType requestType;
  final T Function(dynamic json) parseItem;
  final Widget Function(BuildContext context, T item) itemBuilder;
  UpdateController? updateController;

  InfiniteScrollDropdown({
    super.key,
    required this.endpoint,
    this.updateController,
    required this.requestType,
    required this.parseItem,
    required this.itemBuilder,
  });

  @override
  _InfiniteScrollDropdownState<T> createState() =>
      _InfiniteScrollDropdownState<T>();
}

class _InfiniteScrollDropdownState<T> extends State<InfiniteScrollDropdown<T>> {
  late Future<List<T>> _futureData;
  List<T> items = [];
  T? selectedItem;

  @override
  void initState() {
    if (widget.updateController != null) {
      widget.updateController!.update = update;
      widget.updateController!.updateWithNewUrl = updateWithNewUrl;
    }
    super.initState();
    _futureData = _fetchData();
  }

  Future<List<T>> _fetchData() async {
    try {
      final response = await NetworkHelper.sendRequest(
        requestType: widget.requestType,
        endpoint: widget.endpoint,
      );

      if (response['code'] == 200 || response['status'] == 200) {
        final data = response['data'] as List? ?? [];
        setState(() {
          items = data.map((item) => widget.parseItem(item)).toList();
        });
        return items;
      } else {
        throw Exception('Unexpected Error: Invalid response');
      }
    } catch (e) {
      printWarning(e.toString());
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

  updateWithNewUrl(String url) {
    widget.endpoint = url;
    setState(() {
      _futureData = _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        } else if (snapshot.hasError) {
          if (snapshot.error.toString().contains('No Internet Connection') ||
              snapshot.error.toString().contains("Time Out Connection")) {
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
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButton<T>(
              value: selectedItem,
              hint: DefaultText(
                'Please select an item'.tr(),
                type: FontType.medium,
              ),
              isExpanded: true,
              items:
                  items.map((T item) {
                    return DropdownMenuItem<T>(
                      value: item,
                      child: widget.itemBuilder(context, item),
                    );
                  }).toList(),
              onChanged: (T? newValue) {
                setState(() {
                  selectedItem = newValue;
                });
                printGreen('Selected Item: $selectedItem');
              },
            ),
          );
        }
      },
    );
  }
}
