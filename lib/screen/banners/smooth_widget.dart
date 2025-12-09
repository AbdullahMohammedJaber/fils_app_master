import 'package:fils/utils/theme/color_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../controller/provider/home_notifire.dart';
import '../../utils/storage/storage.dart';

class SmoothWidget extends StatelessWidget {
  const SmoothWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeNotifire>(
      builder: (context, app, child) {
        return Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(app.bannersList.length, (index) {
                return Container(
                  height: 10,
                  width: 10,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color:
                        app.currentPage == index
                            ? purpleColor
                            : getTheme()
                            ? white
                            : grey2,
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
