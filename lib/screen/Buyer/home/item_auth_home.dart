import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/controller/provider/store_notofire.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/home_notifire.dart';
import 'package:fils/controller/provider/user_notefire.dart';
import 'package:fils/screen/Buyer/favourite/favourait_screen.dart';
import 'package:fils/screen/Buyer/notification/notification_screen.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/global_function/image_view.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';
import '../../../model/response/seller/all_shops_response.dart';
import '../../../utils/enum/request_type.dart';
import '../../../utils/http/dialog_request_pagination.dart';
import '../../../utils/storage/storage.dart';
import '../../general/chat_boot.dart';

Widget authItem(HomeNotifire? homeNotifire, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: AnimatedOpacity(
      duration: const Duration(seconds: 1),
      opacity: homeNotifire!.visible ? 1.0 : 0.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Consumer<UserNotifier>(
                  builder: (context, user, child) {
                    late final ImageProvider<Object> imageProvider;

                    if (isLogin()) {
                      if (user.user!.user!.avatarOriginal.isEmpty) {
                        imageProvider = const AssetImage(
                          "assets/images/logo_png.png",
                        );
                      } else {
                        imageProvider = NetworkImage(
                          user.user!.user!.avatarOriginal,
                        );
                      }
                    }

                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            ToWithFade(
                              context,
                              ImageView(
                                images: [user.user!.user!.avatarOriginal],
                                initialIndex: 0,
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 24,
                            backgroundImage: imageProvider,
                          ),
                        ),
                        SizedBox(width: width * 0.02),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DefaultText(
                                user.greeting.tr(),
                                color: getTheme() ? white : grey,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                              GestureDetector(
                                onTap: () {
                                  context
                                      .read<AppNotifire>()
                                      .onClickBottomNavigationBar(4);
                                },
                                child: DefaultText(
                                  user.user!.user!.name,
                                  color: getTheme() ? white : blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (getUser()!.user!.type != "customer")
                                GestureDetector(
                                  onTap: () {
                                    showDialogShop(context);
                                  },
                                  child: SizedBox(
                                    height: 40,
                                    child: Center(
                                      child: DefaultText(
                                        getAllShop().name ??
                                            "Please Select your Shop".tr(),
                                        color: getTheme() ? white : blackColor,
                                        fontSize: 12,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (getUser()!.user!.type != "customer")
                          GestureDetector(
                            child: Container(
                              height: 40,
                              width: 40,
                              color: Colors.transparent,
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/icons/drob.svg",
                                  color: getTheme() ? white : Colors.black,
                                ),
                              ),
                            ),
                            onTap: () async {
                              showDialogShop(context);
                            },
                          ),
                      ],
                    );
                  },
                ),
              ),

              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        constraints: BoxConstraints(
                          minHeight: heigth * 0.9,
                          minWidth: width,
                        ),
                        elevation: 1,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        showDragHandle: true,
                        isScrollControlled: true,
                        useSafeArea: true,
                        enableDrag: true,
                        builder: (context) => const ChatBoot(),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: grey6,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/icons/boot.svg",
                          color: Colors.black,
                          height: 28,
                          width: 28,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.01),
                  GestureDetector(
                    onTap: () {
                      ToWithFade(context, const NotificationsScreen());
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: grey6,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/icons/notification_home.svg",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.01),
                  getUser()!.user!.type != "customer"
                      ? const SizedBox()
                      : GestureDetector(
                        onTap: () {
                          ToWithFade(context, FavouraitScreen());
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: grey6,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/icons/favourite_home.svg",
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ],
          ),
          getUser()!.user!.can_switch_between_accounts
              ? Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      switchAccount(
                        context,
                        getUser()!.user!.type == "seller"
                            ? "customer"
                            : "seller",
                      );
                    },
                    icon: const Icon(Icons.swap_horiz),
                  ),
                  DefaultText(
                    getUser()!.user!.type == "seller"
                        ? "Switch to Customer".tr()
                        : "Switch to Seller".tr(),
                  ),
                ],
              )
              : const SizedBox(),
        ],
      ),
    ),
  );
}

Future<void> showDialogShop(BuildContext context) {
  return showCupertinoDialog(
    context: context,
    builder:
        (context) => PaginationDialogCustom(
          endpoint: 'my-shops',

          itemSearchString: (p0) => p0.name!,
          isFirstData: false,
          isShowSelect: true,
          callback: (item) async {
            if (item != null) {
              item.select = false;
              setShop(item);
              await context.read<StoreNotifire>().functionGetDataStore(isGetComplete: true);
            } else {
              showCustomFlash(
                message: "Please Select your Shop".tr(),
                messageType: MessageType.Faild,
              );
            }
          },
          requestType: RequestType.get,
          title: "Shops".tr(),
          isShop: true,
          isSelect: getAllShop().select,
          itemBuilder: (context, item) {
            return DefaultText(item.name);
          },
          parseResponse: (p0) => ShopsAll.fromJson(p0),
        ),
  );
}
