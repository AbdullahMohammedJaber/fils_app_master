import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:fils/controller/provider/theme_notifire.dart';
import 'package:fils/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:fils/controller/provider/app_notifire.dart';

class CurvedBottomNavigationBar extends StatelessWidget {
  final Color activeColor;
  final Color inactiveColor;
  final Color backgroundColor;

  const CurvedBottomNavigationBar({
    this.activeColor = Colors.orange,
    this.inactiveColor = Colors.grey,
    this.backgroundColor = Colors.white,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppNotifire>(context);
    final items = provider.screenIcons;
    final selectedIndex = provider.selectPageRoot;

    double width = MediaQuery.of(context).size.width;

    return Consumer2<AppNotifire , ThemeProvider>(
      builder: (context , root , theme , child) {
        return SizedBox(
          height: 80,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [

              CustomPaint(
                size: Size(width, 80),
                painter: NavBarPainter(
                  selectedIndex: selectedIndex.toDouble(),
                  itemCount: items.length,
                  backgroundColor: backgroundColor,
                  textDirection: Directionality.of(context),

                ),
              ),

               Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                ),
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(items.length, (index) {
                    bool isSelected = index == selectedIndex;
                    final iconPath = items[index]['icons'];
                    final label = items[index]['title'];

                    return GestureDetector(
                      onTap: () => provider.onClickBottomNavigationBar(index),
                      child: Container(
                        color: Colors.transparent,
                        width: width * 0.23,
                        height: heigth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: isSelected ? 55 : 40,
                              width: isSelected ? 55 : 40,
                              alignment: Alignment.center,
                              transform:
                                  isSelected
                                      ? Matrix4.translationValues(
                                        0,
                                        -15,
                                        0,
                                      ) // ← ترفع الدائرة للأعلى
                                      : Matrix4.identity(),
                              decoration:
                                  isSelected
                                      ? BoxDecoration(
                                        color: activeColor,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      )
                                      : null,
                              child: SvgPicture.asset(
                                iconPath,
                                color: isSelected ? Colors.white : inactiveColor,
                                height: isSelected ? 28 : 25,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isSelected ? "" : label.toString().tr(),
                              style: TextStyle(
                                color: isSelected ? activeColor : inactiveColor,
                                fontSize: 12,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}


class NavBarPainter extends CustomPainter {
  final double selectedIndex;
  final int itemCount;
  final Color backgroundColor;
  final TextDirection textDirection; // ← أضف هذا

  NavBarPainter({
    required this.selectedIndex,
    required this.itemCount,
    required this.backgroundColor,
    required this.textDirection, // ← أضف هذا
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = backgroundColor;
    final path = Path();

    double width = size.width;
    double height = size.height;
    double circleRadius = 35;
    double curveHeight = 50;

    double centerX;

    if (textDirection == TextDirection.rtl) {
      centerX = width - ((selectedIndex + 0.5) * (width / itemCount));
    } else {
      centerX = (selectedIndex + 0.5) * (width / itemCount);
    }

    path.moveTo(0, 0);
    path.lineTo(centerX - circleRadius - 20, 0);

    path.cubicTo(
      centerX - circleRadius,
      0,
      centerX - circleRadius,
      curveHeight,
      centerX,
      curveHeight,
    );

    path.cubicTo(
      centerX + circleRadius,
      curveHeight,
      centerX + circleRadius,
      0,
      centerX + circleRadius + 20,
      0,
    );

    path.lineTo(width, 0);
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();

    canvas.drawShadow(path, Colors.black26, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant NavBarPainter oldDelegate) => true;
}
