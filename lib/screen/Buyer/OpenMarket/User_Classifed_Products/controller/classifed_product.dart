import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/model/response/base_response.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/message_app/toast_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fils/model/response/category_response.dart';
import '../../../../../utils/NavigatorObserver/Navigator_observe.dart';

import '../../../../../utils/enum/request_type.dart';
import '../../../../../utils/global_function/loading_widget.dart';

import '../../../../../utils/global_function/unit8list.dart';
import '../../../../../utils/http/http_helper.dart';
import '../../../../../utils/theme/color_manager.dart';
import '../../../../../widget/defulat_text.dart';

import '../../../../general/edit_crob_filter_image.dart';
import '../../../../general/edit_vedio.dart';
import '../screen/all_product-in_market_open.dart';

class ClassifiedProductNotifire extends ChangeNotifier {
  TextEditingController nameProductOpenMarket = TextEditingController();
  TextEditingController priceProductOpenMarket = TextEditingController();
  TextEditingController descountProductOpenMarket = TextEditingController();
  TextEditingController quantityProductOpenMarket = TextEditingController();
  TextEditingController descriptionProductOpenMarket = TextEditingController();
  TextEditingController locationProductOpenMarket = TextEditingController();
  int? categoryIdOpenMarket;
  String? categoryNameOpenMarket = "Add Category".tr();

  String? idImageLogo;

  File? imageFileOpenMarket;
  List<File> imageFilesListOpenMarket = [];
  dynamic selectImageOpenMarket = -1;
  File? videoFile;

  String? videoUrl;
  List<String> idImagesLogoOpenMarket = [];

  void selectAndUploadVideo() async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: NavigationService.navigatorKey.currentContext!,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const DefaultText("اختر مصدر الفيديو"),
          actions: <Widget>[
            TextButton(
              child: DefaultText('Gallery'.tr(), color: secondColor),
              onPressed: () {
                Navigator.of(context).pop(ImageSource.gallery);
              },
            ),
            TextButton(
              child: DefaultText('Camera'.tr(), color: secondColor),
              onPressed: () {
                Navigator.of(context).pop(ImageSource.camera);
              },
            ),
          ],
        );
      },
    );

    if (source == null) return;

    final picker = ImagePicker();
    XFile? pickedFile;

    if (source == ImageSource.gallery) {
      pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    } else {
      pickedFile = await picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(seconds: 30),
      );
    }

    if (pickedFile != null) {
      videoFile = File(pickedFile.path);

      final fileEdit = await Navigator.push(
        NavigationService.navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (_) => FileBasedVideoEditScreen(videoFile: videoFile!),
        ),
      );
      await uploadVideoServer(fileEdit);
    } else {
      print('لم يتم اختيار أي فيديو');
    }
  }

  uploadVideoServer(File file) async {
    Future.delayed(const Duration(seconds: 1), () async {
      showBoatToast();
      final json = await NetworkHelper.sendRequest(
        requestType: RequestType.post,
        endpoint: "file/upload",
        files: {"aiz_file": file},
      );
      closeAllLoading();
      if (json.containsKey("errorMessage")) {
        clearVideo();
      } else {
        videoUrl = json['data']['url'].toString();
      }
    });
  }

  clearVideo() {
    videoFile = null;
    notifyListeners();
  }

  void clearImageOpenMarket() {
    imageFileOpenMarket = null;
    notifyListeners();
  }

  changeListCategoryOpenMarket(Datum item) {
    categoryIdOpenMarket = item.id;
    categoryNameOpenMarket = item.name;

    notifyListeners();
  }

  Future<List<File>> uploadMultiImageOpenMarket() async {
    try {
      final picker = ImagePicker();
      final List<XFile> pickedFiles = await picker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        return pickedFiles.map((file) => File(file.path)).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }

    return [];
  }

  void selectAndUploadImagesOpenMarket() async {
    List<File> imageFiles = await uploadMultiImage();
    if (imageFiles.isNotEmpty) {
      imageFilesListOpenMarket.addAll(imageFiles);
      notifyListeners();
    } else {}
    uploadImagesServerOpenMarket();
  }

  Future<List<File>> uploadMultiImage() async {
    try {
      final picker = ImagePicker();
      final List<XFile> pickedFiles = await picker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        return pickedFiles.map((file) => File(file.path)).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }

    return [];
  }

  uploadImagesServerOpenMarket() async {
    Future.delayed(const Duration(seconds: 1), () async {
      for (var element in imageFilesListOpenMarket) {
        showBoatToast();
        final json = await NetworkHelper.sendRequest(
          requestType: RequestType.post,
          endpoint: "file/upload",
          files: {"aiz_file": element},
        );
        idImagesLogoOpenMarket.add(json['data']['id'].toString());
        closeAllLoading();
      }
    });
    closeAllLoading();
  }

  deleteImageSelectOpenMarket(index) {
    if (imageFilesListOpenMarket.length == 1) {
      imageFilesListOpenMarket.clear();
      selectImageOpenMarket = -1;
      notifyListeners();
    } else {
      for (dynamic i = 0; i < imageFilesListOpenMarket.length; i++) {
        if (i == index) {
          imageFilesListOpenMarket.removeAt(i);
          selectImageOpenMarket = -1;
          notifyListeners();
          break;
        }
      }
    }
  }

  changeIndexSelectImageOpenMarket(dynamic index) {
    selectImageOpenMarket = index;
    notifyListeners();
  }

  uploadImageServer(File file) async {
    Future.delayed(const Duration(seconds: 1), () async {
      showBoatToast();
      final json = await NetworkHelper.sendRequest(
        requestType: RequestType.post,
        endpoint: "file/upload",
        files: {"aiz_file": file},
      );
      closeAllLoading();
      if (json.containsKey("errorMessage")) {
        clearImageOpenMarket();
      } else {
        idImageLogo = json['data']['id'].toString();
      }
    });
  }

  void selectAndUploadImage() async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: NavigationService.navigatorKey.currentContext!,
      builder: (context) {
        return CupertinoAlertDialog(
          actions: <Widget>[
            TextButton(
              child: DefaultText('Gallery'.tr(), color: secondColor),
              onPressed: () async {
                Navigator.of(context).pop(ImageSource.gallery);
              },
            ),
            TextButton(
              child: DefaultText('Camera'.tr(), color: secondColor),
              onPressed: () {
                Navigator.pop(context, ImageSource.camera);
              },
            ),
          ],
        );
      },
    );

    if (source == null) return;

    if (source == ImageSource.gallery) {
      imageFileOpenMarket = (await uploadImage())!;
    } else {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        imageFileOpenMarket = File(pickedFile.path);
      }
    }

    if (imageFileOpenMarket != null) {
      final edited = await Navigator.push(
        NavigationService.navigatorKey.currentContext!,
        MaterialPageRoute(
          builder:
              (_) => FullImageEditorScreen(imageFile: imageFileOpenMarket!),
        ),
      );

      if (edited != null) {
        imageFileOpenMarket = await uint8ListToFile(
          edited,
          "${DateTime.now()}.png",
        );
        uploadImageServer(imageFileOpenMarket!);
      } else {
        clearImageOpenMarket();
      }
    } else {
      clearImageOpenMarket();
    }
  }

  addProductOpenMarket(BuildContext context) async {
    String result = idImagesLogoOpenMarket.join(",");
    showBoatToast();
    final json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "classified/store",
      fields: {
        "name": nameProductOpenMarket.text,
        "brand_id": "1",
        "unit": "PC",
        "tags": [
          "[{\"value\": \"mobile\"}, {\"value\": \"tech\"}, {\"value\": \"fashion\"}]",
        ],
        "photos": result,
        "thumbnail_img": idImageLogo,
        "video_provider": "youtube",
        "video_link": videoUrl,
        "unit_price": priceProductOpenMarket.text,
        "discount": descountProductOpenMarket.text,
        "discount_type": "percent",
        "current_stock": quantityProductOpenMarket.text,
        "description": descriptionProductOpenMarket.text,
        "category_id": categoryIdOpenMarket,
        "location": locationProductOpenMarket.text,
        "conditon": "used",
      },
    );

    closeAllLoading();
    if (json.containsKey("errorMessage")) {
    } else {
      BaseResponse base = BaseResponse.fromJson(json);
      showToastMessage(base.message, messageType: MessageType.Success);
      Navigator.pop(context);
      marketOpenController.update();
    }
  }

  @override
  void dispose() {
    nameProductOpenMarket.dispose();
    priceProductOpenMarket.dispose();
    descountProductOpenMarket.dispose();
    quantityProductOpenMarket.dispose();
    descriptionProductOpenMarket.dispose();
    locationProductOpenMarket.dispose();
    categoryIdOpenMarket = null;
    categoryNameOpenMarket = "Add Category".tr();
    imageFileOpenMarket = null;
    imageFilesListOpenMarket = [];
    selectImageOpenMarket = -1;
    idImagesLogoOpenMarket = [];
    super.dispose();
  }
}
