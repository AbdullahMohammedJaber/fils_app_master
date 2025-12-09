import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/cart_notifire.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

import '../../../utils/storage/storage.dart';

class TapBarItem extends StatelessWidget {
  const TapBarItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartNotifire>(
      builder: (context, cart, child) {
        return Container(
          height: 55,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: grey3),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.06,
              vertical: 5,
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      cart.changePageTapBar(index: 1);
                    },
                    child: AnimatedContainer(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color:
                            cart.pageTapBar == 1
                                ? secondColor
                                : getTheme()
                                ? Colors.black
                                : white,
                      ),
                      duration: const Duration(milliseconds: 100),
                      child: Center(
                        child: DefaultText(
                          "Online Product".tr(),
                          color:
                              cart.pageTapBar == 1
                                  ? white
                                  : getTheme()
                                  ? white
                                  : blackColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.01),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      cart.changePageTapBar(index: 2);
                    },
                    child: AnimatedContainer(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color:
                            cart.pageTapBar == 2
                                ? secondColor
                                : getTheme()
                                ? Colors.black
                                : white,
                      ),
                      duration: const Duration(milliseconds: 100),
                      child: Center(
                        child: DefaultText(
                          "Auctions".tr(),
                          color:
                              cart.pageTapBar == 2
                                  ? white
                                  : getTheme()
                                  ? white
                                  : blackColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
