import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/theme/text_theme.dart';
import 'package:flutter/material.dart';

class SosDropdown extends StatefulWidget {
  final String dropDownTitle;
  final Widget childrens;
  final Widget? initChild;
  const SosDropdown({super.key, required this.dropDownTitle, this.childrens = const SizedBox.shrink(), this.initChild});

  @override
  State<SosDropdown> createState() => _SosDropdownState();
}

class _SosDropdownState extends State<SosDropdown> with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final initChild = widget.initChild ?? const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Column(
            spacing: 10,
            children: [
              Container(
                width: 390,
                height: 60,
                decoration: BoxDecoration(
                  color: context.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [BoxShadow(color: Color(0x20000000), blurRadius: 5, offset: Offset(0, 4))],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.dropDownTitle,
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium!.copyWith(fontSize: 20, color: context.onPrimaryColor),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          isExpanded ? "اخفاء" : "عرض المزيد",
                          textAlign: TextAlign.center,
                          style: textTheme.titleMedium!.copyWith(fontSize: 14, color: context.onPrimaryColor),
                        ),

                        Icon(
                          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: context.onPrimaryColor,
                          size: 25,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastLinearToSlowEaseIn,
                child: ConstrainedBox(
                  constraints: isExpanded ? const BoxConstraints(maxHeight: 0) : const BoxConstraints(),
                  child: Container(
                    decoration: BoxDecoration(
                      // boxShadow: const [BoxShadow(color: Color(0x20000000), blurRadius: 5, offset: Offset(0, 4))],
                    ),
                    child: isExpanded ? SizedBox.shrink() : initChild,
                  ),
                ),
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.fastLinearToSlowEaseIn,
          child: ConstrainedBox(
            constraints: isExpanded ? const BoxConstraints() : const BoxConstraints(maxHeight: 0),
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  // boxShadow: const [BoxShadow(color: Color(0x20000000), blurRadius: 5, offset: Offset(0, 4))],
                ),
                child: SingleChildScrollView(child: widget.childrens),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
