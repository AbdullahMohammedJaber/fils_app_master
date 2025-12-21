import 'package:easy_localization/easy_localization.dart';
import 'package:fils/model/response/seller/shipping_address_response.dart';
import 'package:fils/screen/Buyer/edit_account/edit_personal_information.dart';
import 'package:fils/screen/Seller/order/add_shipping.dart';
import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/global_function/update_controller.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/http/list_request.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';

UpdateController shippingController = UpdateController();

class ShippingAdress extends StatefulWidget {
  final int order_id;

  const ShippingAdress({super.key, required this.order_id});

  @override
  State<ShippingAdress> createState() => _ShippingAdressState();
}

class _ShippingAdressState extends State<ShippingAdress> {
  @override
  void initState() {
    super.initState();
    GetStorage().remove('shipping');
  }

  @override
  void dispose() {
    super.dispose();
    GetStorage().remove('shipping');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: width, height: heigth * 0.08),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
                DefaultText(
                  "Shipping address".tr(),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: primaryDarkColor,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    if (getUser()!.user!.phone!.isEmpty) {
                      showCustomFlash(
                        message: "Please fill Phone number".tr(),
                        messageType: MessageType.Faild,
                      );
                      To(
                        NavigationService.navigatorKey.currentContext!,
                        EditPersonalInformationScreen(),
                      );
                    } else {
                      if (getAllShop().id != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AddShippingAddress();
                            },
                          ),
                        );
                      } else {
                        showCustomFlash(
                          message: "Please Select your Shop".tr(),
                          messageType: MessageType.Faild,
                        );
                      }
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: secondColor,
                    ),
                    child: Center(
                      child: SvgPicture.asset("assets/icons/plus.svg"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ListWidgetRequest(
            endpoint: "shipping-adress/list?shop_id=${getAllShop().id}",
            isFirstData: true,

            itemBuilder: (context, item) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    item.isSelect = true;
                  });
                  setShippingAddress(item);
                },
                child: Container(
                  height: 30,
                  margin: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        DefaultText(
                          item.address,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        Spacer(),
                        Container(
                          height: 20,
                          width: 20,
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child:
                              item.isSelect &&
                                      getShippingAddress().id == item.id
                                  ? Container(
                                    color: primaryColor,
                                    height: 20,
                                    width: 20,
                                  )
                                  : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            updateController: shippingController,
            parseItem: (json) => ShippingAddress.fromJson(json),
            requestType: RequestType.get,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ButtonWidget(
              onTap: () async {
                if (getShippingAddress().id == null) {
                  showCustomFlash(
                    messageType: MessageType.Faild,
                    message: "Please Select Address".tr(),
                  );
                } else {
                  showBoatToast();
                  final json = await NetworkHelper.sendRequest(
                    endpoint: "shipping-adress/ship-order",
                    requestType: RequestType.post,
                    fields: {
                      "order_id": widget.order_id,
                      "seller_address_id": getShippingAddress().id,
                    },
                  );
                  closeAllLoading();
                  if (!json.containsKey("errorMessage")) {
                    Navigator.pop(context);
                  }
                }
              },
              title: "Sipping".tr(),
              colorButton: primaryColor,
              heightButton: 45,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
