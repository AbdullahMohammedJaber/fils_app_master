// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:fils/controller/provider/order_notifire.dart';
import 'package:fils/model/response/order_response.dart';
import 'package:fils/screen/Buyer/order/item_order.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/http/list_pagination.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/defualt_text_form_faild.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/item_back.dart';

class CancelOrderScreen extends StatefulWidget {
  const CancelOrderScreen({super.key});

  @override
  State<CancelOrderScreen> createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  @override
  void initState() {
    context.read<OrderNotifier>().idOrderForCancel = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderNotifier>(builder: (context, order, child) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              SizedBox(height: heigth * 0.06),
              itemBackAndTitle(context, title: "Cancellation Request".tr()),
              SizedBox(height: heigth * 0.03),
              Expanded(
                child: PaginatedListWidget(
                  cacheKey: "cancel_order",
                  isFirstData: true,
                  requestType: RequestType.get,
                  isParam: true,
                  parseItem: (json) => Orders.fromJson(json),
                  updateController: order.cancelUpdate,
                  itemBuilder: (context, item) {
                    return ItemOrder(orders: item, isCancel: true, status: 3);
                  },
                  endpoint:
                      "purchase-history?delivery_status=pending&payment_status=unpaid",
                ),
              ),
              SizedBox(height: heigth * 0.1),
            ],
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: ButtonWidget(
            onTap: () {
              if (order.idOrderForCancel != null) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (context) => const ItemCancelForm(),
                );
              }
            },
            colorButton: secondColor,
            title: "Cancellation".tr(),
          ),
        ),
      );
    });
  }
}

class ItemCancelForm extends StatefulWidget {
  const ItemCancelForm({super.key});

  @override
  State<ItemCancelForm> createState() => _ItemCancelFormState();
}

class _ItemCancelFormState extends State<ItemCancelForm> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _clearMessageOnKeyboardClose() {
    FocusScope.of(context).unfocus();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!FocusScope.of(context).hasFocus) {
        _messageController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderNotifier>(builder: (context, order, child) {
      return GestureDetector(
        onTap: _clearMessageOnKeyboardClose,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset("assets/icons/close.svg"),
                  ),
                ),
                const SizedBox(height: 16),
                Center(child: Image.asset("assets/images/false.png")),
                const SizedBox(height: 16),
                DefaultText(
                  "Please state the reason for cancellation.".tr(),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 20),
                TextFormFieldWidget(
                  maxLine: 5,
                  controller: _messageController,
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 15),
                ButtonWidget(
                  onTap: () {
                    if (_messageController.text.isNotEmpty) {
                      Navigator.pop(context);
                      order.cancelOrderRequest(
                          message: _messageController.text);
                      _messageController.clear();
                      order.idOrderForCancel = null;
                    }
                  },
                  title: "Send".tr(),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      );
    });
  }
}
