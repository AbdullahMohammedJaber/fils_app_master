// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:day_night_themed_switch/day_night_themed_switch.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/theme_notifire.dart';
import 'package:fils/model/response/base_response.dart';
import 'package:fils/screen/auth/login/screen/login_screen.dart';
import 'package:fils/utils/enum/message_type.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/message_app/show_flash_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/controller/provider/user_notefire.dart';
import 'package:fils/screen/setting/item_setting.dart';
import 'package:fils/screen/setting/setting_page.dart';

import 'package:fils/utils/animation/custom_fade_animation.dart';
import 'package:fils/utils/global_function/image_view.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/widget/dialog_auth.dart';
import 'package:fils/widget/item_back.dart';

import 'package:fils/utils/const.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:provider/provider.dart';

import '../../../widget/dialog_logout.dart';
import '../favourite/favourait_screen.dart';
import '../notification/notification_screen.dart';
import '../order/order_screen.dart';

import '../support_help/support_help_team.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<AppNotifire, UserNotifier, ThemeProvider>(
      builder: (context, app, user, theme, child) {
        late final ImageProvider<Object> imageProvider;

        if (isLogin()) {
          if (user.user!.user!.avatarOriginal.isEmpty) {
            imageProvider = const AssetImage("assets/images/logo_png.png");
          } else {
            imageProvider = NetworkImage(getUser()!.user!.avatarOriginal);
          }
        }

        return CustomFadeAnimationComponent(
          1,
          Scaffold(
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: heigth * 0.06),
                    itemBackAndTitle(
                      context,
                      title: "My Profile".tr(),
                      showBackIcon: false,
                    ),

                    isLogin()
                        ? SizedBox(
                          width: width,
                          child: Column(
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
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(70),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.contain,
                                        ),
                                        border: Border.all(
                                          color: textColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),

                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: white,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        user.selectAndUploadImage();
                                      },
                                      child: CircleAvatar(
                                        radius: 15.5,
                                        backgroundColor: textColor,
                                        child: Icon(Icons.edit, color: white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: heigth * 0.025),
                              DefaultText(
                                user.user!.user!.name,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              DefaultText(
                                user.user!.user!.email,
                                color: textColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                            ],
                          ),
                        )
                        : const SizedBox(),
                    SizedBox(height: heigth * 0.02),
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: DayNightSwitch(
                            value: getTheme(),

                            onChanged: (value) {
                              print(value);
                              theme.toggleTheme(value);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        DefaultText(
                          "Theme".tr(),
                          color: getTheme() ? white : blackColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(end: width * 0.02),
                      child: Divider(thickness: 0.5, color: textColor),
                    ),
                    itemSetting(
                      pathIcon: "assets/icons/my_order.svg",
                      title: "My Orders".tr(),
                      onClick: () {
                        if (!isLogin()) {
                          showDialogAuth(context);
                        } else {
                          ToWithFade(context, const OrderScreen());
                        }
                      },
                    ),

                    Padding(
                      padding: EdgeInsetsDirectional.only(end: width * 0.02),
                      child: Divider(thickness: 0.5, color: textColor),
                    ),

                    itemSetting(
                      pathIcon: "assets/icons/favourite_home.svg",
                      title: "Favourite".tr(),
                      onClick: () {
                        if (!isLogin()) {
                          showDialogAuth(context);
                        } else {
                          ToWithFade(context, FavouraitScreen());
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(end: width * 0.02),
                      child: Divider(thickness: 0.5, color: textColor),
                    ),
                    itemSetting(
                      pathIcon: "assets/icons/setting.svg",
                      title: "Settings".tr(),
                      onClick: () {
                        ToWithFade(context, const SettingsPage());
                      },
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(end: width * 0.02),
                      child: Divider(thickness: 0.5, color: textColor),
                    ),
                    itemSetting(
                      pathIcon: "assets/icons/notification_home.svg",
                      title: "Notifications".tr(),
                      onClick: () {
                        if (!isLogin()) {
                          showDialogAuth(context);
                        } else {
                          ToWithFade(context, const NotificationsScreen());
                        }
                      },
                    ),

                    isLogin() && getUser()!.user!.can_switch_between_accounts
                        ? Padding(
                          padding: EdgeInsetsDirectional.only(
                            end: width * 0.02,
                          ),
                          child: Divider(thickness: 0.5, color: textColor),
                        )
                        : const SizedBox(),

                    isLogin() && getUser()!.user!.can_switch_between_accounts
                        ? itemSetting(
                          pathIcon: "assets/icons/switch_seller.svg",
                          title: "Switch to seller account".tr(),
                          onClick: () async {
                            if (!isLogin()) {
                              showDialogAuth(context);
                            } else {
                              switchAccount(context, "seller");
                            }
                          },
                        )
                        : const SizedBox(),
                    Padding(
                      padding: EdgeInsetsDirectional.only(end: width * 0.02),
                      child: Divider(thickness: 0.5, color: textColor),
                    ),

                    itemSetting(
                      pathIcon: "assets/icons/support.svg",
                      title: "Support and help Team".tr(),
                      onClick: () {
                        if (!isLogin()) {
                          showDialogAuth(context);
                        } else {
                          ToWithFade(context, const SupportAndHelpTeam());
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(end: width * 0.02),
                      child: Divider(thickness: 0.5, color: textColor),
                    ),
                    !isLogin()
                        ? itemSetting(
                          pathIcon: "assets/icons/logout.svg",
                          title: "Login".tr(),
                          onClick: () {
                            To(context, LoginScreen());
                          },
                        )
                        : SizedBox(),
                    isLogin()
                        ? GestureDetector(
                          onTap: () {
                            showDialogLogout(context);
                          },
                          child: Container(
                            color: Colors.transparent,
                            width: width,
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: const Color(
                                      0xffE4626F,
                                    ).withOpacity(0.5),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      "assets/icons/logout.svg",
                                    ),
                                  ),
                                ),
                                SizedBox(width: width * 0.02),
                                DefaultText(
                                  "Logout".tr(),
                                  fontSize: 14,
                                  color: const Color(0xffE4626F),
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(width: width * 0.02),
                              ],
                            ),
                          ),
                        )
                        : const SizedBox(),
                    Padding(
                      padding: EdgeInsetsDirectional.only(end: width * 0.02),
                      child: Divider(thickness: 0.5, color: textColor),
                    ),
                    isLogin()
                        ? GestureDetector(
                          onTap: () {
                            showDialogDelete(context);
                          },
                          child: Container(
                            color: Colors.transparent,
                            width: width,
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: const Color(
                                      0xffE4626F,
                                    ).withOpacity(0.5),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      "assets/icons/delete.svg",
                                      height: 25,
                                    ),
                                  ),
                                ),
                                SizedBox(width: width * 0.02),
                                DefaultText(
                                  "Delete Account".tr(),
                                  fontSize: 14,
                                  color: const Color(0xffE4626F),
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(width: width * 0.02),
                              ],
                            ),
                          ),
                        )
                        : const SizedBox(),
                    SizedBox(height: heigth * 0.1),

                    Center(
                      child: DefaultText(
                        'Version $info',
                        color: textColor,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: heigth * 0.02),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
