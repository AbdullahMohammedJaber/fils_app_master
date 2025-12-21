/*
import 'package:chewie/chewie.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/vedio_notifire.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/item_back.dart';
import 'package:fils/screen/Buyer/video/anlayse_data.dart';

import '../../general/chat_boot.dart';
import '../aucations/auction_screen.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    Provider.of<VideoController>(
      context,
      listen: false,
    ).fetchReelsApi(isRefresh: true);
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (Provider.of<VideoController>(context, listen: false).hasMore) {
        Provider.of<VideoController>(
          context,
          listen: false,
        ).fetchReelsApi(isRefresh: false);
      }
    }
  }

  bool isActive = true;
  late VideoController myProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    myProvider = Provider.of<VideoController>(context, listen: false);
  }

  @override
  void dispose() {
    if (isActive) {
      myProvider.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: -1,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        backgroundColor: moveH,
      ),
      body: ChangeNotifierProvider(
        create: (context) => VideoController()..fetchReelsApi(isRefresh: true),
        child: Stack(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 120,
                  width: width,
                  child: CustomPaint(
                    painter: BannerShapePainter(
                      shapeColor: moveH,
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
              child: Consumer<VideoController>(
                builder: (context, videoController, child) {
                  return videoController.loading
                      ? Column(
                        children: [
                          SizedBox(height: heigth * 0.06),
                          itemBackAndTitle(context, title: "Reels".tr()),
                          SizedBox(height: heigth * 0.01),

                          Expanded(
                            child: Center(
                              child: TypingIndicator(color: primaryDarkColor),
                            ),
                          ),
                        ],
                      )
                      : videoController.videoUrls.isEmpty
                      ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          children: [
                            SizedBox(height: heigth * 0.06),
                            itemBackAndTitle(context, title: "Reels".tr()),
                            SizedBox(height: heigth * 0.01),

                            const Spacer(),
                            Center(child: DefaultText("Not Found Reels".tr())),
                            const Spacer(),
                          ],
                        ),
                      )
                      : Column(
                        children: [
                          SizedBox(height: heigth * 0.06),
                          itemBackAndTitle(context, title: "Reels".tr()),
                          SizedBox(height: heigth * 0.05),

                          Expanded(
                            child: PageView.builder(
                              scrollDirection: Axis.vertical,
                              onPageChanged: (index) {
                                videoController.changeVideo(index);
                              },
                              itemCount: videoController.videoUrls.length,
                              itemBuilder: (context, index) {
                                 double aspectRatio =
                                    videoController
                                        .videoPlayerController
                                        .value
                                        .size
                                        .aspectRatio;

                                return Stack(
                                  children: [
                                    videoController
                                                .chewieController
                                                .videoPlayerController
                                                .value
                                                .isInitialized &&
                                            !videoController.isLoading
                                        ? Container(
                                          color: blackColor,
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: AspectRatio(
                                            aspectRatio: aspectRatio,
                                            child: Chewie(
                                              controller:
                                                  videoController.chewieController,
                                            ),
                                          ),
                                        )
                                        : Container(
                                          color: Colors.transparent,
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                    if (videoController.videoUrls[index].shopName !=
                                        null)
                                      PositionAnalyze(
                                        data: videoController.videoUrls[index],
                                      ),
                                    if (videoController.videoUrls[index].shopName !=
                                        null)
                                      positionTitle(
                                        videoController.videoUrls[index],
                                        context,
                                        index,
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/screen/Buyer/video/anlayse_data.dart';
import 'package:fils/widget/item_back.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:video_player/video_player.dart';
import '../../../controller/provider/vedio_notifire.dart';
import '../../../utils/theme/color_manager.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReelsProvider(),
      child: Consumer<ReelsProvider>(
        builder: (_, p, __) {
          return Scaffold(
            body: Stack(
              children: [
                PageView.builder(
                  controller: p.pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: p.videoUrls.length,
                  onPageChanged: p.onPageChanged,
                  itemBuilder: (_, index) {
                    final controller = p.getController(index);

                    if (controller == null || !controller.value.isInitialized) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return Stack(
                      children: [
                        SizedBox.expand(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: controller.value.size.width,
                              height: controller.value.size.height,
                              child: VideoPlayer(controller),
                            ),
                          ),
                        ),
                        if (p.videoUrls[index].shopName != null)
                          PositionAnalyze(data: p.videoUrls[index]),
                        if (p.videoUrls[index].shopName != null)
                          positionTitle(p.videoUrls[index], context, index),
                      ],
                    );
                  },
                ),
                Positioned(
                  top: 20,
                  right: 10,
                  left: 10,

                  child: itemBackAndTitle(context, title: "Reels".tr() , color: white),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
