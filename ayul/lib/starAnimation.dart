import 'dart:math';
import 'package:flutter/material.dart';

class StarsAnimationScreen extends StatefulWidget {
  const StarsAnimationScreen({super.key});

  @override
  State<StarsAnimationScreen> createState() => _StarsAnimationScreenState();
}

class _StarsAnimationScreenState extends State<StarsAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Star> _stars = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    // Initialize stars after the first frame to access screen size
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      if (!mounted) return;
      setState(() {
        _stars = List.generate(100, (_) => Star(size));
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: StarsPainter(_stars, _controller.value),
            size: MediaQuery.of(context).size,
          );
        },
      ),
    );
  }
}

class Star {
  Offset position;
  double radius;
  Offset velocity;

  Star(Size size)
    : position = Offset(
        Random().nextDouble() * size.width,
        Random().nextDouble() * size.height,
      ),
      radius = Random().nextDouble() * 0.5,
      velocity = Offset(
        (Random().nextDouble() - 0.5) * 0.5,
        (Random().nextDouble() - 0.5) * 0.5,
      );
}

class StarsPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;

  StarsPainter(this.stars, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (var star in stars) {
      // Update position
      star.position += star.velocity;

      // Bounce off boundaries
      if (star.position.dx < 0 || star.position.dx > size.width) {
        star.velocity = Offset(-star.velocity.dx, star.velocity.dy);
      }
      if (star.position.dy < 0 || star.position.dy > size.height) {
        star.velocity = Offset(star.velocity.dx, -star.velocity.dy);
      }

      // Keep star within bounds
      star.position = Offset(
        star.position.dx.clamp(0, size.width),
        star.position.dy.clamp(0, size.height),
      );

      // Draw star
      canvas.drawCircle(star.position, star.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
