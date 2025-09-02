import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SosDropdown extends StatefulWidget {
  final String dropDownTitle;
  final String? icon;
  final Widget childrens;
  final Widget? initChild;
  final bool isAtm;
  final void Function()? onDetailsTap;
  const SosDropdown({
    super.key,
    required this.dropDownTitle,
    this.childrens = const SizedBox.shrink(),
    this.initChild,
    this.onDetailsTap,
    this.isAtm = false,
    this.icon,
  });

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
        Column(
          spacing: 8,
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: context.primaryColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [BoxShadow(color: Color(0x20000000), blurRadius: 5, offset: Offset(0, 4))],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: widget.isAtm ? widget.onDetailsTap : () {},
                      child: Row(
                        spacing: 5,
                        children: [
                          if (widget.isAtm)
                            Skeleton.ignore(
                              child: Image.network(
                                widget.icon ?? "",
                                width: 40,
                                height: 40,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                              ),
                            ),
                          Expanded(
                            child: Text(
                              widget.dropDownTitle,
                              textAlign: TextAlign.start,
                              style: textTheme.titleMedium!.copyWith(fontSize: 18, color: context.onPrimaryColor),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Skeleton.ignore(
                            child: Text(
                              isExpanded ? "اخفاء" : "عرض المزيد",
                              textAlign: TextAlign.center,
                              style: textTheme.titleMedium!.copyWith(fontSize: 14, color: context.onPrimaryColor),
                            ),
                          ),
                          Icon(
                            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: context.onPrimaryColor,
                            size: 25,
                          ),
                        ],
                      ),
                    ),
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
        AnimatedSize(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.fastLinearToSlowEaseIn,
          child: ConstrainedBox(
            constraints: isExpanded ? const BoxConstraints() : const BoxConstraints(maxHeight: 0),
            child: Container(
              decoration: BoxDecoration(
                // boxShadow: const [BoxShadow(color: Color(0x20000000), blurRadius: 5, offset: Offset(0, 4))],
              ),
              child: SingleChildScrollView(child: widget.childrens),
            ),
          ),
        ),
      ],
    );
  }
}
