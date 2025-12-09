import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/model/response/seller/ads_response.dart';
import 'package:fils/screen/Buyer/check_out/web_view_payment.dart';
import 'package:fils/screen/general/edit_crob_filter_image.dart';
import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/global_function/unit8list.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdsNotifire extends ChangeNotifier {
  String? idImage;
  File? imageFile;
  Future selectAndUploadImage() async {
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
      imageFile = await uploadImage();
    } else {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      }
    }

    if (imageFile != null) {
      notifyListeners();
      final edited = await Navigator.push(
        NavigationService.navigatorKey.currentContext!,
        MaterialPageRoute(
          builder:
              (_) =>
                  FullImageEditorScreen(imageFile: imageFile!, isShops: true),
        ),
      );

      if (edited != null) {
        imageFile = await uint8ListToFile(edited, "${DateTime.now()}.png");
        uploadImageServer(imageFile!);
      } else {
        clearImage();
      }
    } else {
      clearImage();
    }
    notifyListeners();
  }

  clearImage() {
    imageFile = null;
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
      } else {
        idImage = json['data']['id'].toString();
      }
    });
  }

  Future<void> subscribeAds(Datum e, BuildContext ctx) async {
    if (e.productId != null) {
      showBoatToast();
      final json = await NetworkHelper.sendRequest(
        requestType: RequestType.post,
        endpoint: "ads-area/purchase",
        fields: {
          "ads_area_id": e.id,
          "product_id": e.productId,
          "cover_image": e.idImage,
          "days_count": e.countDay,
        },
      );
      closeAllLoading();
      if (!json.containsKey("errorMessage")) {
        ToWithFade(ctx, PaymentWebView(urlPayment: json['link']));
      }
    } else {
      showCustomFlash(
        message: "Select Product For Ads".tr(),
        messageType: MessageType.Faild,
      );
    }
  }
}
