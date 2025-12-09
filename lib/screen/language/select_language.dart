import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/controller/static/splash_controller.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/button_widget.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectLanguage extends StatelessWidget {
  SelectLanguage({super.key});

  final GlobalKey _buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppNotifire>(builder: (context, controller, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: heigth * 0.06, width: width),
            DefaultText("Select preferred language".tr(),
                fontSize: 16, fontWeight: FontWeight.w600),
            SizedBox(height: heigth * 0.06, width: width),
            GestureDetector(
              key: _buttonKey,
              onTap: () async {
                final RenderBox renderBox =
                    _buttonKey.currentContext!.findRenderObject() as RenderBox;
                final Offset offset = renderBox.localToGlobal(Offset.zero);
                final Size size = renderBox.size;
                final selected = await showMenu<String>(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    offset.dx,
                    offset.dy + size.height,
                    offset.dx + size.width,
                    offset.dy,
                  ),
                  items: controller.LanguageList.map((lang) {
                    return PopupMenuItem<String>(
                      value: lang['type'],
                      child: DefaultText(lang['name']!),
                    );
                  }).toList(),
                );

                if (selected != null) {
                  controller.changeSelectedLanguage(context, selected);
                }
              },
              child: Container(
                height: heigth * 0.06,
                width: width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: grey6,
                  border: Border.all(color: textColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DefaultText(
                        controller.selectedLanguage ?? "Select Language".tr(),
                        fontSize: 14,
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: heigth * 0.1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ButtonWidget(
                onTap: () {
                  SplashController().getIntroRequest(context , loading: true);
                },
                title: "Next".tr(),
              ),
            ),
          ],
        );
      }),
    );
  }
}
