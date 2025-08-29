import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/widgets/app_text.dart';
import 'package:exchange_darr/common/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class CurrenciesPairs extends StatefulWidget {
  const CurrenciesPairs({super.key});

  @override
  State<CurrenciesPairs> createState() => _CurrenciesPairsState();
}

class _CurrenciesPairsState extends State<CurrenciesPairs> {
  final TextEditingController firstAmountController = TextEditingController();

  final TextEditingController secondAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: context.onTertiary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: const Color(0x20000000), blurRadius: 5, offset: const Offset(0, 0))],
          ),
          child: Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // AppText.titleLarge("اضف عملة جديدة", color: context.primaryColor, fontWeight: FontWeight.w600),
              AppText.titleMedium("دولار", color: context.primaryColor, fontWeight: FontWeight.w600, height: 2),
              AppText.titleMedium("-", color: context.primaryColor, fontWeight: FontWeight.w600, height: 2),
              AppText.titleMedium("يورو", color: context.primaryColor, fontWeight: FontWeight.w600, height: 2),
            ],
          ),
        ),

        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: context.onTertiary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: const Color(0x20000000), blurRadius: 5, offset: const Offset(0, 0))],
          ),
          child: Column(
            spacing: 15,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: AppText.bodyLarge("شراء", color: context.primaryColor, fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                    child: AppText.bodyLarge("مبيع", color: context.primaryColor, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: buildTextField(
                      hint: "المبلغ",
                      controller: firstAmountController,
                      keyboardType: TextInputType.number,

                      onChanged: (p0) {},
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: buildTextField(
                      hint: "المبلغ",
                      controller: firstAmountController,
                      keyboardType: TextInputType.number,
                      onChanged: (p0) {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTextField({
    required String hint,
    required TextEditingController controller,
    void Function(String)? onChanged,
    String validatorTitle = "",
    int mxLine = 1,
    Widget? sufIcon,
    bool? readOnly,
    dynamic Function()? onTap,
    TextInputType? keyboardType,
    bool needValidation = true,
    FocusNode? focusNode,
    FocusNode? focusOn,
  }) {
    return CustomTextField(
      textAlign: TextAlign.center,
      onTap: onTap,
      readOnly: readOnly,
      onChanged: onChanged,
      keyboardType: keyboardType,
      mxLine: mxLine,
      controller: controller,
      hint: hint,
      focusNode: focusNode,
      focusOn: focusOn,
      filledColor: context.tertiary,
      validator: needValidation
          ? (value) {
              if (value == null || value.isEmpty) {
                return validatorTitle.isNotEmpty ? validatorTitle : "";
              }
              return null;
            }
          : null,
      sufIcon: sufIcon,
    );
  }
}
