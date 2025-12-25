// ignore_for_file: deprecated_member_use, use_super_parameters, library_private_types_in_public_api, unused_field, unnecessary_null_comparison

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/edit_product_notifire.dart';
import 'package:fils/controller/provider/home_notifire.dart';
import 'package:fils/controller/provider/theme_notifire.dart';
import 'package:fils/general_whatsapp_button.dart';
import 'package:fils/screen/Buyer/product/details_product/details_product_screen.dart';
import 'package:fils/screen/Buyer/product/product_into_store.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/fcm/fcm_config.dart';
import 'package:fils/utils/theme/dark_theme.dart';
import 'package:fils/widget/confetti_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/controller/provider/aucation_notifier.dart';
import 'package:fils/controller/provider/auth_notifire.dart';
import 'package:fils/controller/provider/cart_notifire.dart';
import 'package:fils/controller/provider/filter_search_notifier.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/controller/provider/order_notifire.dart';
import 'package:fils/controller/provider/store_notofire.dart';
import 'package:fils/controller/provider/user_notefire.dart';
import 'package:fils/controller/provider/vedio_notifire.dart';
import 'package:fils/controller/provider/wallet_notifire.dart';
import 'package:fils/screen/splash_screen/splash_screen.dart';
import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:fils/utils/theme/theme_manager.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'controller/provider/product_notifire.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  /* await MobileAds.instance.initialize();
  RequestConfiguration configuration = RequestConfiguration(
    testDeviceIds: ["581CEAFCD9BA73FEF3BED63F09AD8C4E"],
  );
  MobileAds.instance.updateRequestConfiguration(configuration);*/
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final packageInfo = await PackageInfo.fromPlatform();
  info = packageInfo.version;
  await GetStorage.init();

  await httpHelperIni();

  firebaseMessagingIni();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    print('Caught by FlutterError.onError: ${details.exceptionAsString()}');
  };
  runApp(
    EasyLocalization(
      path: 'language',
      fallbackLocale: const Locale('ar', ''),
      startLocale: const Locale('ar', ''),
      useOnlyLangCode: true,
      supportedLocales: const [
        Locale('en', ''),
        Locale('ar', ''),
        Locale('fa', ''),
        Locale('ur', ''),
        Locale('de', ''),
      ],
      child: DevicePreview(
          enabled: !kReleaseMode,
          builder: (context) => RestartWidget(child: MyApp())),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final botToastBuilder = BotToastInit();
  late final AppLinks _appLinks;
  late final StreamSubscription<Uri> _linkSubscription;
  Uri? _initialUri;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        debugPrint("🔗 Initial deep link: $uri");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleAppLink(uri);
        });
      }
    } catch (e) {
      debugPrint("⚠️ Error getting initial link: $e");
    }

    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        if (uri != null) {
          debugPrint("🔗 Stream deep link: $uri");
          _handleAppLink(uri);
        }
      },
      onError: (err) {
        debugPrint("❌ Deep link stream error: $err");
      },
    );
  }

  void _handleAppLink(Uri uri) {
    debugPrint("📌 استقبلنا الرابط: $uri");

    // 🟢 النظام الجديد (filsapp://product/123 أو filsapp://store/45)
    if (uri.scheme == 'filsapp') {
      if (uri.host == 'product' && uri.pathSegments.isNotEmpty) {
        final productId = uri.pathSegments.first;
        debugPrint("🟢 نظام جديد: المنتج $productId");
        _openProduct(productId);
        return;
      }

      if (uri.host == 'store' && uri.pathSegments.isNotEmpty) {
        final storeId = uri.pathSegments.first;
        debugPrint("🟢 نظام جديد: المتجر $storeId");
        _openStore(storeId);
        return;
      }
    }

    // 🟡 النظام القديم عبر HTTPS - منتج
    if (uri.host == 'dashboard.fils.app' &&
        uri.pathSegments.length >= 4 &&
        uri.pathSegments[0] == 'api' &&
        uri.pathSegments[1] == 'v1' &&
        uri.pathSegments[2] == 'product') {
      final productId = uri.pathSegments[3];
      debugPrint("🟡 نظام قديم: المنتج $productId");
      _openProduct(productId);
      return;
    }

    // 🟡 النظام القديم عبر HTTPS - متجر
    if (uri.host == 'dashboard.fils.app' &&
        uri.pathSegments.length >= 4 &&
        uri.pathSegments[0] == 'api' &&
        uri.pathSegments[1] == 'v1' &&
        uri.pathSegments[2] == 'store') {
      final storeId = uri.pathSegments[3];
      debugPrint("🟡 نظام قديم: المتجر $storeId");
      _openStore(storeId);
      return;
    }

    // 🔵 صفحة الهبوط: https://dashboard.fils.app/open/product.html?id=70
    // 🔵 صفحة الهبوط: https://dashboard.fils.app/open/store.html?id=70
    if (uri.host == 'dashboard.fils.app' &&
        uri.pathSegments.isNotEmpty &&
        uri.pathSegments[0] == 'open' &&
        uri.pathSegments.length >= 2 &&
        uri.pathSegments[1].startsWith('product') && // product أو product.html
        uri.queryParameters.containsKey('id')) {
      final id = uri.queryParameters['id'];
      if (id != null) {
        debugPrint("🔵 صفحة هبوط: المنتج $id");
        _openProduct(id);
      }
      return;
    }

    if (uri.host == 'dashboard.fils.app' &&
        uri.pathSegments.isNotEmpty &&
        uri.pathSegments[0] == 'open' &&
        uri.pathSegments.length >= 2 &&
        uri.pathSegments[1].startsWith('store') && // product أو product.html
        uri.queryParameters.containsKey('id')) {
      final id = uri.queryParameters['id'];
      if (id != null) {
        debugPrint("🔵 صفحة هبوط: المتجر $id");
        _openStore(id);
      }
      return;
    }

    debugPrint("⚠️ الرابط لا يطابق أي نمط معروف: $uri");
  }

  void _openProduct(String productId) {
    debugPrint("🛒 فتح صفحة المنتج رقم: $productId");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NavigationService.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => DetailsProductScreen(idProduct: productId),
        ),
      );
    });
  }

  void _openStore(String storeId) {
    debugPrint("🏬 فتح المتجر رقم: $storeId");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NavigationService.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder:
              (_) => ProductsIntoStoreScreen(
                idStore: storeId,
                address: '',
                nameStore: '',
              ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _linkSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AppNotifire()),
        ChangeNotifierProvider(create: (context) => HomeNotifire()),
        ChangeNotifierProvider(create: (context) => CartNotifire()),
        ChangeNotifierProvider(create: (context) => StoreNotifire()),
        ChangeNotifierProvider(create: (context) => OrderNotifier()),
        ChangeNotifierProvider(create: (context) => FilterSearchNotifier()),
        ChangeNotifierProvider(create: (context) => AuthNotifire()),
        ChangeNotifierProvider(create: (context) => UserNotifier()),
        ChangeNotifierProvider(create: (context) => AuctionNotifier()),

        ChangeNotifierProvider(create: (context) => WalletNotifire()),
        ChangeNotifierProvider(create: (context) => FloatingButtonController()),
        ChangeNotifierProvider(create: (context) => ProductNotifire()),
        ChangeNotifierProvider(create: (context) => EditProductNotifire()),

      ],
      child: Consumer2<AppNotifire, ThemeProvider>(
        builder: (context, app, theme, child) {
          return MaterialApp(
            navigatorKey: NavigationService.navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'FILS',
            theme: getApplicationTheme(),
            darkTheme: getApplicationThemeDark(),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            navigatorObservers: [BotToastNavigatorObserver()],
            locale: context.locale,
            routes: {
              '/api/v1/store/':
                  (context) => ProductsIntoStoreScreen(
                    idStore: '',
                    address: '',
                    nameStore: '',
                  ),
            },
            home: SplashScreen(),
            themeMode: theme.themeMode,
            // themeMode: ThemeMode.light,
            builder: (context, child) {
              child = botToastBuilder(context, child);
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Scaffold(
                  body: Stack(
                    children: [
                      child,
                      VictoryConfetti(play: app.isShowConfetti),
                    ],
                  ),
                  floatingActionButton: const GeneralWhatsappButton(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RestartWidget extends StatefulWidget {
  final Widget? child;

  const RestartWidget({Key? key, this.child}) : super(key: key);

  @override
  _RestartWidgetState createState() => _RestartWidgetState();

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: key, child: widget.child!);
  }
}
