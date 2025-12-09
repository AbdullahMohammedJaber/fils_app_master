import 'package:flutter/material.dart';
import 'dart:math';

// ----------------------
// WaveCard المتحرك
// ----------------------
class AnimatedWaveCard extends StatefulWidget {

  final Widget child;
  final Color waveColor;

  const AnimatedWaveCard({
    super.key,

    required this.child,
    this.waveColor = Colors.blueAccent,
  });

  @override
  State<AnimatedWaveCard> createState() => _AnimatedWaveCardState();
}

class _AnimatedWaveCardState extends State<AnimatedWaveCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // التكرار المستمر للموجة
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white, // خلفية المربع
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        children: [
          // الموجة المتحركة
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: WavePainter(
                    widget.waveColor,
                    _controller.value,
                  ),
                );
              },
            ),
          ),
          // محتوى المربع
          Center(child: widget.child),
        ],
      ),
    );
  }
}

// ----------------------
// WavePainter
// ----------------------
class WavePainter extends CustomPainter {
  final Color color;
  final double animationValue;

  WavePainter(this.color, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [color.withOpacity(0.9), color.withOpacity(0.2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 5, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 20.0;
    final speed = animationValue * 2 * pi;

    path.moveTo(0, size.height * 0.4);

    for (double x = 0; x <= size.width; x++) {
      path.lineTo(
        x,
        size.height * 0.6 + sin((x / size.width * 2 * pi) + speed) * waveHeight,
      );
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) => true;
}
