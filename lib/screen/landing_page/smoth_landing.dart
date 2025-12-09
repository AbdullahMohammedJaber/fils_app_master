import 'package:flutter/material.dart';
import 'package:fils/utils/const.dart';

Widget smothLanding({dynamic page, dynamic length}) {
  return Row(
    children: List.generate(length!, (index) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        height: page == index ? heigth * 0.065 : heigth * 0.04,
        width: width * 0.018,
        decoration: BoxDecoration(
          color:
              page == index ? const Color(0xffA489E2) : const Color(0xffB5B3B3),
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }),
  );
}
