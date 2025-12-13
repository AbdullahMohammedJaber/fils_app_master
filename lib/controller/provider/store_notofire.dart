// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/controller/provider/home_notifire.dart';
import 'package:fils/model/response/base_response.dart';
import 'package:fils/screen/Seller/home/home_seller.dart';
import 'package:fils/screen/Seller/store/edit_store/screen/edit_store_information.dart';
import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/route/route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fils/model/app/size_model.dart';
import 'package:fils/model/response/details_product_response.dart';
import 'package:fils/model/response/error_response.dart';
import 'package:fils/model/response/shop_info_response.dart';
import 'package:fils/utils/enum/changeCount.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/http/service.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:provider/provider.dart';

class StoreNotifire with ChangeNotifier {
  bool visible = false;

  StoreNotifire() {
    runAnimation();
  }

  runAnimation() {
    Future.delayed(const Duration(milliseconds: 100), () {
      visible = true;
      notifyListeners();
    });
  }

  // SIZE PRODUCT
  List<SizeModel> listSizeProduct = [];
  dynamic idSizeSelect;
  String? nameSizeSelect;

  changeListSize(List<StocksDatum> data) {
    listSizeProduct = [];
    for (var action in data) {
      listSizeProduct.add(
        SizeModel(
          id: action.id,
          name: action.variant,
          select: false,
          price: action.price,
          qtu: action.qty,
        ),
      );
    }
  }

  dynamic totalPrice = 0;

  void changePrice(price) {
    totalPrice = price;
    notifyListeners();
  }

  int qtuWSize = 1;
  selectItemSize(SizeModel sizeModelItem) {
    sizeModelItem.cleanAllSelect(list: listSizeProduct);
    countItemForOrder = 1;
    for (var element in listSizeProduct) {
      if (element.id == sizeModelItem.id) {
        element.select = true;
        idSizeSelect = element.id!;
        nameSizeSelect = element.name!;
        qtuWSize = element.qtu;
        changePrice(element.price);
      }
    }
    notifyListeners();
  }

  // COUNT ITEM ORDER
  dynamic countItemForOrder = 1;

  changeCountItemForOrder({
    required ChangeCountType changeCountType,
    required dynamic max,
  }) {
    if (changeCountType == ChangeCountType.PLUS) {

        countItemForOrder++;

    } else {
      if (countItemForOrder > 1) {
        countItemForOrder--;
      }
    }
    notifyListeners();
  }

  functionAddCart({
    required dynamic id,
    bool isAuction = false,
  }) async {
    showBoatToast();
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "$addCart?is_auction=0",
      fields: {
        "id":  id,
        if (nameSizeSelect != null) "variant": nameSizeSelect,
        "quantity": countItemForOrder,
      },
    );
    closeAllLoading();

    if (json.containsKey("errorMessage")) {
      ErrorResponse errorResponse = ErrorResponse.fromJson(json);
      showCustomFlash(
        message: errorResponse.errorMessage,
        messageType: MessageType.Faild,
      );
    } else {
      BaseResponse base = BaseResponse.fromJson(json);
      if (base.result!) {
        showCustomFlash(
          message: "The Product add cart successfully".tr(),
          messageType: MessageType.Success,
        );
       /* NavigationService.navigatorKey.currentContext!
            .read<HomeNotifire>()
            .getCountCart();*/
      } else {
        showCustomFlash(message: base.message, messageType: MessageType.Faild);
      }
      NavigationService.navigatorKey.currentContext!.read<AppNotifire>(). onClickBottomNavigationBar(2);

      Navigator.pop(NavigationService.navigatorKey.currentContext!);
    }
  }

  // Function Get Data Store
  functionGetDataStore({required bool isGetComplete }) async {
    if (getAllShop().id != null) {
      final json = await NetworkHelper.sendRequest(
        requestType: RequestType.get,
        endpoint: "shop/info/${getAllShop().id}",
      );
      print("json shop/info/ ======== >${json.toString()} ");

      if (json.containsKey("errorMessage")) {} else {

        ShopInfoResponse shopInfoResponse = ShopInfoResponse.fromJson(json);
        setShopInfo(shopInfoResponse);
        if(isGetComplete){

          if (getShopInfo().data!.description.toString() == "null" ||
              getShopInfo().data!.description == null
              ) {
            // TODO translate
            showCustomFlash(message: "Please complete data store".tr(), messageType: MessageType.Faild);

            ToWithFade(NavigationService.navigatorKey.currentContext!,
                EditStoreInformation());


          }
        }

      }
    }

    // Function Check Complete Data Store
    /* functionCheckStoreComplete() async {
    final json = await NetworkHelper.sendRequest(
      requestType: RequestType.get,
      endpoint: "shop/profile-completion/${getAllShop().id}",
    );
    print("json shop/profile-completion ======== >${json.toString()} ");
    if (json.containsKey("errorMessage")) {
    } else {
      dynamic value = int.parse(json['data']['verification_status'].toString());
      bool finalValue = value == 1 ? true : false;
      setCheckCompleteShop(finalValue);
      if (finalValue == false) {
        if (getShopInfo()!.data!.logo == null) {
          ToWithFade(
            NavigationService.navigatorKey.currentContext!,
            EditStoreInformation(),
          );
        } else {
          showDialogActiveShop();
        }
      }
    }
  }*/
  }
  @override
  void dispose() {
    visible = false;

    super.dispose();
  }
}
