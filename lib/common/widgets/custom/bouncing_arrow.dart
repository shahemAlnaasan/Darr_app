import 'package:flutter/material.dart';
import 'dart:math';

class BouncingArrow extends StatefulWidget {
  final bool bounceUp; // true = bounce up, false = bounce down
  final double distance; // how much it bounces
  final Duration duration; // bounce duration
  final IconData icon;
  final Color color;

  const BouncingArrow({
    super.key,
    this.bounceUp = true,
    this.distance = 5.0,
    this.duration = const Duration(milliseconds: 800),
    this.icon = Icons.arrow_upward,
    this.color = Colors.white,
  });

  @override
  _BouncingArrowState createState() => _BouncingArrowState();
}

class _BouncingArrowState extends State<BouncingArrow> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Randomize start to avoid sync
    final random = Random();
    final initialValue = random.nextDouble();

    _controller = AnimationController(vsync: this, duration: widget.duration)..forward(from: initialValue);

    _animation = Tween<double>(
      begin: 0,
      end: widget.bounceUp ? -widget.distance : widget.distance,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(offset: Offset(0, _animation.value), child: child);
      },
      child: Icon(widget.icon, color: widget.color, size: 48),
    );
  }
}
