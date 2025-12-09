import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentFeeWebView extends StatefulWidget {
  final String urlPayment;
  final dynamic idAuction;

  const PaymentFeeWebView({
    super.key,
    required this.urlPayment,
    required this.idAuction,
  });

  @override
  State<PaymentFeeWebView> createState() => _PaymentFeeWebViewState();
}

class _PaymentFeeWebViewState extends State<PaymentFeeWebView> {
  late WebViewController controller;
  bool _paymentSuccess = false; // 🔹 لتتبع حالة الدفع

  @override
  void initState() {
    super.initState();

    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (url) async {
                if (url.contains('https://dashboard.fils.app/api/v1/')) {
                  String baseUrl = "https://dashboard.fils.app/api/v1/";
                  String remainingUrl = url.replaceFirst(baseUrl, "");

                  var json = await NetworkHelper.sendRequest(
                    requestType: RequestType.get,
                    endpoint: remainingUrl,
                  );

                  if (json['result'] == true || json['code'] == 200) {
                    _paymentSuccess = true; // ✅ تم الدفع بنجاح
                    if (mounted) Navigator.pop(context, true);
                  } else {
                    _paymentSuccess = false;
                    if (mounted) Navigator.pop(context, false);
                  }
                }
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.urlPayment));
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });

    return WillPopScope(
      onWillPop: () async {
        if (!_paymentSuccess) {
          Navigator.pop(context, false);
          return false; // لا نرجع للشاشة السابقة مرتين
        }
        return true;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: WebViewWidget(controller: controller),
        ),
      ),
    );
  }
}
