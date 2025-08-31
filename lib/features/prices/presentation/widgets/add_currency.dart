import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AddCurrency extends StatelessWidget {
  final void Function()? onTap;
  const AddCurrency({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),

        decoration: BoxDecoration(
          color: context.primaryColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: const Color(0x20000000), blurRadius: 5, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.titleLarge("اضف عملة جديدة", color: context.onPrimaryColor, fontWeight: FontWeight.w600),
            Icon(Icons.add_circle_outline_rounded, size: 40, color: context.onPrimaryColor),
          ],
        ),
      ),
    );
  }
}
