import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fils/utils/global_function/timer_format.dart';

class FilterSearchNotifier with ChangeNotifier {
  // 1. section store filter
  // 2. section auctions filter
  dynamic typeSection = 1;

  changeTypeSection(dynamic section) {
    if (section == typeSection) {
      log("message");
    } else {
      typeSection = section;
      notifyListeners();
    }
  }

  // 1. section Expired filter
  // 2. section Valid filter
  dynamic typeValidity = 1;

  changeTypeValidity(dynamic section) {
    if (section == typeValidity) {
      log("message");
    } else {
      typeValidity = section;
      notifyListeners();
    }
  }

  dynamic typeAuction = 1;

  changeTypeAuction(dynamic section) {
    if (section == typeAuction) {
      log("message");
    } else {
      typeAuction = section;
      notifyListeners();
    }

  }

  // Date & Time Filter
  DateTime? dataFilter;
  TimeOfDay? timeFilter;

  changeDateFilter(DateTime dateTime) {
    dataFilter = dateTime;
    notifyListeners();
  }

  changeTimeFilter(TimeOfDay dateTime) {
    timeFilter = dateTime;
    notifyListeners();
  }

  // Range Price
  RangeValues currentRangeValues = const RangeValues(1, 1000);

  changeRangePrice(price) {
    currentRangeValues = price;
    notifyListeners();
  }

  // Rate Function
  dynamic countRate;

  List<Map<String, dynamic>> rateList = [
    {"id": 1, "select": false},
    {"id": 2, "select": false},
    {"id": 3, "select": false},
    {"id": 4, "select": false},
    {"id": 5, "select": false},
  ];

  functionOnClickStar(dynamic id) {
    if (id >= 1) {
      for (dynamic index = 0; index < id; index++) {
        rateList[index]['select'] = true;
      }
      for (dynamic index = id; index < rateList.length; index++) {
        rateList[index]['select'] = false;
      }
    }
    countRate = rateList.lastIndexWhere((element) => element['select']) + 1;

    notifyListeners();
  }

  // Section Category
  String? categoryName;

  dynamic categoryId;

  changeCategory({required String name, required dynamic id}) {
    categoryName = name;
    categoryId = id;
    notifyListeners();
  }

  // Section Store

  String? storeName;

  dynamic storeId;

  changeStore({required String name, required dynamic id}) {
    storeName = name;
    storeId = id;
    notifyListeners();
  }

  Map<String, dynamic> filterStore(String search) {
    return {
      "name": search,
      "is_auction": typeSection == 1 ? "0" : "1",
      if(categoryId!=null)
      "categories": categoryId,
      "min": currentRangeValues.start,
      "max": currentRangeValues.end,
      if(storeId!=null)
      "shop_id": storeId,
      "rating": countRate,
    };
  }

  Map<String, dynamic> filterAuction(String search) {
    return {
      if (search.isNotEmpty) "name": search,
      "is_auction": typeSection == 2 ? "1" : "0",
      "rating": countRate,
      if (dataFilter != null && timeFilter != null)
        "auction_end_date": mergeDateTime(dataFilter, timeFilter),
      "action_type": typeAuction == 1 ? "live" : "normal",
    };
  }

  // Clear Data where start filter
  clearData() {
    storeName = null;
    storeId = null;
    categoryName = null;
    categoryId = null;
    countRate = null;
    rateList = [
      {"id": 1, "select": false},
      {"id": 2, "select": false},
      {"id": 3, "select": false},
      {"id": 4, "select": false},
      {"id": 5, "select": false},
    ];
    currentRangeValues = const RangeValues(1, 1000);
    typeValidity = 1;
    typeSection = 1;
    dataFilter = null;
    timeFilter = null;
  }
}
