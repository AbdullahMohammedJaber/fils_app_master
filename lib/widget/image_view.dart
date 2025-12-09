// // ignore_for_file: unused_import, avoid_print, prefer_interpolation_to_compose_strings, unused_field, prefer_final_fields
//
// import 'dart:io';
//
// import 'package:dio/dio.dart';
//
// import 'package:easy_localization/easy_localization.dart';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fils/utils/message_app/show_flash_message.dart';
//
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:photo_view/photo_view_gallery.dart';
// import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
//
// import '../utils/theme/color_manager.dart';
//
// class ImageView extends StatefulWidget {
//   final dynamic image;
//
//   const ImageView({super.key, this.image});
//
//   @override
//   State<ImageView> createState() => _ImageViewState();
// }
//
// class _ImageViewState extends State<ImageView> {
//   late ProgressDialog _progressDialog;
//   bool _downloading = false;
//
//   @override
//   void initState() {
//     _progressDialog = ProgressDialog(context);
//
//     super.initState();
//   }
//
//   /*Future<void> downloadFile(String fileUrl, String fileName) async {
//     await Permission.storage.request();
//     Dio dio = Dio();
//     try {
//       _downloading = true;
//       _progressDialog.show();
//       setState(() {});
//       var response = await dio
//           .get(fileUrl, options: Options(responseType: ResponseType.bytes));
//       final result = await ImageGallerySaver.saveImage(
//           Uint8List.fromList(response.data),
//           quality: 100,
//           name: DateTime.now().toString());
//
//       // Directory appDocDir = await getExternalStorageDirectory();
//       //
//       // print('File downloaded to: $appDocDir');
//       // String savePath = appDocDir.path + '/' + fileName;
//       // await dio.download(fileUrl, savePath);
//       // print('File downloaded to: $savePath');
//       _downloading = false;
//       _progressDialog.hide();
//       setState(() {});
//     } catch (e) {
//       _downloading = false;
//       _progressDialog.hide();
//       setState(() {});
//       print('Error downloading file: $e');
//     }
//   }*/
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.close,
//             color: white,
//           ),
//         ),
//
//         /*actions: [
//           IconButton(
//             onPressed: () async {
//               downloadFile(widget.image, DateTime.now().toString());
//             },
//             icon: Icon(
//               Icons.download,
//               color: white,
//             ),
//           ),
//         ],*/
//       ),
//       body: PhotoViewGallery.builder(
//         scrollPhysics: const BouncingScrollPhysics(),
//         builder: (BuildContext context, dynamic index) {
//           return PhotoViewGalleryPageOptions(
//             imageProvider: (widget.image is File
//                 ? FileImage(widget.image)
//                 : NetworkImage(widget.image)) as ImageProvider<Object>?,
//             initialScale: PhotoViewComputedScale.contained * 0.8,
//             heroAttributes: PhotoViewHeroAttributes(tag: widget.image),
//           );
//         },
//         itemCount: 1,
//         loadingBuilder: (context, event) => Center(
//           child: SizedBox(
//             width: 20.0,
//             height: 20.0,
//             child: CircularProgressIndicator(
//               value: event == null
//                   ? 0
//                   : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
//             ),
//           ),
//         ),
//         // backgroundDecoration: widget.backgroundDecoration,
//         // pageController: widget.pageController,
//       ),
//     );
//   }
// }
