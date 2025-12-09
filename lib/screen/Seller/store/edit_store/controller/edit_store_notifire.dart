// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:fils/controller/provider/store_notofire.dart';
import 'package:fils/screen/Seller/home/home_seller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../model/response/base_response.dart';
import '../../../../../utils/NavigatorObserver/Navigator_observe.dart';
import '../../../../../utils/const.dart';
import '../../../../../utils/enum/message_type.dart';
import '../../../../../utils/enum/request_type.dart';
import '../../../../../utils/global_function/loading_widget.dart';
import '../../../../../utils/global_function/unit8list.dart';
import '../../../../../utils/http/http_helper.dart';
import '../../../../../utils/message_app/show_flash_message.dart';
import '../../../../../utils/storage/storage.dart';
import '../../../../general/edit_crob_filter_image.dart';

class EditStoreNotifire extends ChangeNotifier {
  TextEditingController nameStore = TextEditingController();
  TextEditingController addressStore = TextEditingController();
  TextEditingController licenseNumber = TextEditingController();
  TextEditingController idNumber = TextEditingController();
  TextEditingController dec = TextEditingController();
  String? logoUrl;
  dynamic idImageLogo;
  File? imageFile;
  File? fileLicense;

  EditStoreNotifire() {
    nameStore.text = getShopInfo().data!.name;
    if (getShopInfo().data!.description.toString() == "null" ||
        getShopInfo().data!.description == null) {
      dec.clear();
    } else {
      dec.text = getShopInfo().data!.description.toString();
    }

    addressStore.text = getShopInfo().data!.address;
    logoUrl = getShopInfo().data!.logo ?? "";
    idImageLogo = getShopInfo().data!.uploadId;
  }

  void selectAndUploadImage() async {
    imageFile = await uploadImage();

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
      imageFile = await uint8ListToFile(edited, "${DateTime.now()}.png");
      if (edited != null) {
        uploadImageServer(imageFile!);
      }
    } else {}
    notifyListeners();
  }

  void selectAndUploadFile() async {
    fileLicense = await uploadFile();
    if (fileLicense != null) {
      print(fileLicense.toString());
      notifyListeners();
    } else {}
    notifyListeners();
  }

  clearImage() {
    imageFile = null;
    logoUrl = null;
    notifyListeners();
  }

  clearImageL() {
    fileLicense = null;
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
        clearImage();
      } else {
        idImageLogo = json['data']['id'];
      }
    });
  }

  functionEditDataStore(BuildContext context) async {
    showBoatToast();
    final json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "shop-update/${getAllShop().id}",
      fields: {
        "name": nameStore.text,
        "address": addressStore.text,
        if (licenseNumber.text.isNotEmpty) "license_no": licenseNumber.text,
        "owner_name": getUser()!.user!.name,
        "logo": idImageLogo,
        "id_number": idNumber.text,
        "description": dec.text,
      },
      files: {if (fileLicense != null) "tax_papers": fileLicense!},
    );
    closeAllLoading();

    if (json.containsKey("errorMessage")) {
    } else {
      Navigator.pop(context);
      BaseResponse base = BaseResponse.fromJson(json);
      showCustomFlash(message: base.message, messageType: MessageType.Success);

      await context.read<StoreNotifire>().functionGetDataStore(isGetComplete: true);
      homeUpdate.update();
    }
  }

  @override
  void dispose() {
    nameStore.dispose();
    addressStore.dispose();
    licenseNumber.dispose();
    idImageLogo = null;
    imageFile = null;
    fileLicense = null;
    logoUrl = null;
    super.dispose();
  }
}
