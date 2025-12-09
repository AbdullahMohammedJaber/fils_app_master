import 'package:easy_localization/easy_localization.dart';
import 'package:fils/utils/global_function/loading_widget.dart';
import 'package:fils/utils/global_function/update_controller.dart';
import 'package:fils/utils/http/http_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fils/controller/provider/app_notifire.dart';
import 'package:fils/controller/provider/floating_button_provider.dart';
import 'package:fils/model/response/notification_response.dart';
import 'package:fils/utils/const.dart';
import 'package:fils/utils/enum/request_type.dart';
import 'package:fils/utils/http/list_pagination.dart';
import 'package:fils/utils/theme/color_manager.dart';
import 'package:fils/widget/defulat_text.dart';
import 'package:fils/widget/item_back.dart';
import 'package:fils/widget/slidable_widget.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    changeDomain1();
    super.initState();
  }

  @override
  void dispose() {
    changeDomain2();
    super.dispose();
  }

  UpdateController updateControllerNotification = UpdateController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FloatingButtonController>(context, listen: false).hide();
    });
    return Consumer<AppNotifire>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(automaticallyImplyLeading: false, toolbarHeight: 0),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                SizedBox(height: heigth * 0.06),
                itemBackAndTitle(context, title: "Notifications".tr()),
                SizedBox(height: heigth * 0.03),
                Expanded(
                  child: PaginatedListWidget(
                    endpoint: "all-notification",
                    updateController: updateControllerNotification,
                    requestType: RequestType.get,
                    parseItem: (json) => Notifications.fromJson(json),
                    itemBuilder: (context, item) {
                      return Slidable(
                        direction: Axis.horizontal,
                        enabled: true,
                        closeOnScroll: true,
                        key: ValueKey(item.id),
                        startActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            Expanded(
                              child: CustomSlideAction(
                                color: const Color(0xffF1673C),
                                imagePath: "assets/icons/delete.svg",
                                onTap: () async {
                                  showBoatToast();
                                  final json = await NetworkHelper.sendRequest(
                                    requestType: RequestType.post,
                                    endpoint:
                                        "notifications/bulk-delete/${item.id}",
                                  );

                                  closeAllLoading();
                                  if (!json.containsKey("errorMessage")) {
                                    updateControllerNotification.update();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        child: Container(
                          height: 80,
                          width: width,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xff898384)),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffE8E2F8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child:
                                        item.image == null
                                            ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image.asset(
                                                "assets/images/fils_logo_f.png",
                                              ),
                                            )
                                            : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image.network(
                                                item.image!,
                                                height: 40,
                                                width: 40,
                                              ),
                                            ),
                                  ),
                                ),
                                SizedBox(width: width * 0.02),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      DefaultText(
                                        item.notificationText,
                                        color: textColor,
                                        overflow: TextOverflow.visible,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      SizedBox(height: heigth * 0.01),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/calendar.svg",
                                              ),
                                              SizedBox(width: width * 0.01),
                                              DefaultText(
                                                item.date,
                                                color: textColor,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: width * 0.05),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    isFirstData: true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
