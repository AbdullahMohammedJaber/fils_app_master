import 'package:fils/utils/const.dart';
import 'package:flutter/material.dart';

import 'defulat_text.dart';

class HintBubble extends StatefulWidget {
  final Widget child;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Duration duration;

  const HintBubble({
    super.key,
    required this.child,
    required this.text,
    this.backgroundColor = const Color(0xFFDCF0FF),
    this.textColor = Colors.black87,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<HintBubble> createState() => _HintBubbleState();
}

class _HintBubbleState extends State<HintBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _visible = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) {
            setState(() => _visible = false);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        widget.child,
        if (_visible)
          Positioned(
            bottom: -60,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    CustomPaint(
                      size: const Size(12, 6),
                      painter: TrianglePainter(color: widget.backgroundColor),
                    ),
                    Container(
                      width: width * 0.35,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: widget.backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DefaultText(
                        widget.text,
                        fontSize: 12,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Path path =
        Path()
          ..moveTo(0, size.height) // اليسار
          ..lineTo(size.width / 2, 0) // الأعلى (رأس السهم)
          ..lineTo(size.width, size.height) // اليمين
          ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
