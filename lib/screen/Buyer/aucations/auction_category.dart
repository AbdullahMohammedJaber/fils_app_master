import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fils/screen/Buyer/aucations/tap_bar_auction.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../controller/provider/aucation_notifier.dart';
import '../../../model/response/all_auction_response.dart';
import '../../../utils/const.dart';
import '../../../utils/enum/request_type.dart';
import '../../../utils/global_function/loading_widget.dart';
import '../../../utils/global_function/update_controller.dart';
import '../../../utils/http/http_helper.dart';
import '../../../utils/http/list_pagination.dart';
import '../../../utils/storage/storage.dart';
import '../../../utils/theme/color_manager.dart';
import '../../../widget/dialog_auth.dart';
import '../../../widget/item_search.dart';
import '../favourite/favourait_screen.dart';
import 'aucatin_item_current.dart';
import 'auction_screen.dart';
import 'item_auction_new.dart';
import 'item_title_aucatin.dart';

UpdateController updateControllerAuction = UpdateController();

class AuctionCategory extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const AuctionCategory({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<AuctionCategory> createState() => _AuctionCategoryState();
}

class _AuctionCategoryState extends State<AuctionCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: -1,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        backgroundColor: zaherH,
      ),
      body: ChangeNotifierProvider(
        create: (context) => AuctionNotifier(),
        child: Consumer<AuctionNotifier>(
          builder: (context, auction, child) {
            return Stack(

              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 120,
                      width: width,
                      child: CustomPaint(
                        painter: BannerShapePainter(
                          shapeColor: zaherH,
                          borderRadius: 0,
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/icons/stack_bar.svg",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: heigth * 0.35,
                    ),
                  ],
                ),
                SafeArea(
                   child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: heigth * 0.05),
                        itemTitleAucatin(auction, context, widget.categoryName),
                        SizedBox(height: heigth * 0.07 ),
                        ItemSearch(),
                        SizedBox(height: heigth * 0.02),
                        TapBarItemAuction(category_id: widget.categoryId),
                        SizedBox(height: heigth * 0.02),

                        Expanded(
                          child: PaginatedListWidget(
                            isFirstData: true,
                            endpoint:
                                "${auction.url}/${widget.categoryId}${auction.end}",
                            requestType: RequestType.get,
                            isParam: true,
                            updateController: updateControllerAuction,
                            parseItem: (json) => Datum.fromJson(json),
                            itemBuilder: (BuildContext context, Datum item) {

                              return ItemAuctionNew(item: item);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
