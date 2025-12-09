import 'package:flutter/material.dart';

import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/screen/Buyer/check_out/bottom_sheet_payment.dart';
import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/http/http_helper.dart';

import 'package:fils/utils/theme/color_manager.dart';
import 'package:provider/provider.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../../../utils/global_function/loading_widget.dart';
import '../../../utils/global_function/printer.dart';
import '../../../utils/route/route.dart';
import '../../general/root_app.dart';

class PaymentWebViewWallet extends StatefulWidget {
  final String urlPayment;

  const PaymentWebViewWallet({super.key, required this.urlPayment});

  @override
  State<PaymentWebViewWallet> createState() => _PaymentWebViewWalletState();
}

class _PaymentWebViewWalletState extends State<PaymentWebViewWallet> {
  late WebViewController controller;

  @override
  void initState() {
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (url) async {
                printBlueLong("===========>>> onPageStarted  $url");
                if (isTest) {
                  if (url.contains('https://stage.fils.app/api')) {
                    String baseUrl = "https://stage.fils.app/api/v1/";
                    String remainingUrl = url.replaceFirst(baseUrl, "");

                    if (mounted) Navigator.pop(context);

                    changeDomain1();
                    showBoatToast();

                    var json = await NetworkHelper.sendRequest(
                      requestType: RequestType.get,
                      endpoint: remainingUrl,
                    );

                    changeDomain2();
                    closeAllLoading();
                    if (mounted) Navigator.pop(context);
                    bool success =
                        json['result'] == true ||
                            json['result'] == 200 ||
                            json['success'] == true ||
                            json['success'] == 200;

                    showModalBottomSheet(
                      context: NavigationService.navigatorKey.currentContext!,
                      elevation: 1,
                      isDismissible: true,
                      isScrollControlled: true,
                      backgroundColor: white,
                      constraints: BoxConstraints(maxHeight: heigth * 0.6),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      builder: (context) {
                        toRemoveAll(context, const RootAppScreen());
                        return success ? const donePay() : const faieldPay();
                      },
                    );
                  }
                } else
                {
                  if (url.contains('https://dashboard.fils.app/api')) {
                    String baseUrl = "https://dashboard.fils.app/api/v1/";
                    String remainingUrl = url.replaceFirst(baseUrl, "");



                    changeDomain1();
                    showBoatToast();

                    var json = await NetworkHelper.sendRequest(
                      requestType: RequestType.get,
                      endpoint: remainingUrl,
                    );

                    changeDomain2();
                    closeAllLoading();

                    bool success =
                        json['result'] == true ||
                            json['result'] == 200 ||
                            json['success'] == true ||
                            json['success'] == 200;
                    if (mounted) Navigator.pop(context);
                    showModalBottomSheet(
                      context: NavigationService.navigatorKey.currentContext!,
                      elevation: 1,
                      isDismissible: true,
                      isScrollControlled: true,
                      backgroundColor: white,
                      constraints: BoxConstraints(maxHeight: heigth * 0.6),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      builder: (context) {
                        return success ? const donePay() : const faieldPay();
                      },
                    );
                  }
                }
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.urlPayment));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
