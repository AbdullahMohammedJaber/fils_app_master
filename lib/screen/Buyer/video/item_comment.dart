// ignore_for_file: must_be_immutable, prefer_interpolation_to_compose_strings

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fils/model/response/comment_response.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/timer_format.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/dialog_auth.dart';

class ItemComment extends StatefulWidget {
  Comments comments;

  ItemComment(this.comments, {super.key});

  @override
  State<ItemComment> createState() => _ItemCommentState();
}

class _ItemCommentState extends State<ItemComment> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (widget.comments.image != null)
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.comments.image),
                )
              else
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/logo_png.png"),
                ),
              const SizedBox(width: 10),
              DefaultText(
                widget.comments.name,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xff433E3F),
              ),
              const Spacer(),
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (isLogin()) {
                        if (widget.comments.isLiked!) {
                          widget.comments.isLiked = false;
                          widget.comments.likesCount--;
                          setState(() {});
                        } else {
                          widget.comments.isLiked = true;
                          widget.comments.likesCount++;

                          setState(() {});
                          // ignore: unused_local_variable
                          var json = await NetworkHelper.sendRequest(
                            requestType: RequestType.get,
                            endpoint:
                                "reel/comments/${widget.comments.id}/like",
                          );
                        }
                      } else {
                        showDialogAuth(context);
                      }
                    },
                    child: Center(
                      child: SvgPicture.asset(
                        widget.comments.isLiked
                            ? "assets/icons/fav_fill.svg"
                            : "assets/icons/favourite_home.svg",
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  DefaultText(
                    widget.comments.likesCount.toString(),
                    fontSize: 12,
                    color: const Color(0xff433E3F),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          DefaultText(
            widget.comments.comment,
            fontSize: 12,
            textAlign: TextAlign.start,
            overflow: TextOverflow.visible,
            fontWeight: FontWeight.w400,
            color: const Color(0xff9F9C9C),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              DefaultText(
                getTimeAgo(widget.comments.createdAt!),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xff726C6C),
              ),
              const SizedBox(width: 20),
              DefaultText(
                "${widget.comments.likesCount}" + " Like ".tr(),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xff726C6C),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
