// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fils/model/response/rell_response.dart';
import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/printer.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoController extends ChangeNotifier {
  final List<VideoPlayerController> _videoPlayerControllers = [];
  final List<ChewieController> _chewieControllers = [];
  dynamic _currentVideoIndex = 0;
  bool _isLoading = true;

  List<Reels> videoUrls = [];

  VideoPlayerController get videoPlayerController =>
      _videoPlayerControllers[_currentVideoIndex];

  ChewieController get chewieController =>
      _chewieControllers[_currentVideoIndex];

  bool get isLoading => _isLoading;

  void _initializeVideoControllers() {
    for (var url in videoUrls) {
      var videoController = VideoPlayerController.network(url.videoLink);
      _videoPlayerControllers.add(videoController);

      var chewieController = ChewieController(
        videoPlayerController: videoController,
        autoPlay: false,
        looping: false,
      );
      _chewieControllers.add(chewieController);
    }
    notifyListeners();
  }

  void _playVideoAtIndex(dynamic index) async {
    _isLoading = true;
    notifyListeners();

    await _videoPlayerControllers[index].initialize();
    _chewieControllers[index].play();
    _isLoading = false;
    notifyListeners();
  }

  void changeVideo(dynamic index) {
    _chewieControllers[_currentVideoIndex].pause();
    _currentVideoIndex = index;
    _playVideoAtIndex(_currentVideoIndex);
  }

  void stopVideo(dynamic index) {
    _chewieControllers[index].pause();
  }

  // Future<void> downloadVideoToGallery() async {
  //   final videoUrl = videoUrls[_currentVideoIndex];
  //   bool success = await GallerySaver.saveVideo(videoUrl);
  //   if (success) {
  //   } else {}
  // }
  dynamic progress = 0;
  String progressText = "0 %";

  Future<void> saveNetworkVideoFile() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showCustomFlash(
        message: "No internet connection available!".tr(),
        messageType: MessageType.Faild,
      );
      return;
    }

    showModalBottomSheet(
      context: NavigationService.navigatorKey.currentContext!,
      isDismissible: false,
      enableDrag: false,
      builder: (_) {
        return buildDownloadWidget();
      },
    );

    try {
      final fileUrl = videoUrls[_currentVideoIndex];
      final String fileName = "${fileUrl.name}.mp4";
      late String savePath;

      if (Platform.isAndroid) {
        final Directory? appDir = await getExternalStorageDirectory();
        if (appDir == null) {
          throw Exception("Unable to get storage directory.");
        }

        final Directory videoDir = Directory("${appDir.path}/Fils");
        if (!videoDir.existsSync()) {
          videoDir.createSync(recursive: true);
        }

        savePath = "${videoDir.path}/$fileName";
      } else if (Platform.isIOS) {
        final dir = await getApplicationDocumentsDirectory();
        savePath = "${dir.path}/$fileName";
      }

      final response = await Dio().get(
        fileUrl.videoLink,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: (count, total) {
          progress = ((count / total) * 100).round();
          progressText = "$progress %";
          notifyListeners();
          if (kDebugMode) {
            print("Progress: $progressText");
          }
        },
      );

      final Uint8List videoBytes = Uint8List.fromList(response.data);
      final file = File(savePath);
      await file.writeAsBytes(videoBytes);

      Navigator.of(NavigationService.navigatorKey.currentContext!).pop();

      if (await file.exists()) {
        showCustomFlash(
          message: "Download Complete!".tr(),
          messageType: MessageType.Success,
        );
      } else {
        showCustomFlash(
          message: "Saving failed!".tr(),
          messageType: MessageType.Faild,
        );
      }
    } catch (e) {
      Navigator.of(NavigationService.navigatorKey.currentContext!).pop();
      print("Error saving video: $e");
      showCustomFlash(
        message: "Download Failed!".tr(),
        messageType: MessageType.Faild,
      );
    }

    progress = 0;
    progressText = "0 %";
    notifyListeners();
  }

  dynamic currentPage = 1;
  bool hasMore = false;
  bool loading = true;

  fetchReelsApi({bool isRefresh = false}) async {
    loading = true;
    if (isRefresh) {
      currentPage = 1;
      videoUrls.clear();
      _videoPlayerControllers.clear();
      _chewieControllers.clear();
    }
    try {
      final response = await NetworkHelper.sendRequest(
        requestType: RequestType.get,
        endpoint: "reel?page=$currentPage",
      );

      if (response['code'] == 200 || response['status'] == 200) {
        loading = false;

        ReelResponse reelResponse = ReelResponse.fromJson(response);

        final meta = reelResponse.meta;
        reelResponse.data = reelResponse.data.reversed.toList();
        for (var action in reelResponse.data) {
          printGreen(action.videoLink);
          videoUrls.add(action);
        }
        videoUrls.shuffle();
        currentPage++;
        hasMore = meta.currentPage < meta.lastPage;
        if (reelResponse.data.isNotEmpty) {
          _initializeVideoControllers();
          _playVideoAtIndex(_currentVideoIndex);
        }
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
    }
    notifyListeners();
  }

  void disposeAllVideos() {
    for (var controller in _videoPlayerControllers) {
      controller.pause();
      controller.dispose();
    }

    for (var chewie in _chewieControllers) {
      chewie.dispose();
    }

    _videoPlayerControllers.clear();
    _chewieControllers.clear();
    _currentVideoIndex = 0;
    _isLoading = false;
  }

  @override
  void dispose() {
    disposeAllVideos();
    super.dispose();
  }
}
