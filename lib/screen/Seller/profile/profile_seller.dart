import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/theme_notifire.dart';
import 'package:fils/utils/global_function/printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fils/screen/Seller/order/order_seller.dart';
import 'package:fils/screen/Seller/setting_seller/settings_seller.dart';
import 'package:fils/screen/Seller/wallet/wallet_screen.dart';
import 'package:fils/utils/const.dart';
import 'package:provider/provider.dart';
import 'package:day_night_themed_switch/day_night_themed_switch.dart';
import '../../../controller/provider/app_notifire.dart';
import '../../../controller/provider/user_notefire.dart';
import '../../../utils/animation/custom_fade_animation.dart';
import '../../../utils/enum/message_type.dart';
import '../../../utils/global_function/image_view.dart';
import '../../../utils/message_app/show_flash_message.dart';
import '../../../utils/route/route.dart';
import '../../../utils/storage/storage.dart';
import '../../../utils/theme/color_manager.dart';
import '../../../widget/defulat_text.dart';
import '../../../widget/dialog_auth.dart';
import '../../../widget/dialog_logout.dart';
import '../../../widget/item_back.dart';

import '../../Buyer/notification/notification_screen.dart';

import '../../Buyer/support_help/support_help_team.dart';
import '../../setting/item_setting.dart';

import '../ads/ads_screen.dart';
import '../user_guide/user_guide.dart';

class ProfileSeller extends StatefulWidget {
  const ProfileSeller({super.key});

  @override
  State<ProfileSeller> createState() => _ProfileSellerState();
}

class _ProfileSellerState extends State<ProfileSeller> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<AppNotifire, UserNotifier, ThemeProvider>(
      builder: (context, app, user, theme, child) {
        late final ImageProvider<Object> imageProvider;

        if (isLogin()) {
          if (user.user!.user!.avatarOriginal.isEmpty) {
            imageProvider = const AssetImage("assets/images/logo_png.png");
          } else {
            imageProvider = NetworkImage(user.user!.user!.avatarOriginal);
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
                    SizedBox(height: heigth * 0.03),
                    itemBackAndTitle(
                      context,
                      title: "My Profile".tr(),
                      showBackIcon: false,
                    ),
                    SizedBox(height: heigth * 0.02),
                    isLogin()
                        ? Center(
                          child: SizedBox(
                            width: width,
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    ToWithFade(
                                      context,
                                      ImageView(
                                        images: [
                                          user.user!.user!.avatarOriginal,
                                        ],
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
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.contain,
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DefaultText(
                                      user.user!.user!.name,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    const DefaultText(
                                      " | ",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    DefaultText(
                                      getAllShop().name ?? "",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    DefaultText(
                                      "🥉".tr(),
                                      color: textColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                    DefaultText(
                                      "New seller".tr(),
                                      color: textColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                    const SizedBox(width: 4),
                                    const CircleAvatar(
                                      radius: 5,
                                      backgroundColor: Colors.green,
                                    ),
                                    const SizedBox(width: 4),
                                    getAllShop().id != null
                                        ? IconButton(
                                          onPressed: () {
                                            shareStoreLink(
                                              getAllShop().id.toString(),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.share,
                                            size: 20,
                                            color: textColor,
                                          ),
                                        )
                                        : SizedBox(),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                DefaultText(
                                  user.user!.user!.email,
                                  color: textColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                                const SizedBox(height: 5),
                                DefaultText(
                                  "⭐4.8(300 Reviews)",
                                  color: textColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ],
                            ),
                          ),
                        )
                        : const SizedBox(),
                    SizedBox(height: heigth * 0.03),
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: DayNightSwitch(
                            value: getTheme(),

                            onChanged: (value) {
                              printWarning(getTheme().toString());
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
                    Padding(
                      padding: EdgeInsetsDirectional.only(end: width * 0.02),
                      child: Divider(thickness: 0.5, color: textColor),
                    ),
                    itemSetting(
                      pathIcon: "assets/icons/setting.svg",
                      title: "Settings".tr(),
                      onClick: () {
                        ToWithFade(context, const SettingsSeller());
                      },
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(end: width * 0.02),
                      child: Divider(thickness: 0.5, color: textColor),
                    ),
                    itemSetting(
                      pathIcon: "assets/icons/ads.svg",
                      title: "Sponsored ads".tr(),
                      onClick: () {
                        ToWithFade(context, const AdsScreen());
                      },
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(end: width * 0.02),
                      child: Divider(thickness: 0.5, color: textColor),
                    ),
                    itemSetting(
                      pathIcon: "assets/icons/wallet.svg",
                      title: "Balance".tr(),
                      onClick: () {
                        if (!isLogin()) {
                          showDialogAuth(context);
                        } else {
                          if (getAllShop().id == null) {
                            showCustomFlash(
                              message: "Please Select your Shop".tr(),
                              messageType: MessageType.Faild,
                            );
                          } else {
                            ToWithFade(context, const WalletScreen());
                          }
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(end: width * 0.02),
                      child: Divider(thickness: 0.5, color: textColor),
                    ),
                    /*itemSetting(
                      pathIcon: "assets/icons/payment.svg",
                      title: "Payment methods".tr(),
                      onClick: () {
                        ToWithFade(context, const ShowPaymentMethodeScreen());
                      },
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(end: width * 0.02),
                      child: Divider(thickness: 0.5, color: textColor),
                    ),*/
                    itemSetting(
                      pathIcon: "assets/icons/my_order.svg",
                      title: "My Orders".tr(),
                      onClick: () {
                        if (!isLogin()) {
                          showDialogAuth(context);
                        } else {
                          ToWithFade(context, const OrderSeller(isPop: true));
                        }
                      },
                    ),
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
                    itemSetting(
                      pathIcon: "assets/icons/guide.svg",
                      title: "User Guide".tr(),
                      onClick: () {
                        if (!isLogin()) {
                          showDialogAuth(context);
                        } else {
                          ToWithFade(context, const UserGuideScreen());
                        }
                      },
                    ),

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
                        : SizedBox(height: heigth * 0.2),
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
