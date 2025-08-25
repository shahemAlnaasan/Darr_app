import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/theme/text_theme.dart';
import 'package:flutter/material.dart';

class SosDropdown extends StatefulWidget {
  final String dropDownTitle;
  final Widget childrens;
  const SosDropdown({super.key, required this.dropDownTitle, this.childrens = const SizedBox.shrink()});

  @override
  State<SosDropdown> createState() => _SosDropdownState();
}

class _SosDropdownState extends State<SosDropdown> with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
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
          child: Container(
            width: 390,
            height: 60,
            decoration: BoxDecoration(color: context.surfaceContainer, borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.dropDownTitle,
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium!.copyWith(fontSize: 20, color: Colors.white),
                ),
                Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white, size: 30),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.fastLinearToSlowEaseIn,
          child: ConstrainedBox(
            constraints: isExpanded ? const BoxConstraints() : const BoxConstraints(maxHeight: 0),
            child: Padding(padding: const EdgeInsets.only(top: 10.0), child: widget.childrens),
          ),
        ),
      ],
    );
  }
}
