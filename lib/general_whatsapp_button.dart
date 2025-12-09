import 'dart:io';

import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GeneralWhatsappButton extends StatefulWidget {
  const GeneralWhatsappButton({super.key});

  @override
  State<GeneralWhatsappButton> createState() => _GeneralWhatsappButtonState();
}

class _GeneralWhatsappButtonState extends State<GeneralWhatsappButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 20).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FloatingButtonController>(
      builder: (context, controller, child) {
        return controller.showButton
            ? Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.09),
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Container(
                      margin: EdgeInsets.only(
                        bottom: _animation.value,
                      ),
                      child: FloatingActionButton(
                        onPressed: () async {
                          String message = Uri.encodeComponent("");
                          String phoneNumber = "+96569055541";

                          String androidUrl =
                              "whatsapp://send?phone=$phoneNumber&text=$message";
                          String iosUrl =
                              "https://wa.me/$phoneNumber?text=$message";

                          if (Platform.isIOS) {
                            await launchUrlString(iosUrl);
                          } else {
                            await launchUrlString(androidUrl);
                          }
                        },
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            "assets/images/whatsapp.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            : const SizedBox();
      },
    );
  }
}
