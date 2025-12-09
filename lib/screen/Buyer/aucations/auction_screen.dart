import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fils/model/response/all_auction_response.dart';
import 'package:fils/screen/general/sub_category.dart';
import 'package:fils/utils/enum/sub_category_screen.dart';
import 'package:fils/utils/http/list_pagination.dart';
import 'package:fils/utils/http/wrap_util.dart';
import 'package:fils/utils/route/route.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/aucation_notifier.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../model/response/online_store_response.dart';
import '../../../utils/global_function/loading_widget.dart';
import '../../../utils/storage/storage.dart';
import '../../../utils/theme/color_manager.dart';
import '../../../widget/defulat_text.dart';
import '../../../widget/flip_view.dart';
import 'item_auction_new.dart';
class AuctionScreen extends StatelessWidget {
  const AuctionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: -1,
        automaticallyImplyLeading: false,
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: heigth * 0.045),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: SizedBox(
                                  height: getLang() == 'ar' ? 30 : 28,
                                  width: 40,
                                  child: FlipView(
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "assets/icons/back.svg",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.transparent,
                                backgroundImage: const AssetImage(
                                  'assets/icons/fils.png',
                                ),
                              ),
                              SizedBox(width: width * 0.04),
                              SizedBox(
                                width: width * 0.5,
                                child: DefaultText(
                                  "Public Auctions".tr(),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: heigth * 0.05),

                          StaticWrapView(
                            endpoint: "categories",
                            requestType: RequestType.get,
                            cacheKey: "category_openMarket",
                            columns: 3,
                            rows: 3,
                            itemBuilder: (context, item) {
                              return GestureDetector(
                                onTap: () {
                                  ToWithFade(
                                    context,
                                    SubCategoryScreen(
                                      category_id: item.id,
                                      screen: SubCategoryScreenEnum.Auction,
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color:
                                            getTheme() ? Colors.black : grey6,
                                        border: Border.all(color: grey6),
                                      ),
                                      child: Center(
                                        child: CachedNetworkImage(
                                          imageUrl: item.banner,
                                          fit: BoxFit.cover,
                                          height: 60,
                                          width: 60,
                                          placeholder:
                                              (context, url) =>
                                                  const LoadingWidgetImage(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: heigth * 0.02),
                                    DefaultText(
                                      item.name,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          getTheme()
                                              ? white
                                              : const Color(0xff898384),
                                    ),
                                  ],
                                ),
                              );
                            },

                            parseItem: (json) => Category.fromJson(json),
                          ),
                          SizedBox(height: heigth * 0.03),
                          PaginatedListWidget(
                            isFirstData: true,
                            endpoint: "auction/products?is_auction=1",
                            requestType: RequestType.get,
                            isParam: true,
                            shrinkWrap: true,
                            parseItem: (json) => Datum.fromJson(json),
                            itemBuilder: (BuildContext context, Datum item) {
                              return ItemAuctionNew(item: item);
                            },
                          ),
                        ],
                      ),
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

class BannerShapePainter extends CustomPainter {
  final Color shapeColor;
  final double borderRadius;

  BannerShapePainter({
    this.shapeColor = const Color(0xFF30306F),
    this.borderRadius = 16.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = shapeColor
          ..style = PaintingStyle.fill; // Fill the shape

    final path = Path();

    final pA = Offset(0, borderRadius);

    final pB = Offset(size.width, 0);

    final pC = Offset(size.width * 1, size.height * 0.6);

    final pD = Offset(size.width * 0.78, size.height * 0.95);

    final pE = Offset(size.width * 0.40, size.height * 0.6);

    path.moveTo(pA.dx, pA.dy);

    path.arcToPoint(
      Offset(borderRadius, 0), // End of the arc
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );

    path.lineTo(pB.dx, pB.dy);

    path.lineTo(pC.dx, pC.dy);

    path.lineTo(pD.dx, pD.dy);

    path.lineTo(pE.dx, pE.dy);

    path.lineTo(0, size.height * 0.28);

    path.close();

    canvas.drawPath(path, paint);

    final foldPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;

    canvas.drawLine(Offset(0, size.height * 0.45), pE, foldPaint);

    canvas.drawLine(pD, pC, foldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
