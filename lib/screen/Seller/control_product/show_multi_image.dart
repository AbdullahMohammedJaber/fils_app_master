import 'package:fils/controller/provider/edit_product_notifire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fils/controller/provider/aucation_notifier.dart';
import 'package:fils/controller/provider/product_notifire.dart';
import 'package:fils/utils/global_function/image_view.dart';
import 'package:fils/utils/route/route.dart';
import 'package:provider/provider.dart';

import '../../../utils/const.dart';
import '../../../utils/theme/color_manager.dart';

Widget showMultiImage() {
  return Consumer<ProductNotifire>(
    builder: (context, controller, child) {
      return Column(
        children: [
          SizedBox(
            width: width,
            height: controller.imageFilesList.isNotEmpty ? heigth * 0.01 : 0,
          ),
          controller.imageFilesList.isNotEmpty
              ? SizedBox(
                height: 100,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        GestureDetector(
                          child: Container(
                            width: 100,
                            height: 100,
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: textColor),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                controller.imageFilesList[index],
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                              ),
                            ),
                          ),
                          onTap: () {
                            controller.changeIndexSelectImage(index);
                          },
                        ),
                        controller.selectImage == index
                            ? Row(
                              children: [
                                GestureDetector(
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "assets/icons/solar_eye.svg",
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    ToWithFade(
                                      context,
                                      ImageView(
                                        images: controller.imageFilesList,
                                        initialIndex: index,
                                      ),
                                    );
                                  },
                                ),
                                GestureDetector(
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "assets/icons/delete_white.svg",
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    controller.deleteImageSelect(index);
                                  },
                                ),
                              ],
                            )
                            : const SizedBox(),
                      ],
                    );
                  },
                  separatorBuilder:
                      (context, index) => SizedBox(width: width * 0.05),
                  itemCount: controller.imageFilesList.length,
                ),
              )
              : const SizedBox(),
        ],
      );
    },
  );
}



Widget showMultiImageAuction() {
  return Consumer<AuctionNotifier>(
    builder: (context, controller, child) {
      return Column(
        children: [
          SizedBox(
            width: width,
            height: controller.imageFilesList.isNotEmpty ? heigth * 0.01 : 0,
          ),
          controller.imageFilesList.isNotEmpty
              ? SizedBox(
                height: 100,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        GestureDetector(
                          child: Container(
                            width: 100,
                            height: 100,
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: textColor),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                controller.imageFilesList[index],
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                              ),
                            ),
                          ),
                          onTap: () {
                            controller.changeIndexSelectImage(index);
                          },
                        ),
                        controller.selectImage == index
                            ? Row(
                              children: [
                                GestureDetector(
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "assets/icons/solar_eye.svg",
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    ToWithFade(
                                      context,
                                      ImageView(
                                        images: controller.imageFilesList,
                                        initialIndex: index,
                                      ),
                                    );
                                  },
                                ),
                                GestureDetector(
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "assets/icons/delete_white.svg",
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    controller.deleteImageSelect(index);
                                  },
                                ),
                              ],
                            )
                            : const SizedBox(),
                      ],
                    );
                  },
                  separatorBuilder:
                      (context, index) => SizedBox(width: width * 0.05),
                  itemCount: controller.imageFilesList.length,
                ),
              )
              : const SizedBox(),
        ],
      );
    },
  );
}

Widget showMultiImageEdit() {
  return Consumer<EditProductNotifire>(
    builder: (context, controller, child) {
      return Column(
        children: [
          SizedBox(
            width: width,
            height:
                controller.imageFilesListEdit.isNotEmpty ||
                        controller.imageUrlListEdit.isNotEmpty
                    ? heigth * 0.01
                    : 0,
          ),
          if (controller.imageFilesListEdit.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      GestureDetector(
                        child: Container(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: textColor),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              controller.imageFilesListEdit[index],
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                        onTap: () {
                          controller.changeIndexSelectImageEdit(index);
                        },
                      ),
                      controller.selectImageEdit == index
                          ? Row(
                            children: [
                              GestureDetector(
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      "assets/icons/solar_eye.svg",
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  ToWithFade(
                                    context,
                                    ImageView(
                                      images: controller.imageFilesListEdit,
                                      initialIndex: index,
                                    ),
                                  );
                                },
                              ),
                              GestureDetector(
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      "assets/icons/delete_white.svg",
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  controller.deleteImageSelectEdit(index , true);
                                },
                              ),
                            ],
                          )
                          : const SizedBox(),
                    ],
                  );
                },
                separatorBuilder:
                    (context, index) => SizedBox(width: width * 0.05),
                itemCount: controller.imageFilesListEdit.length,
              ),
            ),
          if (controller.imageUrlListEdit.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      GestureDetector(
                        child: Container(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: textColor),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              controller.imageUrlListEdit[index],
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                        onTap: () {
                          controller.changeIndexSelectImageEdit(index);
                        },
                      ),
                      controller.selectImageEdit == index
                          ? Row(
                            children: [
                              GestureDetector(
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      "assets/icons/solar_eye.svg",
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  ToWithFade(
                                    context,
                                    ImageView(
                                      images: controller.imageUrlListEdit,
                                      initialIndex: index,
                                    ),
                                  );
                                },
                              ),
                              GestureDetector(
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      "assets/icons/delete_white.svg",
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  controller.deleteImageSelectEdit(index , false);
                                },
                              ),
                            ],
                          )
                          : const SizedBox(),
                    ],
                  );
                },
                separatorBuilder:
                    (context, index) => SizedBox(width: width * 0.05),
                itemCount: controller.imageUrlListEdit.length,
              ),
            ),
        ],
      );
    },
  );
}
