import 'package:fils/model/response/seller/shipping_address_response.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fils/controller/provider/user_notefire.dart';
import 'package:fils/model/response/intro_response.dart';
import 'package:fils/model/response/shop_info_response.dart';
import 'package:fils/model/response/user_response.dart';
import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import '../../model/response/seller/all_shops_response.dart';
import '../../model/response/seller/package_info_response.dart';
import '../../model/response/setting_response.dart';

/////////////////////////// USER SECTION ///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

setUserToken(String token) {
  GetStorage().write("token", token);
}

String? getUserToken() {
  return GetStorage().read("token") ?? "";
}

setUserStorage(UserResponse user) {
  setUserToken(user.accessToken);

  if (user.user!.emailVerified) {
    setLogin(true);
  }
  GetStorage().write("user", user.toJson());
  NavigationService.navigatorKey.currentContext!.setUser = user;
}

UserResponse? getUser() {
  if (!isLogin()) {
    return null;
  }
  return UserResponse.fromJson(GetStorage().read("user"));
}

setLogin(bool login) {
  GetStorage().write("isLogin", login);
}

bool isLogin() {
  return GetStorage().read("isLogin") ?? false;
}

removeUser() {
  GetStorage().remove("user");
  GetStorage().remove("isLogin");
  GetStorage().remove("token");
}

/////////////////////////// SHOP SECTION ///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
setShopInfo(ShopInfoResponse shopResponse) {
  GetStorage().write("shopInfo", shopResponse.toJson());
}

ShopInfoResponse getShopInfo() {
  final data = GetStorage().read("shopInfo");
  return data != null
      ? ShopInfoResponse.fromJson(data)
      : ShopInfoResponse(data: null, success: true, status: 200);
}

/*setCheckCompleteShop(bool check) {
  GetStorage().write("checkShop", check);
}

bool getCheckCompleteShop() {
  return GetStorage().read("checkShop") ?? false;
}*/

setShop(ShopsAll shops) {
  GetStorage().write("shops", shops.toJson());
}

ShopsAll getAllShop() {
  final data = GetStorage().read("shops");
  return data != null
      ? ShopsAll.fromJson(data)
      : ShopsAll(
        id: null,
        name: null,
        address: null,
        logo: null,
        productsCount: null,
        rating: 0,
        slug: null,
        totalSales: 0,
        select: false,
      );
}
//////////////////////////////////////////////////////////////////////////////////
///////////////////////////// LANGUAGE SECTION ///////////////////////////////////

setLang(String lang) {
  GetStorage().write("lang", lang);
}

setShippingAddress(ShippingAddress sh) {
  GetStorage().write("shipping", sh.toJson());
}

ShippingAddress getShippingAddress() {
  final data = GetStorage().read("shipping");
  return data != null
      ? ShippingAddress.fromJson(data)
      : ShippingAddress(id: null, address: null);
}

getLang() {
  return GetStorage().read("lang") ?? "ar";
}

setLocal(String lang) {
  GetStorage().write("local", lang);
}

getLocal() {
  return GetStorage().read("local") ?? "ar";
}

selectLanguage(bool isSelect) {
  GetStorage().write("selectLanguage", isSelect);
}

bool isSelectLanguage() {
  return GetStorage().read("selectLanguage") ?? false;
}
// //////////////////////////////////////////////////////////////////////////
///////////////////////////// FCM SECTION ///////////////////////////////////

setFcmToken(String fcmToken) {
  GetStorage().write("fcm_token", fcmToken);
}

String? getFcmToken() {
  return GetStorage().read("fcm_token") ?? "";
}
// //////////////////////////////////////////////////////////////////////////
///////////////////////////// Setting SECTION ///////////////////////////////

setSettings(SettingResponse settingsResponse) {
  GetStorage().write("settings", settingsResponse.toJson());
}

SettingResponse getSettings() {
  return SettingResponse.fromJson(GetStorage().read("settings"));
}

setIntro(IntroResponse intro) {
  GetStorage().write("intro", intro.toJson());
}

IntroResponse? getIntro() {
  return IntroResponse.fromJson(GetStorage().read("intro"));
}
///// //////////////////////////////////////////////////////////////////////////
///////////////////////////// Setting SECTION ///////////////////////////////

setLanding(bool isSkip) {
  GetStorage().write("landing", isSkip);
}

bool isLanding() {
  return GetStorage().read("landing") ?? false;
}
////////////////////////////////////////////////////////////////////////////

setBalance(double balance) {
  GetStorage().write("balance", balance);
}

double getBalance() {
  return GetStorage().read("balance");
}
/////////////////////////////////////////////////////////////////////////////

setNotifications(bool notifications) {
  GetStorage().write("notifications", notifications);
}

bool isNotifications() {
  return GetStorage().read("notifications") ?? true;
}

setVibration(bool vibrations) {
  GetStorage().write("vibrations", vibrations);
}

bool isVibration() {
  return GetStorage().read("vibrations") ?? true;
}

setSound(bool sound) {
  GetStorage().write("sound", sound);
}

bool isSound() {
  return GetStorage().read("sound") ?? true;
}

///////////////// THEME //////////////////////
///
setTheme(bool theme) {
  GetStorage().write("isDark", theme);
}

bool getTheme() {
  return GetStorage().read("isDark") ?? false;
}

setPackageInfo(PackageInfoResponse package) {
  GetStorage().write("PackageInfoResponse", package.toJson());
}

PackageInfoResponse getPackageInfo() {
  return PackageInfoResponse.fromJson(GetStorage().read("PackageInfoResponse"));
}

setTimeZoon(String zoon) {
  GetStorage().write("zoon", zoon);
}

getTimeZoon() {
  return GetStorage().read("zoon");
}

setShowCaseHomeB(bool set) {
  GetStorage().write("set", set);
}

bool getShowCaseHomeB() {
  return GetStorage().read("set")??false;
}

setShowCaseHomeS(bool set) {
  GetStorage().write("setS", set);
}

bool getShowCaseHomeS() {
  return GetStorage().read("setS")??false;
}
