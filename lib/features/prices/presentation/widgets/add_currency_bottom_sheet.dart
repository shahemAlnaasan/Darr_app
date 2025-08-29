import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/widgets/app_text.dart';
import 'package:exchange_darr/common/widgets/custom_drop_down.dart';
import 'package:exchange_darr/common/widgets/large_button.dart';
import 'package:flutter/material.dart';

class AddCurrencyBottomSheet extends StatelessWidget {
  const AddCurrencyBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),

        decoration: BoxDecoration(
          color: context.tertiary,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: const Color(0x20000000), blurRadius: 5, offset: const Offset(0, 0))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText.titleLarge("اضف عملة جديدة", color: context.primaryColor, fontWeight: FontWeight.w600),

            // CustomDropdown<ExchangePair>(
            //   menuList: exchangePairs,
            //   initaValue: exchangePairs.isNotEmpty ? exchangePairs[0] : null,
            //   compareFn: (a, b) => a.buy?.curfrom == b.buy?.curfrom && a.buy?.curto == b.buy?.curto,
            //   labelText: "اختر العملات",
            //   hintText: "اختر العملات",
            //   valueFontSize: 16,
            //   itemAsString: (pair) =>
            //       "${getCurrencyObject(pair.buy?.curfrom ?? "")!.name} - ${getCurrencyObject(pair.buy?.curto ?? "")!.name}",
            //   onChanged: (pair) {
            //     if (pair != null) {
            //       widget.onPairSelected(pair); // ✅ send to parent
            //     }
            //   },
            // ),
            CustomDropdown<String>(
              menuList: [],
              initaValue: "asfsa",
              labelText: "LocaleKeys",
              hintText: "LocaleKeys",
              compareFn: (p0, p1) => p0 == p1,
              onChanged: (value) {},
            ),
            CustomDropdown<String>(
              menuList: [],
              initaValue: "asfsa",
              labelText: "LocaleKeys",
              hintText: "LocaleKeys",
              compareFn: (p0, p1) => p0 == p1,
              onChanged: (value) {},
            ),

            LargeButton(onPressed: () {}, text: "اضافة", backgroundColor: context.tertiary, circularRadius: 12),
          ],
        ),
      ),
    );
  }
}
