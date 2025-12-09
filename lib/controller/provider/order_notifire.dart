import 'package:fils/model/response/seller/order_seller.dart';
import 'package:fils/utils/global_function/update_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:fils/model/response/order_response.dart';
import 'package:fils/screen/Buyer/order/order_screen.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';

class OrderNotifier with ChangeNotifier {
  // 1=> current order
  // 2=> complete order
  // 3=> cancel order

  dynamic pageTapBar = 1;

  String url = "purchase-history?delivery_status=pending&payment_status=paid";

  changePageTapBar({dynamic index}) {
    if (pageTapBar == index) {
    } else {
      pageTapBar = index!;
    }
    notifyListeners();
  }

  changeUrl(String newUrl) {
    url = newUrl;
    if (kDebugMode) {
      print(url);
    }
    notifyListeners();
    orderController.updateWithNewUrl(url);
  }

  dynamic idOrderForCancel;

  changeIdCancelOrder({required dynamic idOrder}) {
    idOrderForCancel = idOrder;
    notifyListeners();
  }

  UpdateController cancelUpdate = UpdateController();

  cancelOrderRequest({required String message}) async {
    showBoatToast();
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "order/cancel/$idOrderForCancel",
      fields: {"reason_for_cancellation": message},
    );
    closeAllLoading();
    if (json.containsKey('errorMessage')) {
      showCustomFlash(
        message: json['errorMessage'],
        messageType: MessageType.Faild,
      );
    } else {
      showCustomFlash(
        message: json['message'],
        messageType: MessageType.Success,
      );
      cancelUpdate.update();
    }
  }

  changeShowDetailsOrder(Orders orders) {
    orders.isShow = !orders.isShow;

    notifyListeners();
  }

  changeShowDetailsOrderSeller(OrderSeeler orders) {
    orders.isShow = !orders.isShow;

    notifyListeners();
  }
}
