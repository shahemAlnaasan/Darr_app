import 'package:flutter/material.dart';

class CustomToggle extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const CustomToggle({super.key, this.initialValue = false, this.onChanged});

  @override
  State<CustomToggle> createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle> with TickerProviderStateMixin {
  late bool isChecked;
  final Duration _duration = Duration(milliseconds: 370);
  late Animation<Alignment> _animation;
  late AnimationController _animationController;
  @override
  void didUpdateWidget(covariant CustomToggle oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialValue != oldWidget.initialValue) {
      isChecked = widget.initialValue;
      if (isChecked) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
    _animationController = AnimationController(vsync: this, duration: _duration);
    if (isChecked) _animationController.value = 1; // start on right side
    _animation = AlignmentTween(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut, reverseCurve: Curves.easeIn));
  }

  void _toggle() {
    setState(() {
      if (_animationController.isCompleted) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
      isChecked = !isChecked;
    });
    widget.onChanged?.call(isChecked);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: _toggle,
          child: Container(
            width: 80,
            height: 40,
            padding: EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: isChecked ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(99),
              boxShadow: [
                BoxShadow(
                  color: (isChecked ? Colors.green : Colors.red).withOpacity(0.6),
                  blurRadius: 10,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                Align(
                  alignment: _animation.value,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
