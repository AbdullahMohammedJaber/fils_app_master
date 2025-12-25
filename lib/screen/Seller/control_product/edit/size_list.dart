// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:fils/controller/provider/edit_product_notifire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/product_notifire.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';

import 'package:provider/provider.dart';

class SizeListEdit extends StatefulWidget {
  const SizeListEdit({super.key});

  @override
  State<SizeListEdit> createState() => _SizeListState();
}

class _SizeListState extends State<SizeListEdit> {
  ScrollController scrollController = ScrollController();

  void scrollUp() {
    double newPosition = scrollController.position.pixels + 150;
    if (newPosition > scrollController.position.maxScrollExtent) {
      newPosition = scrollController.position.maxScrollExtent;
    }
    scrollController.animateTo(
      newPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void scrollDown() {
    double newPosition = scrollController.position.pixels - 150;
    if (newPosition < scrollController.position.minScrollExtent) {
      newPosition = scrollController.position.minScrollExtent;
    }
    scrollController.animateTo(
      newPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditProductNotifire>(builder: (context, controller, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: heigth * 0.03),
          DefaultText("Size".tr(),
              fontSize: 14, fontWeight: FontWeight.w500, color: blackColor),
          SizedBox(height: heigth * 0.01),
          GestureDetector(
            onTap: () {
              controller.changeShowListSize();
            },
            child: Container(
              width: width,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffE9E9E9)),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                child: Row(
                  children: [
                    SvgPicture.asset("assets/icons/sort.svg"),
                    SizedBox(width: width * 0.03),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: List.generate(
                            controller.sizeSelect.length,
                            (index) {
                              return GestureDetector(
                                onTap: () {
                                  controller.selectSizeId(
                                      controller.sizeSelect[index]);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: purpleColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DefaultText(
                                        controller.sizeSelect[index].value,
                                        color: white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      SizedBox(width: width * 0.02),
                                      Center(
                                        child: SvgPicture.asset(
                                          "assets/icons/x.svg",
                                          color: white,
                                          height: 15,
                                          width: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SvgPicture.asset("assets/icons/drob.svg"),
                  ],
                ),
              ),
            ),
          ),
          controller.isShowListSize
              ? Stack(
                  children: [
                    Container(
                      width: width,
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xffE9E9E9)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Scrollbar(
                          thumbVisibility: true,
                          radius: const Radius.circular(10),
                          thickness: 5,
                          controller: scrollController,
                          child: SingleChildScrollView(
                            controller: scrollController,
                            physics: const BouncingScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: List.generate(
                                  controller.sizeList.length,
                                  (index) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              controller.selectSizeId(
                                                  controller.sizeList[index]);
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: purpleColor),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: controller
                                                      .sizeList[index].isSelect
                                                  ? Center(
                                                      child: SvgPicture.asset(
                                                      "assets/icons/check.svg",
                                                      color: purpleColor,
                                                    ))
                                                  : const SizedBox(),
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          DefaultText(
                                            controller.sizeList[index].value,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: Directionality.of(context) == TextDirection.rtl
                          ? 10
                          : null,
                      right: Directionality.of(context) == TextDirection.ltr
                          ? 10
                          : null,
                      child: FloatingActionButton(
                        onPressed: () => scrollUp(),
                        backgroundColor: purpleColor,
                        mini: true,
                        child: const Icon(Icons.arrow_downward,
                            color: Colors.white),
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      left: Directionality.of(context) == TextDirection.rtl
                          ? 10
                          : null,
                      right: Directionality.of(context) == TextDirection.ltr
                          ? 10
                          : null,
                      child: FloatingActionButton(
                        onPressed: () => scrollDown(),
                        backgroundColor: purpleColor,
                        mini: true,
                        child:
                        const Icon(Icons.arrow_upward, color: Colors.white),
                      ),
                    ),
                  ],
                )
              : const SizedBox()
        ],
      );
    });
  }
}
