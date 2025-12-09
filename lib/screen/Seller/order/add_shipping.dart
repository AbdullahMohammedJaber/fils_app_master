import 'package:easy_localization/easy_localization.dart';
import 'package:fils/screen/Seller/order/shipping_address.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/strings_app.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/custom_validation.dart';
import 'package:fils/widget/defualt_text_form_faild.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:flutter/material.dart';

class AddShippingAddress extends StatefulWidget {
  @override
  State<AddShippingAddress> createState() => _AddShippingAddressState();
}

class _AddShippingAddressState extends State<AddShippingAddress> {
  int? idAddress;

  String? nameArea;

  TextEditingController address = TextEditingController();
  void showCityListDialog(BuildContext context) {
    changeDomain1();
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: FutureBuilder<Map<String, dynamic>>(
            future: NetworkHelper.sendRequest(
              requestType: RequestType.get,
              endpoint: 'addresses',
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError || snapshot.data == null) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: DefaultText(
                    "حدث خطأ: ${snapshot.error ?? 'غير معروف'}",
                  ),
                );
              }

              final response = snapshot.data!;
              if (response['code'] != 200 || response["data"] == null) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: DefaultText("تعذر تحميل البيانات."),
                );
              }

              final List<dynamic> data = response["data"];

              return SizedBox(
                height: 400,
                width: 300,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              changeDomain2();

                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: data.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final item = data[index];
                          final cityName = item["name"];

                          return ListTile(
                            title: DefaultText(cityName),

                            onTap: () {
                              nameArea = cityName;
                              idAddress = item['id'];
                              changeDomain2();
                              setState(() {});
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: Column(
          children: [
            SizedBox(height: heigth * 0.06),
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
                ],
              ),
            ),
            ValidateWidget(
              validator: (value) {
                if (idAddress != null) {
                  return null;
                } else {
                  return requiredField;
                }
              },
              child: GestureDetector(
                onTap: () {
                  showCityListDialog(context);
                },
                child: Container(
                  height: 40,
                  width: width,
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: textColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(children: [DefaultText(nameArea ?? "Area".tr())]),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ValidateWidget(
                validator: (value) {
                  if (address.text.isEmpty) {
                    return requiredField;
                  } else {
                    return null;
                  }
                },
                child: TextFormFieldWidget(
                  hintText: "Address".tr(),
                  controller: address,
                  textInputType: TextInputType.name,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ButtonWidget(
                onTap: () async {
                  if (!_key.currentState!.validate()) {
                  } else {
                    showBoatToast();
                    final json = await NetworkHelper.sendRequest(
                      requestType: RequestType.post,
                      endpoint: "shipping-adress/create",
                      fields: {
                        "sector_id": idAddress,
                        "phone": getUser()!.user!.phone,
                        "address": address.text,
                        "shop_id": getAllShop().id,
                      },
                    );
                    closeAllLoading();
                    if (!json.containsKey("errorMessage")) {
                      shippingController.update();
                      Navigator.pop(context);
                    }
                  }
                },
                title: "Add".tr(),
                colorButton: primaryColor,
                heightButton: 45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
