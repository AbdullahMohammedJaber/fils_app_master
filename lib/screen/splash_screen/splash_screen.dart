import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:fils/screen/language/select_language.dart';
import 'package:fils/utils/NavigatorObserver/Navigator_observe.dart';
import 'package:fils/utils/route/route.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/controller/static/splash_controller.dart';
import 'package:fils/utils/const.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool animate = true;
  bool _isVisible = false;

  _init() async {
    Future.delayed(const Duration(seconds: 4), () async {

      final url = Uri.parse("https://get.geojs.io/v1/ip/geo.json");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data.toString());
        setTimeZoon(data["timezone"]);
        if (!isSelectLanguage()) {
          toRemoveAll(
            NavigationService.navigatorKey.currentContext!,
            SelectLanguage(),
          );
        } else {
          SplashController().getIntroRequest(
            NavigationService.navigatorKey.currentContext!,
          );
        }
      }

    });
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      setState(() {
        _isVisible = true;
      });
    });
    _init();
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    heigth = MediaQuery.of(context).size.height;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: primaryDarkColor,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/test/up_splash.png",
            fit: BoxFit.contain,
            width: width,
          ),
          AnimatedSlide(
            curve: Curves.easeInOutQuart,
            offset: Offset(0, _isVisible ? 0 : 10),
            duration: const Duration(seconds: 2),
            onEnd: () {},
            child: SizedBox(
              width: width,
              child: Center(
                child: FadeTransition(
                  opacity: _animation,
                  child: Image.asset("assets/test/logo_splash_new.png"),
                ),
              ),
            ),
          ),

          Image.asset(
            "assets/test/down_splash.png",
            fit: BoxFit.cover,
            width: width,
          ),
        ],
      ),
    );
  }
}
