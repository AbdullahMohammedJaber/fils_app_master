import 'package:easy_localization/easy_localization.dart';
import 'package:fils/model/response/base_response.dart';
import 'package:fils/utils/global_function/update_controller.dart';
import 'package:flutter/material.dart';
import 'package:fils/model/app/delivery_companies_model.dart';
import 'package:fils/model/response/cart_list_response.dart';
import 'package:fils/model/response/error_response.dart';
import 'package:fils/model/response/payment_methode_response.dart';
import 'package:fils/screen/Buyer/check_out/payment_methode.dart';
import 'package:fils/screen/Buyer/check_out/web_view_payment.dart';
import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import 'package:fils/utils/enum/changeCount.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/route/route.dart';


class CartNotifire with ChangeNotifier {
  // 1=> store cart
  // 2=> aucation cart
  dynamic pageTapBar = 1;

  changePageTapBar({dynamic index}) {
    pageTapBar = index!;
    notifyListeners();
  }

  // Delivery Methode
  // 1. reseve owner piece on store
  // 2. delivery coumpany
  dynamic deliveryMethode = 0;
  double sizeContainerReceveStore = 60;
  double sizeContainerDelivery = 60;

  selectDeliveryMethode({required dynamic typeMethodeDelivery}) {
    if (deliveryMethode == 1 && typeMethodeDelivery == 1) {
    } else if (deliveryMethode == 2 && typeMethodeDelivery == 2) {
    } else {
      deliveryMethode = typeMethodeDelivery;
      notifyListeners();
    }
  }

  // Controller For Delivery Where User Input

  PaymentMethodResponse? paymentMethodResponse;
  PaymentMethode? paymentMethode;

  functionGetPaymentMethode() async {
    /* NavigationService.navigatorKey.currentContext!
        .read<HomeNotifire>()
        .getCountCart();*/
    paymentMethode = null;
    showBoatToast();
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.get,
      endpoint: "payment-types?mode=order",
    );
    closeAllLoading();
    if (json.containsKey("errorMessage")) {
    } else {
      PaymentMethodResponse response = PaymentMethodResponse.fromJson(json);
      paymentMethodResponse = response;
      To(
        NavigationService.navigatorKey.currentContext!,
        PaymentMethodeScreen(
          deliveryCompaniesModel: DeliveryCompaniesModel(
            address: addressController.text,
            cityId: cityId,
            email: emailController.text,
            mobile: phoneController.text,
            name: nameController.text,
          ),
        ),
      );
    }
  }

  selectPaymentMethode(String type) {
    for (var element in paymentMethodResponse!.data) {
      element.isSelect = false;
    }
    for (var element in paymentMethodResponse!.data) {
      if (element.paymentTypeKey == type) {
        element.isSelect = true;
        paymentMethode = element;
      }
    }
    notifyListeners();
  }

  createOrder({required DeliveryCompaniesModel deliveryCompaniesModel}) async {
    showBoatToast();
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "order/store",
      fields: {
        "payment_type":
            paymentMethode!.paymentTypeKey.endsWith('s')
                ? paymentMethode!.paymentTypeKey.substring(
                  0,
                  paymentMethode!.paymentTypeKey.length - 1,
                )
                : paymentMethode!.paymentTypeKey,
        "name": deliveryCompaniesModel.name,
        "email": deliveryCompaniesModel.email,
        "address": deliveryCompaniesModel.address,
        "phone": deliveryCompaniesModel.mobile,
        "cityId": deliveryCompaniesModel.cityId,
      },
    );
    closeAllLoading();
    if (json.containsKey("errorMessage")) {
    } else {
      if (json['result'] == false) {
        showCustomFlash(
          message: json['message'],
          messageType: MessageType.Faild,
        );
      } else {

        onlinePayment(json['combined_order_id']);
      }
    }
  }

  onlinePayment(dynamic idOrder) async {
    showBoatToast();
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.get,
      endpoint: "online-pay/init",
      fields: {
        "payment_option":
            paymentMethode!.paymentTypeKey.endsWith('s')
                ? paymentMethode!.paymentTypeKey.substring(
                  0,
                  paymentMethode!.paymentTypeKey.length - 1,
                )
                : paymentMethode!.paymentTypeKey,
        "combined_order_id": idOrder,
      },
    );
    closeAllLoading();
    if (json.containsKey("errorMessage")) {
    } else {
      ToRemove(
        NavigationService.navigatorKey.currentContext!,
        PaymentWebView(urlPayment: json['link']),
      );
      /* NavigationService.navigatorKey.currentContext!
          .read<HomeNotifire>()
          .getCountCart();*/
    }
  }

  // Data Cart For Update Delete Show

  CartListResponse? cartListResponse;
  UpdateController cartUpdateController = UpdateController();

  changeCartListWhereRequest(CartListResponse data) {
    cartListResponse = data;

    changeTax();
  }

  clearAllItemInCart() {
    cartListResponse!.data.clear();
    notifyListeners();
  }

  deleteItemInCart({required dynamic idItem}) {
    for (dynamic i = 0; i < cartListResponse!.data.length; i++) {
      for (var action in cartListResponse!.data[i].cartItems) {
        if (action.id == idItem) {
          cartListResponse!.data[i].cartItems.remove(action);
          notifyListeners();
          break;
        }
      }
    }
    if (cartListResponse!.data.length == 1) {
      if (cartListResponse!.data[0].cartItems.isEmpty) {
        cartListResponse!.data.clear();
        notifyListeners();
      }
    }
    cartUpdateController.update();
  }

  deleteCartRequest({required dynamic idItem}) async {
    showBoatToast();
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.delete,
      endpoint: "carts/$idItem",
    );
    closeAllLoading();
    if (json.containsKey("errorMessage")) {
      ErrorResponse errorResponse = ErrorResponse.fromJson(json);
      showCustomFlash(
        message: errorResponse.errorMessage,
        messageType: MessageType.Faild,
      );
    } else {
      showCustomFlash(
        message: "Product is successfully removed from your cart".tr(),
        messageType: MessageType.Success,
      );
      /* NavigationService.navigatorKey.currentContext!
          .read<HomeNotifire>()
          .getCountCart();*/
      deleteItemInCart(idItem: idItem);
    }
  }

  processCart({
    required dynamic idItem,
    required dynamic quantity,
    required ChangeCountType type,
  }) async {
    showBoatToast();
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "carts/process",
      fields: {"cart_ids": "$idItem", "cart_quantities": "$quantity"},
    );
    closeAllLoading();
    BaseResponse baseResponse = BaseResponse.fromJson(json);
    if (baseResponse.result!) {
      cartUpdateController.update();
    } else {
      showCustomFlash(
        message: baseResponse.message,
        messageType: MessageType.Faild,
      );
    }
  }

  double tax = 0;

  changeTax() {
    tax = 0;
    if (cartListResponse!.data.isNotEmpty) {
      for (dynamic i = 0; i < cartListResponse!.data.length; i++) {
        for (var action in cartListResponse!.data[i].cartItems) {
          tax += double.parse(action.tax);
        }
      }
    }
  }

  // delevary
  final key = GlobalKey<FormState>();
  TextEditingController addressController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  int? cityId;

  ////////// dispose
  @override
  void dispose() {
    addressController.dispose();

    super.dispose();
  }
}
