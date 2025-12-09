import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/app_notifire.dart';

import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

import '../../../utils/storage/storage.dart';

class TapBarItemFav extends StatefulWidget {
  const TapBarItemFav({super.key});

  @override
  State<TapBarItemFav> createState() => _TapBarItemFavState();
}

class _TapBarItemFavState extends State<TapBarItemFav> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifire>(
      builder: (context, app, child) {
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
                      app.changePageTapBar(index: 1);
                      app.changeUrlFav("wishlists?is_auction=0");
                    },
                    child: AnimatedContainer(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color:
                            app.pageTapBarFav == 1
                                ? primaryDarkColor
                                : getTheme()
                                ? Colors.black
                                : white,
                      ),
                      duration: const Duration(milliseconds: 100),
                      child: Center(
                        child: DefaultText(
                          "Online Product".tr(),
                          color:
                              app.pageTapBarFav == 1
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
                      app.changePageTapBar(index: 2);
                      app.changeUrlFav("wishlists?is_auction=1");
                    },
                    child: AnimatedContainer(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color:
                            app.pageTapBarFav == 2
                                ? primaryDarkColor
                                : getTheme()
                                ? Colors.black
                                : white,
                      ),
                      duration: const Duration(milliseconds: 100),
                      child: Center(
                        child: DefaultText(
                          "Auctions".tr(),
                          color:
                              app.pageTapBarFav == 2
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
