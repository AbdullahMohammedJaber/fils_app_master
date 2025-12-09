import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fils/model/response/comment_response.dart';
import 'package:fils/model/response/rell_response.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/global_function/printer.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/storage/storage.dart';

class CommentProvider extends ChangeNotifier {
  dynamic currentPage = 1;
  bool hasMore = false;
  bool loading = true;
  List<Comments> comments = [];

  CommentProvider(dynamic idReel) {
    fetchReelsApi(idReel, isRefresh: true);
  }

  fetchReelsApi(dynamic idReel, {bool isRefresh = false}) async {
    loading = true;
    if (isRefresh) {
      currentPage = 1;
    }
    try {
      final response = await NetworkHelper.sendRequest(
        requestType: RequestType.get,
        endpoint: "reel/comments/$idReel?page=$currentPage",
      );

      if (response['code'] == 200 || response['status'] == 200) {
        loading = false;

        CommentResponse commentResponse = CommentResponse.fromJson(response);

        final meta = commentResponse.meta;
        for (var action in commentResponse.data!) {
          print(action.toJson());
          comments.add(action);
        }
        currentPage++;
        hasMore = meta!.currentPage! < meta.lastPage!;
      } else {
        loading = false;

        throw Exception('Unexpected Error: Invalid response');
      }
    } catch (e) {
      loading = false;

      printWarning(e.toString());
      if (e.toString().contains('No Internet Connection')) {
        throw const SocketException('No Internet Connection');
      } else if (e.toString().contains('Time Out Connection')) {
        throw const SocketException('Time Out Connection');
      }
      throw Exception('Error: $e');
    } finally {
      loading = false;

      notifyListeners();
    }
  }

  addComment({
    required String title,
    required dynamic idReel,
    required Reels rel,
  }) async {
    showBoatToast();
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "reel/$idReel/add-comment",
      fields: {"comment": title},
    );
    closeAllLoading();
    if (json.containsKey("errorMessage")) {
      showCustomFlash(
        message: json['errorMessage'],
        messageType: MessageType.Faild,
      );
    } else {
      DateTime time = DateTime.now();
      Comments comment = Comments(
        name: getUser()!.user!.name,
        image: getUser()!.user!.avatarOriginal,
        comment: title,
        isLiked: false,
        likesCount: 0,
        id: json['data']['comment']['id'],
        productId: json['data']['comment']['product_id'],
        createdAt: time,
      );
      comments.insert(0, comment);
      rel.commentsCount = comments.length;
      notifyListeners();
    }
  }
}
