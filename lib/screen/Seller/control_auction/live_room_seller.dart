// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/screen/Seller/control_auction/bid_section_seller.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/global_function/printer.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:ivs_broadcaster/Broadcaster/Widgets/preview_widget.dart';
import 'package:ivs_broadcaster/helpers/enums.dart';
import 'package:ivs_broadcaster/Broadcaster/ivs_broadcaster.dart';
import 'package:provider/provider.dart';

import '../../Buyer/root_app/dialog_root.dart';

class LiveRoomSeller extends StatefulWidget {
  final String streamKey;
  final String rtmpUrl;
  final String auctionName;
  final dynamic auctionId;
  bool isLive;
  bool isPaused;

  LiveRoomSeller({
    super.key,
    required this.streamKey,
    required this.rtmpUrl,
    required this.auctionName,
    required this.auctionId,
    required this.isLive,
    required this.isPaused,
  });

  @override
  State<LiveRoomSeller> createState() => _LiveRoomSellerState();
}

class _LiveRoomSellerState extends State<LiveRoomSeller> {
  IvsBroadcaster? ivsBroadcaster;
  CameraType cameraType = CameraType.BACK;
  bool isStreaming = false;

  _startPreview() async {
    await ivsBroadcaster
        ?.startPreview(imgset: widget.rtmpUrl, streamKey: widget.streamKey)
        .then((value) {
          _toggleLive();
        });
  }

  _changeCamera() async {
    print("cameraType $cameraType");
    if (cameraType == CameraType.FRONT) {
      await ivsBroadcaster?.changeCamera(CameraType.BACK);
      cameraType = CameraType.BACK;
    } else {
      await ivsBroadcaster?.changeCamera(CameraType.FRONT);
      cameraType = CameraType.FRONT;
    }
    setState(() {});
  }

  _toggleLive() async {
    if (isStreaming) {
      await ivsBroadcaster?.stopBroadcast();
      printGreen("//////////// stop Live");
    } else {
      await ivsBroadcaster?.startBroadcast();

      printGreen("//////////// start Live");
    }
    setState(() {
      isStreaming = !isStreaming;
    });
    _togglePauseLive();
  }

  _exitLive() async {
    showBoatToast();
    changeDomain1();

    final json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "auction/stream/${widget.auctionId}/stop-live-stream",
    );
    closeAllLoading();
    changeDomain2();
    if (!json.containsKey("errorMessage")) {
      ivsBroadcaster?.stopBroadcast();
    }
  }

  _togglePauseLive() async {
    showBoatToast();
    changeDomain1();
    final json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "auction/stream/${widget.auctionId}/toggle-pause-live-stream",
    );
    closeAllLoading();
    changeDomain2();
  }

  @override
  void initState() {
    super.initState();
    ivsBroadcaster = IvsBroadcaster.instance;
    Future.microtask(() => _startPreview());
  }

  @override
  void dispose() {
    _exitLive();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {

      // showDialogExitLive(context);

      },
      child: Scaffold(
        body: Stack(
          children: [
            RotatedBox(
              quarterTurns: cameraType == CameraType.FRONT ? 3 : 1,
              child: const BroadcaterPreview(),
            ),
            Positioned(
              top: 50,
              left: 20,
              child: Row(
                children: [
                  Text(
                    widget.auctionName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (isStreaming)
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.4, end: 1),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      builder: (context, value, child) {
                        return Opacity(opacity: value, child: child);
                      },
                      onEnd: () {
                        setState(() {});
                      },
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Positioned(
                bottom: 20,
                child: SizedBox(
                  width: width,
                  height: heigth * 0.4,
                  child: BidsSectionSeller(
                    id: widget.auctionId,
                    name: widget.auctionName,
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Directionality(
          textDirection: TextDirection.ltr,
          child: SpeedDial(
            icon: Icons.menu,
            backgroundColor: Colors.black87,
            foregroundColor: Colors.white,
            activeIcon: Icons.close,
            overlayOpacity: 0.5,
            spaceBetweenChildren: 12,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.volume_off),
                label: "Mute / Unmute".tr(),
                onTap: () {
                  ivsBroadcaster?.toggleMute();
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.cameraswitch),
                label: "Switch camera".tr(),
                onTap: _changeCamera,
              ),
              SpeedDialChild(
                child: Icon(isStreaming ? Icons.stop : Icons.play_arrow),
                label: isStreaming ? "Stop Live".tr() : "Start Live".tr(),
                onTap: _toggleLive,
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}
