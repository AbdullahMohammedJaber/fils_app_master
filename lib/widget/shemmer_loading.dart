// ignore_for_file: library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool? isLoading;
  final Widget? child;

  @override
  _ShimmerLoadingState createState() => _ShimmerLoadingState();
}

const _shimmerGradient = LinearGradient(
  colors: [
    Color(0xFFEBEBF4),
    Color(0xFFF4F4F4),
    Color(0xFFEBEBF4),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);

class _ShimmerLoadingState extends State<ShimmerLoading> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading!) {
      return widget.child!;
    }

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return _shimmerGradient.createShader(bounds);
      },
      child: widget.child,
    );
  }
}

class ShimmerImageLoading extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final BoxFit? boxFit;
  final double? width;
  final bool? isRadios;
  final double? rad;
  const ShimmerImageLoading(
      {super.key,
      this.imageUrl,
      this.rad = 0,
      this.height,
      this.width,
      this.boxFit,
      this.isRadios = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(isRadios! ? 50 : rad!),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        placeholder: (context, url) =>
            ShimmerWidget(width: width!, height: height!),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        width: width,
        height: height,
        fit: boxFit,
      ),
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  final double? width;
  final double? height;

  const ShimmerWidget({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    );
  }
}
