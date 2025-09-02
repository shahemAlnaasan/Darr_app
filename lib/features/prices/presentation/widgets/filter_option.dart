import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/widgets/app_text.dart';
import 'package:flutter/material.dart';

class FilterOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  const FilterOption({super.key, required this.title, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: context.primaryColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: isSelected ? context.onPrimaryColor : context.primaryColor, width: 2.5),
        boxShadow: const [BoxShadow(color: Color(0x20000000), blurRadius: 5, offset: Offset(0, 4))],
      ),
      child: AppText.bodyMedium(title, fontWeight: FontWeight.bold, color: context.onPrimaryColor, height: 2),
    );
  }
}
