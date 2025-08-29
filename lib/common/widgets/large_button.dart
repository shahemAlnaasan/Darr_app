import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  final void Function() onPressed;
  final String? icon;
  final String text;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final bool isFlexible;
  final bool isOutlined;
  final double circularRadius;
  final double? height;
  final double? width;
  final Widget? child;

  const LargeButton({
    required this.onPressed,
    required this.text,
    this.textStyle,
    this.icon,
    this.backgroundColor,
    this.isFlexible = false,
    this.isOutlined = false,
    this.circularRadius = 5.0,
    this.height,
    this.width,
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        padding: !isFlexible ? const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0) : null,
        decoration: isOutlined
            ? BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(circularRadius),
                border: Border.all(color: context.primaryColor, width: 1),
              )
            : BoxDecoration(
                color: backgroundColor,
                // border: Border.all(color: context.primaryColor, width: 1.5),
                borderRadius: BorderRadius.circular(circularRadius),
              ),
        child:
            child ??
            (icon == null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(icon!, scale: 7),
                        Text(
                          text,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
      ),
    );
  }
}
