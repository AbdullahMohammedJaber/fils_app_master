import 'package:fils/controller/provider/edit_product_notifire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fils/controller/provider/aucation_notifier.dart';
import 'package:fils/controller/provider/product_notifire.dart';
import 'package:provider/provider.dart';

import '../../../utils/const.dart';
import '../../../utils/theme/color_manager.dart';

Widget showImage() {
  return Consumer<ProductNotifire>(
    builder: (context, controller, child) {
      return Column(
        children: [
          SizedBox(
            width: width,
            height: controller.imageFile != null ? heigth * 0.01 : 0,
          ),
          controller.imageFile != null
              ? Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Container(
                    width: width,
                    height: heigth * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: textColor),
                    ),
                    child: Image.file(
                      controller.imageFile!,
                      fit: BoxFit.contain,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.clearImage();
                    },
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: SvgPicture.asset("assets/icons/cancel.svg"),
                      ),
                    ),
                  ),
                ],
              )
              : const SizedBox(),
        ],
      );
    },
  );
}

Widget showImageAuction() {
  return Consumer<AuctionNotifier>(
    builder: (context, controller, child) {
      return Column(
        children: [
          SizedBox(
            width: width,
            height: controller.imageFile != null ? heigth * 0.01 : 0,
          ),
          controller.imageFile != null
              ? Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Container(
                    width: width,
                    height: heigth * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: textColor),
                    ),
                    child: Image.file(
                      controller.imageFile!,
                      fit: BoxFit.contain,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.clearImage();
                    },
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: SvgPicture.asset("assets/icons/cancel.svg"),
                      ),
                    ),
                  ),
                ],
              )
              : const SizedBox(),
        ],
      );
    },
  );
}

Widget showImageEdit() {
  return Consumer<EditProductNotifire>(
    builder: (context, controller, child) {
      return Column(
        children: [
          SizedBox(
            width: width,
            height:
                controller.imageFileEdit != null ||
                        controller.thumbnailImgUrl.isNotEmpty
                    ? heigth * 0.01
                    : 0,
          ),
          if (controller.imageFileEdit != null)
            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Container(
                  width: width,
                  height: heigth * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: textColor),
                  ),
                  child: Image.file(
                    controller.imageFileEdit!,
                    fit: BoxFit.contain,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.clearImageEdit();
                  },
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: SvgPicture.asset("assets/icons/cancel.svg"),
                    ),
                  ),
                ),
              ],
            ),
          if (controller.thumbnailImgUrl.isNotEmpty)
            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Container(
                  width: width,
                  height: heigth * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: textColor),
                  ),
                  child: Image.network(
                    controller.thumbnailImgUrl,
                    fit: BoxFit.contain,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.clearImageEdit();
                  },
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: SvgPicture.asset("assets/icons/cancel.svg"),
                    ),
                  ),
                ),
              ],
            ),
        ],
      );
    },
  );
}
