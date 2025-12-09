// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/model/response/base_response.dart';
import 'package:fils/screen/Buyer/wallet/payment_webview_forwallet.dart';

import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/store_notofire.dart';
import 'package:fils/model/app/wallet_model.dart';
import 'package:fils/model/response/paymant_response.dart';
import 'package:fils/screen/Seller/wallet/withdrow_screen.dart';
import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/route/route.dart';
import 'package:provider/provider.dart';

import '../../screen/Seller/wallet/message_after_payment.dart';

class WalletNotifire with ChangeNotifier {
  Data? paymentMethode;

  selectPaymentMethode(PaymentResponse paymentMethodResponse, String type) {
    for (var element in paymentMethodResponse.data!) {
      element.isSelect = false;
    }
    for (var element in paymentMethodResponse.data!) {
      if (element.paymentType == type) {
        element.isSelect = true;
        paymentMethode = element;
      }
    }
    notifyListeners();
  }

  addBalanceRequest(BuildContext context, dynamic balance) async {
    showBoatToast();
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "wallet/charge",
      fields: {
        "amount": balance,
        "payment_provider": paymentMethode!.paymentType,
      },
    );
    closeAllLoading();
    if (json.containsKey("errorMessage")) {
    } else {
      ToRemove(context, PaymentWebViewWallet(urlPayment: json['link']));
    }
  }

  //////// SELLER ////////////////////

  List<WalletModel> walletList = [
    WalletModel(id: 1, price: "50"),
    WalletModel(id: 2, price: "100"),
    WalletModel(id: 3, price: "500"),
    WalletModel(id: 4, price: "Max Balance".tr()),
  ];

  TextEditingController priceController = TextEditingController();

  changeSelectValueWallet(WalletModel wallet) {
    for (var element in walletList) {
      element.isSelect = false;
    }
    for (var element in walletList) {
      if (element.id == wallet.id) {
        element.isSelect = true;
        if (element.id == 4) {
          showDialog(
            context: NavigationService.navigatorKey.currentContext!,
            builder: (BuildContext context) {
              return const PriceInputDialog();
            },
          );
        } else {
          priceController.text = element.price!;
        }
      }
    }
    notifyListeners();
  }

  changePrice() {
    notifyListeners();
  }

  bool stepOne = true;
  bool stepTow = false;

  changeStepTow(bool value) {
    if (value == true) {
      stepOne = false;
    } else {
      stepOne = true;
    }
    stepTow = value;
    notifyListeners();
  }

  withdrawalFunction(BuildContext context) async {
    showBoatToast();
    final json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "withdraw-request/store",
      fields: {
        "amount": priceController.text,
        "message": getUser()!.user!.name,
      },
    );
    closeAllLoading();
    if (json.containsKey("errorMessage")) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return const ErrorWithdrawal();
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return const DoneWithdrawal();
        },
      );
    }
  }

  ///////////////////////////////////////////////////
  TextEditingController bankName = TextEditingController();
  TextEditingController ownerName = TextEditingController();
  TextEditingController bankNo = TextEditingController();
  TextEditingController bankIban = TextEditingController();

  setupBankAccount(BuildContext context) async {
    showBoatToast();
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "bank-setup/${getAllShop().id}",
      fields: {
        "bank_name": bankName.text,
        "bank_acc_name": ownerName.text,
        "bank_acc_no": bankNo.text,
        "bank_routing_no": bankIban.text,
      },
    );
    if (json.containsKey("errorMessage")) {
      showCustomFlash(
        message: json['errorMessage'],
        messageType: MessageType.Faild,
      );
    } else {
      BaseResponse res = BaseResponse.fromJson(json);
      showCustomFlash(message: res.message, messageType: MessageType.Success);
      Provider.of<StoreNotifire>(
        NavigationService.navigatorKey.currentContext!,
        listen: false,
      ).functionGetDataStore(isGetComplete: false);
      showModalBottomSheet(
        context: context,
        builder: (context) => const DoneSetupBanck(),
      );
    }
    closeAllLoading();
  }
}
