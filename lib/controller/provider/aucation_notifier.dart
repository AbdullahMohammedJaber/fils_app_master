// ignore_for_file: unused_field, unused_local_variable, non_constant_identifier_names, prefer_interpolation_to_compose_strings, unnecessary_nullable_for_final_variable_declarations, avoid_print, use_build_context_synchronously

import 'dart:async';

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/model/response/balance_response.dart';
import 'package:fils/model/response/base_response.dart';
import 'package:fils/model/response/details_auction.dart';
import 'package:fils/screen/Buyer/aucations/payment_fee.dart';
import 'package:fils/screen/Seller/Subscriptions/subscriptions_screen.dart';
import 'package:fils/screen/general/edit_crob_filter_image.dart';
import 'package:fils/utils/global_function/number_format.dart';
import 'package:fils/utils/global_function/unit8list.dart';
import 'package:fils/utils/global_function/validation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:fils/model/response/Win_response.dart';
import 'package:fils/model/response/bid_response.dart';
import 'package:fils/model/response/error_response.dart';
import 'package:fils/model/response/seller/start_live_seller.dart';
import 'package:fils/screen/Seller/control_auction/live_room_seller.dart';
import 'package:fils/screen/general/root_app.dart';
import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/global_function/printer.dart';
import 'package:fils/utils/global_function/timer_format.dart';
import 'package:fils/utils/global_function/update_controller.dart';

import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:provider/provider.dart';

import '../../model/response/category_response.dart';
import '../../screen/Buyer/aucations/auction_category.dart';

import '../../utils/theme/color_manager.dart';
import '../../widget/defulat_text.dart';

class AuctionNotifier with ChangeNotifier {
  bool visible = true;

  String messageError = "";

  bool checkBid(double bid) {
    String currancy =
        Provider.of<AppNotifire>(
          NavigationService.navigatorKey.currentContext!,
          listen: false,
        ).currancy.tr();
    if (totalPriceBid > 0 && totalPriceBid <= 100) {
      return true;
    } else if (totalPriceBid > 100 && totalPriceBid <= 500) {
      if (bid < 10) {
        showCustomFlash(
          message: "The Min Bid 10".tr() + currancy,
          messageType: MessageType.Faild,
        );
        return false;
      } else {
        return true;
      }
    } else if (totalPriceBid > 500 && totalPriceBid <= 1000) {
      if (bid < 50) {
        showCustomFlash(
          message: "The Min Bid 50".tr() + currancy,
          messageType: MessageType.Faild,
        );
        return false;
      } else {
        return true;
      }
    } else if (totalPriceBid > 1000) {
      if (bid < 100) {
        showCustomFlash(
          message: "The Min Bid 100".tr() + currancy,
          messageType: MessageType.Faild,
        );
        return false;
      } else {
        return true;
      }
    }
    return true;
  }

  placePid(dynamic idAuction, double amount, double customer_bid) async {
    showBoatToast();
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "auction/place-bid?is_auction=1",
      fields: {
        "product_id": idAuction,
        "amount": amount,
        "customer_bid": customer_bid,
      },
    );
    closeAllLoading();
    if (json.containsKey("errorMessage")) {
      ErrorResponse errorResponse = ErrorResponse.fromJson(json);
      showCustomFlash(
        message: errorResponse.errorMessage,
        messageType: MessageType.Faild,
      );
    } else {
      notifyListeners();
    }
  }

  final List<BidResponse> _bids = [];

  StreamSubscription<DatabaseEvent>? _bidsSubscription;

  bool _isLoading = true;
  String? _errorMessage;

  List<BidResponse> get bids => _bids;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  double totalPriceBid = 0.0;

  changeListenerToPriceBid() {
    totalPriceBid = 0.0;
    for (var element in _bids) {
      totalPriceBid += extractDouble(element.bid.amount);
    }
    notifyListeners();
  }

  void fetchBids(dynamic auctionId) {
    _bidsSubscription = FirebaseDatabase.instance
        .ref()
        .child('bids/$auctionId')
        .onValue
        .listen(
          (event) {
            try {
              if (event.snapshot.value == null) {
                _bids.clear();
              } else {
                final Map<dynamic, dynamic> data =
                    event.snapshot.value as Map<dynamic, dynamic>;

                final List<BidResponse> updatedBids =
                    data.entries
                        .map(
                          (entry) => BidResponse.fromJson(
                            Map<String, dynamic>.from(entry.value),
                          ),
                        )
                        .toList();

                updatedBids.sort((a, b) => b.bid.bidAt.compareTo(a.bid.bidAt));
                _bids.clear();
                _bids.addAll(updatedBids);
                changeListenerToPriceBid();
              }
              _isLoading = false;
              _errorMessage = null;
            } catch (e) {
              print("catch $e");

              _errorMessage = "Failed to fetch bids: $e";
            }
            notifyListeners();
          },
          onError: (error) {
            print("error $error");
            _isLoading = false;
            _errorMessage = "Error: $error";
            notifyListeners();
          },
        );
  }

  ////////////////////////////////////////////////////////
  bool isFinishAuction = false;
  bool showBottomSheet = false;
  bool isWinner = false;
  StreamSubscription<DatabaseEvent>? _bidsSubscriptionWin;
  final List<AuctionWin> _bidsWin = [];

  List<AuctionWin> get bidsWin => _bidsWin;

  void checkAuction(dynamic auctionId, String name) {
    _bidsSubscriptionWin = FirebaseDatabase.instance
        .ref()
        .child('auctions')
        .onValue
        .listen((event) {
          if (event.snapshot.value == null) {
            _bidsWin.clear();
          } else {
            final Map<dynamic, dynamic> data =
                event.snapshot.value as Map<dynamic, dynamic>;

            final List<AuctionWin> updatedBids =
                data.entries
                    .map(
                      (entry) => AuctionWin.fromJson(
                        Map<String, dynamic>.from(entry.value),
                      ),
                    )
                    .toList();

            _bidsWin
              ..clear()
              ..addAll(updatedBids);
            for (var action in _bidsWin) {
              if (action.auctionId == auctionId) {
                if (action.winnerId != null) {
                  showModalBottomSheet(
                    context: NavigationService.navigatorKey.currentContext!,
                    useSafeArea: false,
                    isScrollControlled: true,
                    constraints: BoxConstraints(maxHeight: heigth * 0.65),
                    isDismissible: false,
                    builder: (_) {
                      return buildWinAuctionWidget(
                        action.winnerId!,
                        action.maxBid,
                        bids.last.bid.user.name,
                        action.auctionId!,
                        name,
                      );
                    },
                  );
                } else {
                  toRemoveAll(
                    NavigationService.navigatorKey.currentContext!,
                    const RootAppScreen(),
                  );
                }
              }
            }
          }
        });
  }

  ///////////////////////////////////////////////////////
  bool _showScrollDownButton = false;

  bool get showScrollDownButton => _showScrollDownButton;

  void setShowScrollDownButton(bool value) {
    _showScrollDownButton = value;
    notifyListeners();
  }

  ///////////////////////////////////////////////////
  List<Map<dynamic, dynamic>> gifts = [];
  bool loadingGift = true;
  StreamSubscription<DatabaseEvent>? _bidsSubscriptionGift;
  String? _errorMessageGift;
  List<String> giftsId = [];
  bool showGiftBox = false;
  Timer? giftBoxTimer;
  String messageNewGift = "";
  String amountNewGift = "";

  void fetchGift(dynamic auctionId) {
    _bidsSubscriptionGift?.cancel();

    loadingGift = true;
    print("fetch gift ...");
    _bidsSubscriptionGift = FirebaseDatabase.instance
        .ref()
        .child('gifts/$auctionId')
        .onValue
        .listen(
          (event) {
            print("event ... ${event.snapshot.value}");

            try {
              if (event.snapshot.value == null) {
                gifts.clear();
                giftsId.clear();
                showGiftBox = false;
                loadingGift = false;
                notifyListeners();
                return;
              } else {
                final Map<dynamic, dynamic> data =
                    event.snapshot.value as Map<dynamic, dynamic>;

                final List<Map<String, dynamic>> fetchedGifts =
                    data.entries
                        .map((entry) => Map<String, dynamic>.from(entry.value))
                        .where((gift) => gift['status'].toString() == 'Pending')
                        .where(
                          (gift) =>
                              gift['receiver_id'].toString() ==
                              getUser()!.user!.id.toString(),
                        )
                        .toList();

                gifts = fetchedGifts;
                for (var element in gifts) {
                  final giftId = element['gift_id'].toString();
                  if (!giftsId.contains(giftId)) {
                    printGreen("new gift ------------------");
                    printGreen(element['message']);
                    messageNewGift = element['message'];
                    amountNewGift = element['amount'].toString();
                    showGiftBox = true;
                    giftBoxTimer?.cancel();
                    giftBoxTimer = Timer(const Duration(seconds: 5), () {
                      showGiftBox = false;
                      notifyListeners();
                    });
                    notifyListeners();
                    giftsId.add(element['gift_id'].toString());
                  }
                }

                loadingGift = false;
                notifyListeners();
              }
            } catch (e) {
              loadingGift = false;
              _errorMessageGift = "Failed to fetch bids: $e";
            }
            notifyListeners();
          },
          onError: (error) {
            loadingGift = false;
            _errorMessageGift = "Error: $error";
            notifyListeners();
          },
        );
  }

  closeGiftBox() {
    showGiftBox = false;
    giftBoxTimer?.cancel();
    notifyListeners();
  }

  void disposeGiftListener() {
    _bidsSubscriptionGift?.cancel();

    giftBoxTimer?.cancel();
  }

  // dynamic type = 1 is accept or 2 is reject

  acceptOrRejectGift({
    required dynamic idGift,
    required dynamic senderId,
    required dynamic type,
  }) async {
    showBoatToast();
    var json = NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "auction-gifts/change-acceptance/$idGift",
      fields: {
        "action": type == 1 ? "accept" : "reject",
        "sender_id": senderId,
      },
    );
    closeAllLoading();
  }

  sendGift({
    required String id_resever,
    required String auction_id,
    required String price,
  }) async {
    showBoatToast();
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "auction-gifts/send",
      fields: {
        "receiver_id": id_resever,
        "amount": price,
        "auction_id": auction_id,
      },
    ).then((value) {
      getBalance();
    });
    closeAllLoading();
  }

  getBalance() async {
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.get,
      endpoint: "wallet/balance",
    );
    if (json.containsKey("errorMessage")) {
    } else {
      BalanceResponse balanceResponse = BalanceResponse.fromJson(json);
      setBalance(double.parse(balanceResponse.data!.balance!));
    }
  }

  ////////////////////////////////////////////////
  // Form Add Auction by Seller
  TextEditingController auctionName = TextEditingController();
  TextEditingController auctionPrice = TextEditingController();
  TextEditingController auctionDetails = TextEditingController();
  TextEditingController assurance_fee = TextEditingController();
  File? imageFile;
  List<File> imageFilesList = [];
  dynamic auctionType = -1; // 0 live  , 1 normal
  dynamic selectImage = -1;
  DateTime dataStart = DateTime.now();
  DateTime dataEnd = DateTime.now();
  TimeOfDay timeStart = TimeOfDay.now();
  TimeOfDay timeEnd = TimeOfDay.now();
  List<dynamic> categoryId = [];
  List<String> categoryName = [];
  String category = "Add Category".tr();
  String? idImageLogo;
  List<String> idImagesLogo = [];
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
    category = "";
    categoryId.add(categoryIdSelect);
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

  Future<void> selectStartTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: timeStart,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      timeStart = pickedTime;

      if (_isTimeBefore(timeEnd, timeStart)) {
        timeEnd = timeStart;
      }

      notifyListeners();
    }
  }

  Future<void> selectEndTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: timeEnd,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      if (_isTimeBeforeOrEqual(pickedTime, timeStart)) {
        showCustomFlash(
          message: "The end time must be greater than the start time".tr(),
          messageType: MessageType.Faild,
        );
      } else {
        timeEnd = pickedTime;
        notifyListeners();
      }
    }
  }

  bool _isTimeBefore(TimeOfDay t1, TimeOfDay t2) {
    return t1.hour < t2.hour || (t1.hour == t2.hour && t1.minute < t2.minute);
  }

  bool _isTimeBeforeOrEqual(TimeOfDay t1, TimeOfDay t2) {
    return t1.hour < t2.hour || (t1.hour == t2.hour && t1.minute <= t2.minute);
  }

  Future<void> selectStartDate(BuildContext context) async {
    DateTime today = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dataStart,
      firstDate: today,
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      dataStart = pickedDate;
      notifyListeners();
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dataStart,
      firstDate: dataStart,
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      dataEnd = pickedDate;
      notifyListeners();
    }
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

  Future<List<File>> uploadMultiImage() async {
    try {
      final picker = ImagePicker();
      final List<XFile>? pickedFiles = await picker.pickMultiImage();

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        return pickedFiles.map((file) => File(file.path)).toList();
      }
    } catch (e) {
      print("Error: $e");
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

  changeTypeAuction(dynamic value) {
    auctionType = value;
    notifyListeners();
  }

  uploadImageServer(File imageFileFinal) async {
    Future.delayed(const Duration(seconds: 1), () async {
      showBoatToast();
      final json = await NetworkHelper.sendRequest(
        requestType: RequestType.post,
        endpoint: "file/upload",
        files: {"aiz_file": imageFileFinal},
      );
      closeAllLoading();
      if (json.containsKey("errorMessage")) {
        clearImage();
      } else {
        idImageLogo = json['data']['id'].toString();
      }
    });
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
  }

  UpdateController updateControllerAuctionSeller = UpdateController();

  addAuction() async {
    if (dataStart.isAfter(dataEnd)) {
      showCustomFlash(
        message: "The start date cannot be greater than the end date".tr(),
        messageType: MessageType.Faild,
      );
    } else {
      showBoatToast();
      String result = idImagesLogo.join(",");
      final json = await NetworkHelper.sendRequest(
        requestType: RequestType.post,
        endpoint: "auction-products/create",
        fields: {
          "name": auctionName.text,
          "brand_id": "1", // static
          "unit": "kg", // static
          "weight": "0.5", // static
          "shop_id": getAllShop().id.toString(),
          "tags": [
            "[{\"value\": \"auction\"}, {\"value\": \"exclusive\"}, {\"value\": \"rare\"}]",
          ],
          "photos": result,
          "thumbnail_img": idImageLogo,
          "starting_bid": auctionPrice.text,
          "description":auctionDetails.text,
          "auction_date_range":
              "${formatDate2(dataStart)} ${formatTimeOfDay2(timeStart)} to ${formatDate2(dataEnd)} ${formatTimeOfDay2(timeEnd)}",
          "category_ids":
              categoryId.map((e) {
                return e;
              }).toList(),
          "category_id": categoryIdSelect,
          "auction_type": auctionType == 0 ? "live" : "normal",
          "assurance_fee":
              assurance_fee.text.isEmpty ? "0" : assurance_fee.text,
          "lang": getLocal(),
        },
      );
      closeAllLoading();
      print(json.toString());

      if (json.containsKey("errorMessage")) {
        showCustomFlash(
          message: json['errorMessage'],
          messageType: MessageType.Faild,
        );
      } else {
        BaseResponse baseResponse = BaseResponse.fromJson(json);
        if (!baseResponse.result!) {
          showCustomFlash(
            message: baseResponse.message,
            messageType: MessageType.Faild,
          );
          ToWithFade(
            NavigationService.navigatorKey.currentContext!,
            const SubscriptionsScreen(typeStore: 0,),
          );
        } else {
          clearDataForm();
          updateControllerAuctionSeller.update();
        }
      }
    }
  }

  clearDataForm() {
    auctionName = TextEditingController();
    auctionPrice = TextEditingController();
    auctionDetails = TextEditingController();
    assurance_fee = TextEditingController();
    imageFile = null;
    imageFilesList = [];
    auctionType = -1;
    selectImage = -1;
    dataStart = DateTime.now();
    dataEnd = DateTime.now();
    timeStart = TimeOfDay.now();
    timeEnd = TimeOfDay.now();
    categoryId = [];
    categoryName = [];
    category = "Add Category".tr();
    idImageLogo = null;
    idImagesLogo = [];
    notifyListeners();
    Navigator.pop(NavigationService.navigatorKey.currentContext!);
  }

  //////// Start Live

  startLive(
    BuildContext context, {
    dynamic idAuction,
    required String auctionName,
  }) async {
    changeDomain1();

    showBoatToast();
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "auction/stream/$idAuction/start-live-stream",
    );
    closeAllLoading();
    if (json.containsKey("errorMessage")) {
    } else {
      StartLiveSellerResponse startLiveSellerResponse =
          StartLiveSellerResponse.fromJson(json);
      ToRemove(
        context,
        LiveRoomSeller(
          rtmpUrl: startLiveSellerResponse.data.rtmpUrl,
          streamKey: startLiveSellerResponse.data.streamKey,
          auctionId: idAuction,
          auctionName: auctionName,
          isLive:
              startLiveSellerResponse.data.auction.isLive == 1 ? true : false,
          isPaused:
              startLiveSellerResponse.data.auction.isPaused == 1 ? true : false,
        ),
      );
    }

    changeDomain2();
  }

  late DetailsAuctionResponse detailsAuctionResponse;

  changeDetailsAuctionResponse(DetailsAuctionResponse _detailsAuctionResponse) {
    detailsAuctionResponse = _detailsAuctionResponse;
  }

  payInsuranceBid(BuildContext context, DetailsAuctionResponse data) async {
    print(data.data.id);
    showBoatToast();
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: "auction/assurance-fee/${data.data.id}/pay",
      fields: {"payment_provider": "ecom"},
    );
    closeAllLoading();
    if (json.containsKey("errorMessage")) {
    } else {
      bool pay = await ToWithFade(
        context,
        PaymentFeeWebView(urlPayment: json['link'], idAuction: data.data.id),
      );
      if (pay) {
        detailsAuctionResponse.data.isPaidAssuranceFee = true;
        print("true pay");
        print(
          "detailsAuctionResponse.data.isPaidAssuranceFee ${detailsAuctionResponse.data.isPaidAssuranceFee}",
        );
      } else {
        print("false pay");
        print(
          "detailsAuctionResponse.data.isPaidAssuranceFee ${detailsAuctionResponse.data.isPaidAssuranceFee}",
        );
      }
          notifyListeners();
    }
  }

  dynamic pageTapBarAuction = 1;
  String url = "auction/products/sub-category";
  String end = "?is_auction=1&auction_type=normal";
  void changePageTapBar({required dynamic index}) {
    pageTapBarAuction = index;
    notifyListeners();
  }

  void changeUrlAuction(String s, String end2, int id) {
    url = s;
    end = end2;
    notifyListeners();
    updateControllerAuction.updateWithNewUrl("$url/$id$end");
  }
}
