import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/widgets/app_text.dart';
import 'package:exchange_darr/common/widgets/custom_drop_down.dart';
import 'package:exchange_darr/common/widgets/large_button.dart';
import 'package:exchange_darr/features/prices/data/models/get_curs_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_exchage_response.dart';
import 'package:flutter/material.dart';

class AddCurrencyBottomSheet extends StatefulWidget {
  final List<Cur> curs;
  final List<Price> prices;
  const AddCurrencyBottomSheet({super.key, required this.curs, required this.prices});

  @override
  State<AddCurrencyBottomSheet> createState() => _AddCurrencyBottomSheetState();
}

class _AddCurrencyBottomSheetState extends State<AddCurrencyBottomSheet> {
  List<Cur> firstCurs = [];
  List<Cur> secondCurs = [];
  Cur? firstSelectedCur;
  Cur? secondSelectedCur;

  @override
  void initState() {
    firstCurs = widget.curs.where((cur) => cur.id == "usd" || cur.id == "syp").toList();
    final existingCurIds = widget.prices.map((p) => p.cur).toSet();
    secondCurs = widget.curs.where((cur) => !existingCurIds.contains(cur.id)).toList();
    super.initState();
  }

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

            CustomDropdown<Cur>(
              menuList: firstCurs,
              initaValue: firstSelectedCur,
              compareFn: (a, b) => a.id == b.id,
              labelText: "اختر العملة الاولى",
              hintText: "اختر العملة الاولى",
              valueFontSize: 16,
              itemAsString: (cur) => cur.name,
              onChanged: (cur) {
                firstSelectedCur = cur;
              },
            ),
            CustomDropdown<Cur>(
              menuList: secondCurs,
              initaValue: secondSelectedCur,
              compareFn: (a, b) => a.id == b.id,
              labelText: "اختر العملة الثانية",
              hintText: "اختر العملة الثانية",
              valueFontSize: 16,
              itemAsString: (cur) => cur.name,
              onChanged: (cur) {
                secondSelectedCur = cur;
              },
            ),

            LargeButton(onPressed: () {}, text: "اضافة", backgroundColor: context.tertiary, circularRadius: 12),
          ],
        ),
      ),
    );
  }
}
