import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/product_notifire.dart';
import 'package:fils/screen/Seller/control_product/color_list.dart';
import 'package:fils/screen/Seller/control_product/size_list.dart';
import 'package:fils/screen/Seller/control_product/switch_color_size_widget.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/item_back.dart';
import 'package:provider/provider.dart';

class OptionScreen extends StatelessWidget {
  const OptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    heigth = MediaQuery.of(context).size.height;
    return Consumer<ProductNotifire>(builder: (context, controller, child) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: heigth * 0.086),
                itemBackAndTitle(context, title: "Option".tr()),
                SizedBox(height: heigth * 0.05),
                DefaultText("Options".tr(),
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                SizedBox(height: heigth * 0.02),
                switchColorSizeWidget(context),
                controller.switchColor ? const ColorList() : const SizedBox(),
                controller.switchSize ? const SizeList() : const SizedBox(),
                SizedBox(height: heigth * 0.12),
              ],
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ButtonWidget(
            onTap: () {
              if (!controller.switchColor || controller.colorSelect.isEmpty) {
                showCustomFlash(
                    message: "The Color Required".tr(),
                    messageType: MessageType.Faild);
              }  else {
                Navigator.pop(context);
              }

            },
            title: "Done".tr(),
          ),
        ),
      );
    });
  }
}
