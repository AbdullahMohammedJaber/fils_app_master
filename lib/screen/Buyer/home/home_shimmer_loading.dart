import 'package:flutter/material.dart';


import '../../../utils/const.dart';

class HomeShimmerLoading extends StatelessWidget {
  const HomeShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shimmerBox(height: height * 0.2, width: width),
          const SizedBox(height: 20),

          // Categories
          shimmerTitle(width: width * 0.4),
          const SizedBox(height: 10),
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder:
                  (_, __) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        shimmerCircle(size: 50),
                        const SizedBox(height: 8),
                        shimmerBox(height: 8, width: 40),
                      ],
                    ),
                  ),
            ),
          ),

          const SizedBox(height: 30),

          // Products
          shimmerTitle(width: width * 0.4),
          const SizedBox(height: 10),
          SizedBox(
            height: height * 0.3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder:
                  (_, __) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: shimmerBox(width: width * 0.4, height: height * 0.3),
                  ),
            ),
          ),

          const SizedBox(height: 30),

          // Shops
          shimmerTitle(width: width * 0.4),
          const SizedBox(height: 10),
          Column(
            children: List.generate(
              3,
              (_) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: shimmerBox(width: width, height: height * 0.2),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Related Products
          shimmerTitle(width: width * 0.5),
          const SizedBox(height: 10),
          SizedBox(
            height: height * 0.3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder:
                  (_, __) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: shimmerBox(width: width * 0.4, height: height * 0.3),
                  ),
            ),
          ),

          const SizedBox(height: 30),

          // Suggested Products
          shimmerTitle(width: width * 0.5),
          const SizedBox(height: 10),
          SizedBox(
            height: height * 0.33,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder:
                  (_, __) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: shimmerBox(
                      width: width * 0.4,
                      height: height * 0.33,
                    ),
                  ),
            ),
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }


}
