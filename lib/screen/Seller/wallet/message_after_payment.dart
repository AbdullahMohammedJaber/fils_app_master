// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/product_notifire.dart';
import 'package:fils/model/response/base_response.dart';
import 'package:fils/screen/general/root_app.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';


class ErrorWithdrawal extends StatelessWidget {
  const ErrorWithdrawal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: heigth * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 45,
                  width: 45,
                  color: Colors.transparent,
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/icons/x.svg",
                      color: blackColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: heigth * 0.01),
          Image.asset("assets/images/false.png"),
          SizedBox(height: heigth * 0.01),
          DefaultText(
            "Withdrawal Request Failed. Try again.".tr(),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: heigth * 0.05),
          ButtonWidget(
            onTap: () {
              Navigator.pop(context);
            },
            title: "Try again".tr(),
            colorButton: secondColor,
          ),
          SizedBox(height: heigth * 0.03),
        ],
      ),
    );
  }
}

class DoneWithdrawal extends StatelessWidget {
  const DoneWithdrawal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: heigth * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 45,
                  width: 45,
                  color: Colors.transparent,
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/icons/x.svg",
                      color: blackColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: heigth * 0.01),
          Image.asset("assets/images/donee.png"),
          SizedBox(height: heigth * 0.01),
          DefaultText(
            "withdrawal is successfully requested #TXN987654".tr(),
            fontSize: 14,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: heigth * 0.05),
          ButtonWidget(
            onTap: () {
              toRemoveAll(context, const RootAppScreen());
            },
            title: "Home".tr(),
            colorButton: secondColor,
          ),
          SizedBox(height: heigth * 0.03),
        ],
      ),
    );
  }
}

class DoneSetupBanck extends StatelessWidget {
  const DoneSetupBanck({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: heigth * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 45,
                  width: 45,
                  color: Colors.transparent,
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/icons/x.svg",
                      color: blackColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: heigth * 0.01),
          Image.asset("assets/images/donee.png"),
          SizedBox(height: heigth * 0.01),
          DefaultText(
            "Bank Settings is Updated".tr(),
            fontSize: 14,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: heigth * 0.05),
          ButtonWidget(
            onTap: () {
              toRemoveAll(context, const RootAppScreen());
            },
            title: "Home".tr(),
            colorButton: secondColor,
          ),
          SizedBox(height: heigth * 0.03),
        ],
      ),
    );
  }
}

class DeleteProduct extends StatelessWidget {
  final dynamic idProduct;

  const DeleteProduct({super.key, required this.idProduct});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductNotifire>(
      builder: (context, controller, child) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: heigth * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      color: Colors.transparent,
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/icons/x.svg",
                          color: blackColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: heigth * 0.01),
              Image.asset("assets/images/false.png"),
              SizedBox(height: heigth * 0.01),
              DefaultText(
                "Are you sure you want to remove the product from your list?"
                    .tr(),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: heigth * 0.05),
              Row(
                children: [
                  Expanded(
                    child: ButtonWidget(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      title: "Cancel".tr(),
                      colorButton: secondColor,
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  Expanded(
                    child: ButtonWidgetBorder(
                      onTap: () async {
                        Navigator.pop(context);
                        showBoatToast();
                        final json = await NetworkHelper.sendRequest(
                          requestType: RequestType.get,
                          endpoint: "product/delete/$idProduct",
                        );
                        closeAllLoading();
                        BaseResponse base = BaseResponse.fromJson(json);
                        showCustomFlash(
                          message: base.message,
                          messageType: MessageType.Success,
                        );
                        controller.updateControllerProduct.update();
                        Navigator.pop(context);
                      },
                      title: "confirmation".tr(),
                      colorBorder: primaryColor,
                      colorTitle: primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: heigth * 0.03),
            ],
          ),
        );
      },
    );
  }
}
