// // ignore_for_file: use_build_context_synchronously
//
// import 'package:camera/camera.dart';
// import 'package:fils/utils/enum/request_type.dart';
// import 'package:fils/utils/global_function/printer.dart';
// import 'package:fils/utils/http/http_helper.dart';
// import 'package:fils/utils/http/service.dart';
// import 'package:fils/utils/storage/storage.dart';
// import 'package:flutter/material.dart';
// import 'package:ivs_broadcaster/Broadcaster/ivs_broadcaster.dart';
// import 'package:ivs_broadcaster/helpers/enums.dart';
//
// class LiveNotifire with ChangeNotifier {
//   IvsBroadcaster ivsBroadcaster = IvsBroadcaster.instance;
//   CameraController? cameraController;
//   List<CameraDescription>? cameras;
//   bool isFrontCamera = false;
//   bool isCameraDisposed = false;
//   bool isStreaming = false;
//   bool isMuted = false;
//   late String rtmpUrlProvider;
//   late String streamKeyProvider;
//
//   LiveNotifire({required String rtmpUrl, required String streamKey}) {
//     printGreen("////////// start provider ");
//     rtmpUrlProvider = rtmpUrl;
//     streamKeyProvider = streamKey;
//
//     initCamera().then(
//           (value) {
//         initializeAndStartBroadcast();
//       },
//     );
//   }
//
//   Future<void> initCamera() async {
//     try {
//       cameras = await availableCameras();
//       if (cameras == null || cameras!.isEmpty) return;
//
//       isCameraDisposed = false;
//       cameraController = CameraController(
//         cameras![isFrontCamera ? 1 : 0],
//         ResolutionPreset.high,
//         enableAudio: true,
//       );
//
//       await cameraController?.initialize();
//       notifyListeners();
//     } catch (e) {
//       debugPrint("Error initializing camera: $e");
//     }
//   }
//
//   void switchCamera() async {
//     if (isCameraDisposed || cameras == null || cameras!.length < 2) return;
//
//     isFrontCamera = !isFrontCamera;
//     await cameraController?.dispose();
//     await initCamera();
//   }
//
//   void toggleStreaming() {
//     if (isStreaming) {
//       ivsBroadcaster.stopBroadcast();
//     } else {
//       initializeAndStartBroadcast();
//     }
//     isStreaming = !isStreaming;
//     notifyListeners();
//   }
//
//   Future<void> initializeAndStartBroadcast() async {
//     ivsBroadcaster = IvsBroadcaster.instance;
//
//     try {
//       printGreen("rtmpUrlProvider: $rtmpUrlProvider");
//       printGreen("streamKeyProvider: $streamKeyProvider");
//
//       if (cameraController != null && cameraController!.value.isInitialized) {
//         await ivsBroadcaster.startPreview(
//           imgset: rtmpUrlProvider,
//           streamKey: streamKeyProvider,
//           cameraType: CameraType.FRONT,
//           quality: IvsQuality.q1080,
//         );
//
//         await ivsBroadcaster.startBroadcast();
//         isStreaming = true;
//         notifyListeners();
//       } else {
//         print("❌ Camera is not initialized yet.");
//       }
//     } catch (e) {
//       print("❌ Error while starting preview: $e");
//     }
//   }
//
//   void toggleMute() {
//     isMuted = !isMuted;
//     ivsBroadcaster.toggleMute();
//     notifyListeners();
//   }
//
//   endLive(BuildContext context, {required dynamic idAuction}) async {
//     changeDomain1();
//     final json = await NetworkHelper.sendRequest(
//       requestType: RequestType.post,
//       endpoint: "auction/stream/$idAuction/stop-live-stream",
//     );
//     if (json.containsKey("errorMessage")) {} else {
//       ivsBroadcaster.stopBroadcast();
//       isCameraDisposed = true;
//       cameraController?.dispose();
//     }
//
//     if (isLogin()) {
//       if (getUser()!.user!.type == "customer") {
//         changeDomain1();
//       } else {
//         domain = 'https://dashboard.fils.app/api/v2/seller';
//       }
//     } else {
//       changeDomain1();
//     }
//   }
//
//   @override
//   void dispose() {
//     ivsBroadcaster.stopBroadcast();
//     isCameraDisposed = true;
//     cameraController?.dispose();
//     super.dispose();
//   }
// }
