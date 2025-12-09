import 'package:easy_localization/easy_localization.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/storage/storage.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defualt_text_form_faild.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBoot extends StatelessWidget {
  const ChatBoot({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController questionController = TextEditingController();
    return Consumer<AppNotifire>(
      builder: (context, app, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child:
                    app.chatBotList.isEmpty
                        ? Center(
                          child: DefaultText(
                            "Start Chat with bot !".tr(),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: blackColor,
                          ),
                        )
                        : ListView.builder(
                          itemBuilder: (context, index) {
                            if (app.chatBotList[index].id == 1) {
                              return buildMyMessage(
                                create_at: app.chatBotList[index].create_at,
                                message: app.chatBotList[index].message,
                              );
                            } else {
                              return buildYourMessage(
                                create_at: app.chatBotList[index].create_at,
                                message: app.chatBotList[index].message,
                                isSeen: app.chatBotList[index].isSeen,
                              );
                            }
                          },
                          itemCount: app.chatBotList.length,
                          reverse: true,
                        ),
              ),
              SizedBox(height: heigth * 0.01),
              TextFormFieldWidget(
                controller: questionController,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.send,
                isIcon: true,
                pathIcon: "assets/icons/send.svg",
                hintText: "Write question ...".tr(),
                ontapIcon: () {
                  app.sendQuestion(questionController.text);
                  questionController.clear();
                },
                onTapDoneKey: (value) {
                  app.sendQuestion(questionController.text);
                  questionController.clear();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildMyMessage({dynamic message, required DateTime create_at}) {
    var time = DateFormat('hh:mm a', getLang()).format(create_at.toLocal());

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: width * 0.7),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: message != null ? primaryColor : Colors.transparent,
            borderRadius: const BorderRadiusDirectional.only(
              bottomStart: Radius.circular(0),
              bottomEnd: Radius.circular(10),
              topEnd: Radius.circular(10),
              topStart: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: DefaultText(
              message,
              color: white,
              type: FontType.medium,
              fontSize: 14,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              DefaultText(
                time,
                color: grey2,
                fontSize: 10,
                type: FontType.bold,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildYourMessage({
    dynamic message,
    required DateTime create_at,
    required bool isSeen,
  }) {
    var time = DateFormat("hh:mm a", getLang()).format(create_at.toLocal());

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              DefaultText(
                time,
                color: grey2,
                fontSize: 10,
                type: FontType.bold,
              ),
            ],
          ),
        ),
        isSeen
            ? Container(
              constraints: BoxConstraints(maxWidth: width * 0.7),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(
                color: Color(0xffFAFAFA),
                borderRadius: BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(10),
                  bottomEnd: Radius.circular(0),
                  topEnd: Radius.circular(10),
                  topStart: Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  child: DefaultText(
                    message,
                    color: const Color(0xff0F1828),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            )
            : const TypingIndicator(color: Colors.blue, size: 6.0),
      ],
    );
  }
}

class TypingIndicator extends StatefulWidget {
  final Color color;
  final double size;

  const TypingIndicator({super.key, this.color = Colors.grey, this.size = 8.0});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation1;
  late Animation<double> animation2;
  late Animation<double> animation3;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    animation1 = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );
    animation2 = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );
    animation3 = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder:
          (context, child) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
            transform: Matrix4.translationValues(0, -animation.value, 0),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(animation1),
        _buildDot(animation2),
        _buildDot(animation3),
      ],
    );
  }
}
