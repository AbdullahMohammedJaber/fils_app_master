import 'package:easy_localization/easy_localization.dart';

import 'package:fils/model/response/seller/reviews_response.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/update_controller.dart';
import 'package:fils/utils/http/list_pagination.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AllUsersReviews extends StatefulWidget {
  final dynamic productId;

  const AllUsersReviews({super.key, required this.productId});

  @override
  State<AllUsersReviews> createState() => _AllUsersReviewsState();
}

UpdateController reviewUpdate = UpdateController();

class _AllUsersReviewsState extends State<AllUsersReviews> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              DefaultText(
                "All reviews".tr(),
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: blackColor,
              ),
              const Spacer(),
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
        ),
        Expanded(
          child: PaginatedListWidget(
            endpoint: "products/reviews?product_id=${widget.productId}",
            isFirstData: true,
            requestType: RequestType.get,
            itemBuilder: (context, item) => Container(
              color: error40,
              width: width,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: primaryColor,
                    backgroundImage: NetworkImage(item.avatar),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: DefaultText(
                                item.name,
                                color: blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            _buildRate(item.rating),
                            DefaultText(
                              "(${item.rating})",
                              color: blackColor,
                              fontSize: 12,
                              textDecoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        DefaultText(
                          item.comment,
                          color: blackColor,
                          fontSize: 12,
                          overflow: TextOverflow.visible,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            parseItem: (json) => Reviews.fromJson(json),
            updateController: reviewUpdate,
            isParam: true,
          ),
        ),
      ],
    );
  }

  Widget _buildRate(num value) {
    dynamic unRate = 5 - value.toInt();
    return Row(
      children: [
        ...List.generate(
          value.toInt(),
          (index) {
            return const Icon(
              Icons.star,
              color: Colors.amber,
            );
          },
        ),
        ...List.generate(
          unRate,
          (index) {
            return const Icon(
              Icons.star,
              color: Colors.grey,
            );
          },
        )
      ],
    );
  }
}
