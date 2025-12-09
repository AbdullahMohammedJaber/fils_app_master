import 'package:flutter/material.dart';

import '../../../utils/const.dart';
import '../../../widget/grid_view_custom.dart';

class ProductShimmerLoading extends StatelessWidget {
  const ProductShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
        crossAxisCount: 2,
        crossAxisSpacing: 2,
        height: heigth * 0.33,
        mainAxisSpacing: 2,
      ),
      itemBuilder:
          (_, __) => Padding(
            padding: const EdgeInsets.all(10),
            child: shimmerBox(width: width * 0.4, height: height * 0.3),
          ),
      itemCount: 10,
    );
  }
}
