// ignore_for_file: prefer_interpolation_to_compose_strings, unnecessary_nullable_for_final_variable_declarations, use_build_context_synchronously, body_might_complete_normally_nullable, unused_local_variable

import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';

import 'package:fils/model/response/base_response.dart';
import 'package:fils/model/response/error_response.dart';

import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/global_function/number_format.dart';
import 'package:fils/utils/global_function/validation.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/widget/dialog_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fils/model/app/variants_model.dart';
import 'package:fils/model/response/attrebute_response.dart';
import 'package:fils/model/response/color_product.dart';
import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/http/http_helper.dart';
import '../../model/response/category_response.dart';
import '../../screen/Seller/Subscriptions/subscriptions_screen.dart';
import '../../screen/general/edit_crob_filter_image.dart';
import '../../screen/general/edit_vedio.dart';
import '../../utils/const.dart';
import '../../utils/global_function/unit8list.dart';
import '../../utils/global_function/update_controller.dart';
import '../../utils/route/route.dart';
import '../../utils/theme/color_manager.dart';
import '../../widget/defulat_text.dart';

class ProductNotifire with ChangeNotifier {
  TextEditingController productName = TextEditingController();
  TextEditingController productStoreName = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  TextEditingController productDiscount = TextEditingController();
  TextEditingController productQuantity = TextEditingController();
  TextEditingController productDetails = TextEditingController();
  TextEditingController productLinkVideo = TextEditingController();
  UpdateController updateControllerProduct = UpdateController();

  File? videoFile;

  String? videoUrl;
  File? imageFile;
  List<File> imageFilesList = [];
  dynamic selectImage = -1;

  ///////////////////////////////////////////////////////////////////////
  void selectAndUploadVideo() async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: NavigationService.navigatorKey.currentContext!,
      builder: (context) {
        return CupertinoAlertDialog(
          title: DefaultText("Select video source".tr()),
          actions: <Widget>[
            TextButton(
              child: DefaultText('Gellary'.tr(), color: secondColor),
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

  //////////////////////////////////////////////////////
  String? idImageLogo;
  List<String> idImagesLogo = [];

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
          builder: (_) => FullImageEditorScreen(imageFile: imageFile!),
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
        clearImage();
      } else {
        idImageLogo = json['data']['id'].toString();
      }
    });
  }

  //////////////////////////////////////////////////////

  Future<List<File>> uploadMultiImage() async {
    try {
      final picker = ImagePicker();
      final List<XFile>? pickedFiles = await picker.pickMultiImage();

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        return pickedFiles.map((file) => File(file.path)).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }

    return [];
  }

  void selectAndUploadImages() async {
    List<File> imageFiles = await uploadMultiImage();
    if (imageFiles.isNotEmpty) {
      imageFilesList.addAll(imageFiles);
      notifyListeners();
    } else {}
    uploadImagesServer();
  }

  uploadImagesServer() async {
    Future.delayed(const Duration(seconds: 1), () async {
      for (var element in imageFilesList) {
        showBoatToast();
        final json = await NetworkHelper.sendRequest(
          requestType: RequestType.post,
          endpoint: "file/upload",
          files: {"aiz_file": element},
        );
        idImagesLogo.add(json['data']['id'].toString());
        closeAllLoading();
      }
    });
    closeAllLoading();
  }

  deleteImageSelect(index) {
    if (imageFilesList.length == 1) {
      imageFilesList.clear();
      selectImage = -1;
      notifyListeners();
    } else {
      for (dynamic i = 0; i < imageFilesList.length; i++) {
        if (i == index) {
          imageFilesList.removeAt(i);
          selectImage = -1;
          notifyListeners();
          break;
        }
      }
    }
  }

  changeIndexSelectImage(dynamic index) {
    selectImage = index;
    notifyListeners();
  }

  //////////////////////////////////////////////////////
  bool switchColor = false;
  bool switchSize = false;
  List<ColorProduct> colorSelect = [];
  List<ColorProduct> colorList = [];
  bool isShowListColor = false;
  bool isShowListSize = false;
  List<Value> sizeSelect = [];
  List<Value> sizeList = [];
  String hintOption = "Add Options (Colors, size)".tr();

  changeHintOption() {
    hintOption = "";
    if (colorSelect.isNotEmpty && sizeSelect.isNotEmpty) {
      hintOption =
          "Color".tr() +
          "${colorSelect.length} " +
          " , " +
          "Size".tr() +
          "${sizeSelect.length} ";
    } else {
      if (colorSelect.isNotEmpty && sizeSelect.isEmpty) {
        hintOption = "Color".tr() + " ${colorSelect.length}";
      } else {
        hintOption = "Size".tr() + " ${sizeSelect.length}";
      }
    }
  }

  changeSwitchColor(bool value) {
    switchColor = value;
    notifyListeners();
    if (switchColor) {
      isShowListColor = false;
      fetchColor();
    } else {
      colorSelect = [];
      colorList = [];
      isShowListColor = false;
    }
  }

  changeSwitchSize(bool value) {
    switchSize = value;
    notifyListeners();
    if (switchSize) {
      isShowListSize = false;
      fetchSize();
    } else {
      sizeSelect = [];
      sizeList = [];
      isShowListSize = false;
    }
  }

  changeShowListColor() {
    isShowListColor = !isShowListColor;
    notifyListeners();
  }

  changeShowListSize() {
    isShowListSize = !isShowListSize;
    notifyListeners();
  }

  selectColorId(ColorProduct color) {
    dynamic index = colorSelect.indexWhere((element) => element.id == color.id);

    if (index != -1) {
      colorSelect[index].isSelect = false;
      colorSelect.removeAt(index);
    } else {
      color.isSelect = true;
      colorSelect.add(color);
    }
    changeHintOption();
    notifyListeners();
  }

  fetchColor() async {
    colorSelect = [];
    colorList = [];
    variantList = [];
    showBoatToast();
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.get,
      endpoint: "products/colors",
    );
    closeAllLoading();
    if (json.containsKey("errorMessage")) {
    } else {
      ColorProductResponse colorProductResponse = ColorProductResponse.fromJson(
        json,
      );
      for (var element in colorProductResponse.data) {
        colorList.add(element);
      }
      notifyListeners();
    }
  }

  fetchSize() async {
    sizeSelect = [];
    sizeList = [];
    variantList = [];
    showBoatToast();
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.get,
      endpoint: "products/attributes",
    );
    closeAllLoading();
    if (json.containsKey("errorMessage")) {
    } else {
      AttrebuteProductResponse attrebuteProductResponse =
          AttrebuteProductResponse.fromJson(json);
      for (var element in attrebuteProductResponse.data) {
        if (element.name == "Size") {
          for (var v in element.values) {
            sizeList.add(v);
          }
        }
      }
      notifyListeners();
    }
  }

  selectSizeId(Value size) {
    dynamic index = sizeSelect.indexWhere((element) => element.id == size.id);

    if (index != -1) {
      sizeSelect[index].isSelect = false;
      sizeSelect.removeAt(index);
    } else {
      size.isSelect = true;
      sizeSelect.add(size);
    }
    changeHintOption();
    notifyListeners();
  }

  //////////////////////////////////////////////////////
  List<VariantsModel> variantList = [];

  addDetailsVariants({
    String? price,
    String? qty,
    String? img,
    String? name,
    File? file,
  }) {
    dynamic index = variantList.indexWhere((element) => element.name == name);
    if (index != -1) {
      variantList.removeAt(index);
      variantList.add(
        VariantsModel(
          name: name,
          qty: qty,
          img: img,
          price: price,
          sku: "null",
          fileImage: file,
        ),
      );
    } else {
      variantList.add(
        VariantsModel(
          name: name,
          qty: qty,
          img: img,
          price: price,
          sku: "null",
          fileImage: file,
        ),
      );
    }
    notifyListeners();
  }

  //////////////////////////////////////////////////////
  List<dynamic> categoryId = [];
  List<String> categoryName = [];
  String category = "Add Category".tr();
  int? categoryIdSelect;
  String categoryNameSelect = "Add Category".tr();

  changeCategoryId(int id, String name) {
    categoryIdSelect = id;
    categoryNameSelect = name;
    notifyListeners();
  }

  changeListCategory(List<Datum> item) {
    categoryId = [];
    categoryName = [];
    categoryId.add(categoryIdSelect);

    category = "";
    if (item.isNotEmpty) {
      for (var element in item) {
        categoryId.add(element.id);
        categoryName.add(element.name);
      }

      for (var element in categoryName) {
        category += element + ' , ';
      }
    }
    notifyListeners();
  }

  //////////////////////////////////////////////////////
  bool checkVaireantList(String name) {
    bool flag = false;
    if (variantList.isNotEmpty) {
      for (var element in variantList) {
        if(element.name == name){
          flag = true;
          break;
        }
      }
    }
    return flag;
  }

  addProduct() async {
    Map<String, dynamic> variantData = {};

    for (var variant in variantList) {
      if (variant.name != null) {
        variantData["price_${variant.name}"] = variant.price;
        variantData["sku_${variant.name}"] = variant.sku;
        variantData["qty_${variant.name}"] = variant.qty;
        variantData["img_${variant.name}"] = variant.img;
      }
    }
    String result = idImagesLogo.join(",");
    showBoatToast();
    final json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "products/add",
      fields: {
        "name": productName.text,
        "brand_id": "1",
        "unit": "PC",
        "weight": "0.00",
        "tags": [
          "[{\"value\": \"mobile\"}, {\"value\": \"tech\"}, {\"value\": \"fashion\"}]",
        ],
        "thumbnail_img": idImageLogo,
        "shop_id": getAllShop().id.toString(),
        "photos": result,
        "video_link": videoUrl,
        "description": productDetails.text,
        "low_stock_quantity": "1",
        "stock_visibility_state": "quantity",
        "cash_on_delivery": "1",
        "est_shipping_days": null,
        "colors_active": colorSelect.isNotEmpty ? "1" : "0",
        "colors":
            colorSelect.isNotEmpty
                ? colorSelect.map((e) {
                  return e.code;
                }).toList()
                : [],
        "choice_attributes": sizeSelect.isNotEmpty ? ["1"] : [],
        "choice_no": sizeSelect.isNotEmpty ? ["1"] : [],
        "choice": sizeSelect.isNotEmpty ? ["Size"] : [],
        if (sizeSelect.isNotEmpty)
          "choice_options_1":
              sizeSelect.map((e) {
                return e.value;
              }).toList(),
        "unit_price": productPrice.text,
        "date_range": null,
        "discount":
            productDiscount.text.isEmpty
                ? 0
                : extractDouble(productDiscount.text),
        "discount_type": "percent",
        "current_stock": productQuantity.text,
        "category_ids":
            categoryId.map((e) {
              return e;
            }).toList(),
        "category_id": categoryIdSelect,
        "auction_type": "normal",
        "min_qty": "1",
        "lang": getLocal() ?? "sa",
        if (variantList.isNotEmpty) ...variantData,
      },
    );
    closeAllLoading();
    log("json ${json.toString()}");
    if (json.containsKey("errorMessage")) {
      showCustomFlash(
        message: json['errorMessage'],
        messageType: MessageType.Faild,
      );
    } else {
      ErrorResponse errorResponse = ErrorResponse.fromJson(json);
      showCustomFlash(
        message: errorResponse.errorMessage,
        messageType: MessageType.Success,
      );

      idImageLogo = null;
      colorSelect = [];
      sizeSelect = [];
      variantList = [];
      categoryId = [];
      category = "Add Category".tr();
      categoryName = [];
      videoFile = null;
      videoUrl = null;
      imageFile = null;
      imageFilesList = [];
      selectImage = -1;
      switchSize = false;
      switchColor = false;
      isShowListColor = false;
      isShowListSize = false;
      colorList = [];
      sizeList = [];
      idImagesLogo = [];
      hintOption = "Add Options (Colors, size)".tr();
      productDetails.clear();
      productQuantity.clear();
      category = "Add Category".tr();
      categoryNameSelect = "Add Category".tr();
      categoryIdSelect = null;
      productDiscount.clear();
      productPrice.clear();
      productName.clear();
      Navigator.pop(NavigationService.navigatorKey.currentContext!);
      updateControllerProduct.update();
    }
  }

  //////////////////////////////////////////////////////
  deleteProduct(BuildContext context, {required dynamic idProduct}) async {
    customDialog(
      context,
      title: "Delete Product".tr(),
      onTap: () async {
        Navigator.pop(context);
        showBoatToast();
        final json = await NetworkHelper.sendRequest(
          requestType: RequestType.get,
          endpoint: "product/delete/$idProduct",
        );
        closeAllLoading();
        BaseResponse base = BaseResponse.fromJson(json);
        showCustomFlash(
          message: base.message,
          messageType: MessageType.Success,
        );

        updateControllerProduct.update();

        Navigator.pop(context);
      },
      titleButton: "Delete".tr(),
      body: "Are you sure you want to delete the product?".tr(),
    );
  }

  @override
  void dispose() {
    print("disposed Called ==================>");
    productName.dispose();
    productStoreName.dispose();
    productPrice.dispose();
    productDiscount.dispose();
    productQuantity.dispose();
    productDetails.dispose();
    productLinkVideo.dispose();

    super.dispose();
  }
}
