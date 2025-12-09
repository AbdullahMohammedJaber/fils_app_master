import 'dart:io';

import 'package:fils/model/response/base_response.dart';
import 'package:fils/screen/Seller/Subscriptions/subscriptions_screen.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import '../../../../../controller/provider/store_notofire.dart';
import '../../../../../utils/NavigatorObserver/Navigator_observe.dart';
import '../../../../../utils/const.dart';
import '../../../../../utils/enum/request_type.dart';
import '../../../../../utils/global_function/loading_widget.dart';
import '../../../../../utils/global_function/unit8list.dart';
import '../../../../../utils/http/http_helper.dart';
import '../../../../general/edit_crob_filter_image.dart';
import '../../../../general/root_app.dart';
import '../../../home/home_seller.dart';

class CreateStoreNotifire extends ChangeNotifier {
  TextEditingController nameStoreC = TextEditingController();
  TextEditingController addressStoreC = TextEditingController();
  TextEditingController licenseNumberC = TextEditingController();
  TextEditingController contactNumberC = TextEditingController();
  TextEditingController passportNumberC = TextEditingController();
  TextEditingController ownerNameC = TextEditingController();
  TextEditingController dec = TextEditingController();
  int typeStore = 1; // 1 home , 2 store
  dynamic idImageLogoC;
  File? imageFileC;
  File? fileLicenseC;

  void selectAndUploadImageC() async {
    imageFileC = await uploadImage();

    if (imageFileC != null) {
      notifyListeners();
      final edited = await Navigator.push(
        NavigationService.navigatorKey.currentContext!,
        MaterialPageRoute(
          builder:
              (_) =>
                  FullImageEditorScreen(imageFile: imageFileC!, isShops: true),
        ),
      );
      imageFileC = await uint8ListToFile(edited, "${DateTime.now()}.png");
      if (edited != null) {
        uploadImageServerC(imageFileC!);
      }
    } else {
      imageFileC = null;
    }
    notifyListeners();
  }

  void selectAndUploadFileC() async {
    fileLicenseC = await uploadFile();
    if (fileLicenseC != null) {
      notifyListeners();
    } else {}
    notifyListeners();
  }

  uploadImageServerC(File file) async {
    changeDomain2(isCustomerToSeller: true);
    Future.delayed(const Duration(seconds: 1), () async {
      showBoatToast();
      final json = await NetworkHelper.sendRequest(
        requestType: RequestType.post,
        endpoint: "file/upload",
        files: {"aiz_file": file},
      );
      closeAllLoading();
      changeDomain2();
      if (json.containsKey("errorMessage")) {
        clearImageCreate();
      } else {
        idImageLogoC = json['data']['id'];
      }
    });
  }

  clearImageCreate() {
    imageFileC = null;
    notifyListeners();
  }

  changeTypeStore(int type) {
    typeStore = type;
    notifyListeners();
  }

  createStoreFunction(bool isComeSignup) async {
    showBoatToast();
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "shop-store",
      fields: {
        "name": nameStoreC.text,
        "address": addressStoreC.text,
        "description": dec.text,
        if (licenseNumberC.text.isNotEmpty) "license_no": licenseNumberC.text,
        "owner_name": getUser()!.user!.name,
        "phone": getUser()!.user!.phone!,
        "logo": idImageLogoC,
        "id_number": passportNumberC.text,
      },

      files: fileLicenseC != null ? {"tax_papers": fileLicenseC!} : {},
    );
    closeAllLoading();
    if (json.containsKey("errorMessage")) {
    } else {
      BaseResponse base = BaseResponse.fromJson(json);
      showCustomFlash(message: base.message, messageType: MessageType.Success);
      if (isComeSignup) {
        GetStorage().remove("shops");
        GetStorage().remove("PackageInfoResponse");
        GetStorage().remove("checkShop");
        GetStorage().remove("shopInfo");
        ToRemove(
          NavigationService.navigatorKey.currentContext!,
          SubscriptionsScreen(typeStore: typeStore),
        );
      }
    }
  }

  @override
  void dispose() {
    nameStoreC.dispose();
    addressStoreC.dispose();
    licenseNumberC.dispose();
    contactNumberC.dispose();
    passportNumberC.dispose();
    ownerNameC.dispose();
    idImageLogoC = null;
    imageFileC = null;
    fileLicenseC = null;
    super.dispose();
  }
}
