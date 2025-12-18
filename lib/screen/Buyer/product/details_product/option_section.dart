import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/store_notofire.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

import '../../../../model/response/details_product_response.dart';

class OptionSection extends StatefulWidget {
  final ProductData details;

  const OptionSection({super.key, required this.details});

  @override
  State<OptionSection> createState() => _OptionSectionState();
}

class _OptionSectionState extends State<OptionSection> {
  @override
  void initState() {
    if (widget.details.stocks!.data.isNotEmpty) {
      context.read<StoreNotifire>().changeListSize(widget.details.stocks!.data);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.details.stocks!.data.isEmpty) {
      return const SizedBox();
    } else {
      return Consumer<StoreNotifire>(
        builder: (context, store, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: heigth * 0.02),
                Row(
                  children: [
                    DefaultText(
                      "Select option".tr(),
                      fontSize: 14,
                      color: const Color(0xff5A5555),
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(width: width * 0.02),
                  ],
                ),
                SizedBox(height: heigth * 0.03),
                Row(
                  children: [
                    for (dynamic i = 0; i < widget.details.colors!.length; i++)
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(color: grey4),
                          color: Color(
                            int.parse(
                              widget.details.colors![i].replaceAll('#', '0xff'),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: heigth * 0.01),
                Container(
                  height: heigth * 0.05,
                  margin: const EdgeInsets.only(top: 5),
                  color: Colors.transparent,
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (store.listSizeProduct[index].qtu == 0) {
                          } else {
                            store.selectItemSize(store.listSizeProduct[index]);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:
                                  store.listSizeProduct[index].qtu == 0
                                      ? textColor
                                      : primaryColor,
                            ),
                            color:
                                store.listSizeProduct[index].qtu == 0
                                    ? textColor
                                    : store.listSizeProduct[index].select!
                                    ? primaryColor
                                    : white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Center(
                              child: DefaultText(
                                store.listSizeProduct[index].name!,
                                color:
                                    store.listSizeProduct[index].qtu == 0
                                        ? white
                                        : store.listSizeProduct[index].select!
                                        ? white
                                        : textColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: store.listSizeProduct.length,
                    separatorBuilder: (BuildContext context, dynamic index) {
                      return const SizedBox(width: 10);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
