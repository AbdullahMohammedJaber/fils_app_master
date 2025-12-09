import 'package:fils/screen/Seller/store/create_store/screen/add_store.dart';
import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import 'package:fils/utils/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import '../../../../controller/provider/app_notifire.dart';
import '../../../../model/response/user_response.dart';
import '../../../../utils/enum/request_type.dart';
import '../../../../utils/global_function/loading_widget.dart';
import '../../../../utils/http/http_helper.dart';
import '../../../../utils/http/service.dart';
import '../../../../utils/route/route.dart';
import '../../../../utils/storage/storage.dart';
import '../../../general/root_app.dart';
import '../../virefy_code_signup.dart';

class LoginNotifire extends ChangeNotifier {
  final keyForLogin = GlobalKey<FormState>();
  final emailControllerForLogin = TextEditingController();
  final passwordControllerForLogin = TextEditingController();
  bool visiblePasswordForLogin = true;
  String userType = "customer";
  bool checkP = false;
  changeCheckP() {
    if (checkP == false) {
      checkP = true;
    } else {
      checkP = false;
    }

    notifyListeners();
  }

  changeUserType(String type) {
    userType = type;
    notifyListeners();
  }

  changeVisabiltyPasswordForLogin() {
    visiblePasswordForLogin = !visiblePasswordForLogin;
    notifyListeners();
  }

  signIn(BuildContext context , String zipCode) async {
    changeDomain1();
    showBoatToast();
    String email = emailControllerForLogin.text;
    var json = await NetworkHelper.sendRequest(
      requestType: RequestType.post,
      endpoint: login,
      fields: {
        "phone":"$zipCode${emailControllerForLogin.text}",
        "password": passwordControllerForLogin.text,
        "user_type": userType,
      },
    );
    closeAllLoading();

    UserResponse userResponse = UserResponse.fromJson(json);
    if (userResponse.user != null) {
      if (userResponse.user!.emailVerified == false) {
        await resendCodeSignup(
          NavigationService.navigatorKey.currentContext!,
          email,
        );

        ToWithFade(
          NavigationService.navigatorKey.currentContext!,
          VirefyCodeSignup(email: email),
        );
      } else {
        setUserStorage(userResponse);
        notifyListeners();
        NavigationService.navigatorKey.currentContext!
            .read<AppNotifire>()
            .onClickBottomNavigationBar(0);
        GetStorage().remove("shops");
        GetStorage().remove("PackageInfoResponse");
        GetStorage().remove("checkShop");
        GetStorage().remove("shopInfo");
         if(userResponse.user!.type=="seller" && userResponse.user!.shops_count==0){
            ToWithFade(context, AddStoreSeller(isComeSignup: true));
         }else{
           toRemoveAll(
             NavigationService.navigatorKey.currentContext!,
             const RootAppScreen(),
           );
        }

      }
    }
  }

  @override
  void dispose() {
    emailControllerForLogin.dispose();
    passwordControllerForLogin.dispose();
    visiblePasswordForLogin = true;
    userType = "customer";
    super.dispose();
  }
}
