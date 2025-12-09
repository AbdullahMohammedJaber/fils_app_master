// ignore_for_file: prefer_interpolation_to_compose_strings, unused_local_variable

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/model/app/variants_model.dart';
import 'package:fils/model/response/attrebute_response.dart';
import 'package:fils/model/response/category_response.dart';
import 'package:fils/model/response/color_product.dart';
import 'package:fils/model/response/seller/details_product_seller.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/global_function/printer.dart';
import 'package:fils/utils/global_function/validation.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/const.dart';
import '../../utils/global_function/number_format.dart';

class EditProductNotifire with ChangeNotifier {
  EditProductNotifire(DetailsProductSeller detailsProductSellerResponse) {
    fetchCategory(detailsProductSellerResponse);
    productNameEdit.text = detailsProductSellerResponse.productName;
    productStoreNameEdit.text = detailsProductSellerResponse.shopName;
    productLinkVideoEdit.text = detailsProductSellerResponse.videoLink ?? "";
    productPriceEdit.text = detailsProductSellerResponse.unitPrice.toString();
    productDiscountEdit.text = detailsProductSellerResponse.discount.toString();
    productQuantityEdit.text =
        detailsProductSellerResponse.currentStock.toString();
    productDetailsEdit.text = detailsProductSellerResponse.description;
    idImageProductEdit = detailsProductSellerResponse.thumbnailImg.data[0].id;
    thumbnailImgUrl = detailsProductSellerResponse.thumbnailImg.data[0].url;

    idImagesLogoEdit = [];
    imageUrlListEdit = [];
    imageFilesListEdit = [];
    categoryId = [];
    categoryName = [];
    category = "Add Category".tr();
    categoryIdSelect = null;
    categoryNameSelect = "Add Category".tr();
    imageFileEdit = null;
    if (detailsProductSellerResponse.colors.isNotEmpty) {
      switchColor = true;
      isShowListColor = true;
      fetchColor();
    }
    if (detailsProductSellerResponse.choiceOptions.isNotEmpty) {
      switchSize = true;
      isShowListSize = true;
    }
    if (detailsProductSellerResponse.photos.data.isNotEmpty) {
      for (var element in detailsProductSellerResponse.photos.data) {
        idImagesLogoEdit.add(element.id.toString());
        imageUrlListEdit.add(element.url);
      }
    }
    idImagesLogoEdit.removeLast();
    if (detailsProductSellerResponse.variantProduct == 1) {
      for (var element in detailsProductSellerResponse.stocks.data) {
        variantList.add(
          VariantsModel(
            name: element.variant,
            price: element.price.toString(),
            sku: element.sku.toString(),
            qty: element.qty.toString(),
            img: element.image.data[0].id.toString(),
          ),
        );
      }
    }
  }

  TextEditingController productNameEdit = TextEditingController();
  TextEditingController productStoreNameEdit = TextEditingController();
  TextEditingController productPriceEdit = TextEditingController();
  TextEditingController productDiscountEdit = TextEditingController();

  TextEditingController productQuantityEdit = TextEditingController();
  TextEditingController productDetailsEdit = TextEditingController();
  TextEditingController productLinkVideoEdit = TextEditingController();

  late dynamic idImageProductEdit;
  late String thumbnailImgUrl;
  File? imageFileEdit;
  List<File> imageFilesListEdit = [];
  List<String> imageUrlListEdit = [];
  List<String> idImagesLogoEdit = [];
  dynamic selectImageEdit = -1;
  late CategoryResponse categoryResponse;

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

  ///////////////////////////////////////////////////////////

  void selectAndUploadImageEdit() async {
    imageFileEdit = await uploadImage();
    if (imageFileEdit != null) {
      notifyListeners();

      uploadImageServerEdit();
    } else {}
    notifyListeners();
  }

  clearImageEdit() {
    if (imageFileEdit == null) {
      thumbnailImgUrl = "";
    } else {
      imageFileEdit = null;
    }

    notifyListeners();
  }

  uploadImageServerEdit() async {
    Future.delayed(const Duration(seconds: 1), () async {
      showBoatToast();
      final json = await NetworkHelper.sendRequest(
        requestType: RequestType.post,
        endpoint: "file/upload",
        files: {"aiz_file": imageFileEdit!},
      );
      closeAllLoading();
      if (json.containsKey("errorMessage")) {
        clearImageEdit();
      } else {
        idImageProductEdit = int.parse(json['data']['id'].toString());
      }
    });
  }

  ////////////////////////////////////////////////////////////
  void selectAndUploadImagesEdit() async {
    List<File> imageFiles = await uploadMultiImage();
    if (imageFiles.isNotEmpty) {
      imageFilesListEdit.addAll(imageFiles);
      notifyListeners();
    } else {}
    uploadImagesServerEdit();
  }

  uploadImagesServerEdit() async {
    Future.delayed(const Duration(seconds: 1), () async {
      for (var element in imageFilesListEdit) {
        showBoatToast();
        final json = await NetworkHelper.sendRequest(
          requestType: RequestType.post,
          endpoint: "file/upload",
          files: {"aiz_file": element},
        );
        idImagesLogoEdit.add(json['data']['id'].toString());
        closeAllLoading();
      }
    });
  }

  deleteImageSelectEdit(index , bool isFile) {

    if(isFile){
    if (imageFilesListEdit.length == 1) {
      imageFilesListEdit.clear();
      selectImageEdit = -1;
      notifyListeners();
    } else {
      for (dynamic i = 0; i < imageFilesListEdit.length; i++) {
        if (i == index) {
          imageFilesListEdit.removeAt(i);
          selectImageEdit = -1;
          notifyListeners();
          break;
        }
      }
    }}
    else{
      if (imageUrlListEdit.length == 1) {
        imageUrlListEdit.clear();
        selectImageEdit = -1;
        notifyListeners();
      } else {
        for (dynamic i = 0; i < imageUrlListEdit.length; i++) {
          if (i == index) {
            imageUrlListEdit.removeAt(i);
            selectImageEdit = -1;
            notifyListeners();
            break;
          }
        }
      }
    }
  }

  Future<List<File>> uploadMultiImage() async {
    try {
      final picker = ImagePicker();
      final List<XFile> pickedFiles = await picker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        return pickedFiles.map((file) => File(file.path)).toList();
      }
    } catch (e) {}

    return [];
  }

  changeIndexSelectImageEdit(dynamic index) {
    selectImageEdit = index;
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////
  List<VariantsModel> variantList = [];
  bool switchColor = false;
  bool switchSize = false;
  List<ColorProduct> colorSelect = [];
  List<ColorProduct> colorList = [];
  bool isShowListColor = false;
  bool isShowListSize = false;
  List<Value> sizeSelect = [];
  List<Value> sizeList = [];
  String hintOption = "Add Options (Colors, size)".tr();

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

  changeShowListColor() {
    isShowListColor = !isShowListColor;
    notifyListeners();
  }

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

  changeShowListSize() {
    isShowListSize = !isShowListSize;
    notifyListeners();
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

  ////////////////////////////////////////////////////////////
  editProduct(BuildContext context, dynamic id) async {
    showBoatToast();
    Map<String, dynamic> variantData = {};

    for (var variant in variantList) {
      if (variant.name != null) {
        variantData["price_${variant.name}"] = variant.price;
        variantData["sku_${variant.name}"] = variant.sku;
        variantData["qty_${variant.name}"] = variant.qty;
        variantData["img_${variant.name}"] = variant.img;
      }
    }
    String result = idImagesLogoEdit.join(",");
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "products/update/$id",
      fields: {
        "name": productNameEdit.text,
        "brand_id": "1",
        "unit": "PC",
        "weight": "0.00",
        "tags": [
          "[{\"value\": \"mobile\"}, {\"value\": \"tech\"}, {\"value\": \"fashion\"}]",
        ],
        "thumbnail_img": idImageProductEdit,
        "photos": result,
        "lang": getLocal(),
        "video_link": productLinkVideoEdit.text,
        "description": productDetailsEdit.text,
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
        "choice_options_1":
            sizeSelect.map((e) {
              return e.value;
            }).toList(),
        "unit_price": productPriceEdit.text,
        "date_range": null,
        "discount": extractDouble(productDiscountEdit.text),
        "discount_type": "percent",
        "current_stock": productQuantityEdit.text,
        "category_ids":
            categoryId.map((e) {
              return e;
            }).toList(),
        "category_id": categoryIdSelect,
        "auction_type": "normal",
        "min_qty": "1",
        if (variantList.isNotEmpty) ...variantData,
      },
    );
    closeAllLoading();
    Navigator.pop(context);
  }

  fetchCategory(DetailsProductSeller detailsProductSellerResponse) async {
    changeDomain1();
    final json = await NetworkHelper.sendRequest(
      requestType: RequestType.get,
      endpoint: "categories",
    );
    changeDomain2();

    CategoryResponse categoryResponse = CategoryResponse.fromJson(json);
    for (var element in categoryResponse.data) {
      if (detailsProductSellerResponse.categoryId == element.id) {
        print(element.name);
        changeCategoryId(element.id, element.name);
      }
    }
    print("//////${detailsProductSellerResponse.categoryIds.length}");
    fetchSubCategory(detailsProductSellerResponse);
  }

  List<Datum> _sub = [];

  fetchSubCategory(DetailsProductSeller detailsProductSellerResponse) async {
    _sub = [];
    changeDomain1();
    final json = await NetworkHelper.sendRequest(
      requestType: RequestType.get,
      endpoint: "sub-categories/$categoryIdSelect",
    );
    changeDomain2();

    CategoryResponse categoryResponse = CategoryResponse.fromJson(json);
    for (var element2 in detailsProductSellerResponse.categoryIds) {
      for (var element in categoryResponse.data) {
        if (element2 == element.id) {
          print(element);
          _sub.add(element);
        }
      }
    }
    changeListCategory(_sub);
  }
}
