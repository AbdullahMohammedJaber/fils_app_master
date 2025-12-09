// ignore_for_file: must_be_immutable, prefer_interpolation_to_compose_strings

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fils/controller/provider/comment_notefire.dart';
import 'package:fils/model/response/rell_response.dart';
import 'package:fils/screen/Buyer/video/item_comment.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/strings_app.dart';
import 'package:fils/utils/theme/color_manager.dart';

import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/dialog_auth.dart';
import 'package:provider/provider.dart';

class CommentBottomSheet extends StatefulWidget {
  dynamic commentCount;
  final dynamic idReel;
  final Reels reels;

  CommentBottomSheet({
    super.key,
    required this.commentCount,
    required this.idReel,
    required this.reels,
  });

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController commentController = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CommentProvider(widget.idReel),
      child: Consumer<CommentProvider>(builder: (context, app, child) {
        return Form(
          key: _key,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Spacer(),
                    DefaultText(
                      "comments".tr() + "  ${app.comments.length}",
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: app.loading
                      ? const LoadingWidget()
                      : app.comments.isEmpty
                      ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DefaultText(
                            "No comments!".tr(),
                            color: blackColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(width: 3),
                          DefaultText(
                            "Add a comment".tr(),
                            color: textColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ))
                      : ListView.separated(
                      itemBuilder: (context, index) {
                        return ItemComment(app.comments[index]);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: heigth * 0.01);
                      },
                      itemCount: app.comments.length),
                ),
                SizedBox(height: heigth * 0.02),
                const Divider(),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: TextFormField(
                    controller: commentController,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (commentController.text.isEmpty) {
                        return requiredField;
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Add comment ...".tr(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          if (isLogin()) {
                            if (_key.currentState!.validate()) {
                              app.addComment(
                                title: commentController.text,
                                idReel: widget.idReel,
                                rel: widget.reels,
                              );
                            }
                          } else {
                            showDialogAuth(context);
                          }
                        },
                      ),
                    ),
                    textInputAction: TextInputAction.send,
                    onFieldSubmitted: (value) {
                      if (isLogin()) {
                        if (_key.currentState!.validate()) {
                          app.addComment(
                            title: commentController.text,
                            idReel: widget.idReel,
                            rel: widget.reels,
                          );
                        }
                      } else {
                        showDialogAuth(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

