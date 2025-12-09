import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/global_function/validation.dart';
import 'package:fils/utils/strings_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/cart_notifire.dart';
import 'package:fils/utils/animation/custom_fade_animation.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';
import '../../../../utils/enum/request_type.dart';
import '../../../../utils/http/http_helper.dart';
import '../../../../utils/storage/storage.dart';

class ItemDeliveryMethod extends StatelessWidget {
  const ItemDeliveryMethod({super.key});

  void showCityListDialog(BuildContext context) {
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
                              context.read<CartNotifire>().cityId = item["id"];
                              context.read<CartNotifire>().areaController.text =
                                  cityName;
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

  @override
  Widget build(BuildContext context) {
    return Consumer<CartNotifire>(
      builder: (context, cart, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                  width: width,
                  margin: EdgeInsets.only(top: heigth * 0.01),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),

                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder(
                        future: Future.delayed(
                          const Duration(milliseconds: 100),
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return CustomFadeAnimationComponent(
                              1,
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Form(
                                  key: cart.key,
                                  child: Column(
                                    children: [
                                      SizedBox(height: heigth * 0.01),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: grey4,
                                                    blurRadius: 0.05,
                                                    offset: const Offset(1, 1),
                                                  ),
                                                ],
                                              ),
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return requiredField;
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                controller: cart.nameController,
                                                keyboardType:
                                                    TextInputType.name,
                                                decoration: InputDecoration(
                                                  hintText: "Full Name".tr(),
                                                  filled: true,

                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: width * 0.02),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: grey4,
                                                    blurRadius: 0.1,
                                                    offset: const Offset(1, 1),
                                                  ),
                                                ],
                                              ),
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.phone,
                                                controller:
                                                    cart.phoneController,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return requiredField;
                                                  } else if (!RegExp(
                                                    r'^[0-9]+$',
                                                  ).hasMatch(value)) {
                                                    return "The number must contain only numbers."
                                                        .tr();
                                                  } else {
                                                    return null;
                                                  }
                                                },

                                                decoration: InputDecoration(
                                                  hintText:
                                                      "Mobile Number".tr(),

                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: heigth * 0.01),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: grey4,
                                              blurRadius: 0.1,
                                              offset: const Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                        child: TextFormField(
                                          controller: cart.emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return requiredField;
                                            } else if (!isEmailValid(value)) {
                                              return emailFalse;
                                            } else {
                                              return null;
                                            }
                                          },
                                          decoration: InputDecoration(
                                            hintText: "E - mail".tr(),
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: heigth * 0.01),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: grey4,
                                              blurRadius: 0.1,
                                              offset: const Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                        child: TextFormField(
                                          controller: cart.addressController,
                                          keyboardType: TextInputType.name,

                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return requiredField;
                                            } else {
                                              return null;
                                            }
                                          },
                                          decoration: InputDecoration(
                                            hintText: "Address".tr(),
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: heigth * 0.01),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: grey4,
                                              blurRadius: 0.1,
                                              offset: const Offset(1, 2),
                                            ),
                                          ],
                                        ),
                                        child: TextFormField(
                                          controller: cart.areaController,
                                          keyboardType: TextInputType.none,
                                          onTap: () {
                                            showCityListDialog(context);
                                          },
                                          validator: (value) {
                                            if (cart
                                                .areaController
                                                .text
                                                .isEmpty) {
                                              return requiredField;
                                            } else {
                                              return null;
                                            }
                                          },
                                          decoration: InputDecoration(
                                            hintText: "Area".tr(),
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: BorderSide.none,
                                            ),
                                            suffixIcon: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/icons/drob.svg",
                                                  height: 15,
                                                ),
                                                SizedBox(width: 10),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: heigth * 0.02),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/note.svg",
                                          ),
                                          SizedBox(width: width * 0.01),
                                          Expanded(
                                            child: DefaultText(
                                              "Enter your accommodation details to list the best delivery companies for you"
                                                  .tr(),
                                              overflow: TextOverflow.visible,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
