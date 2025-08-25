import 'package:flutter/material.dart';
import '../extentions/colors_extension.dart';
import 'package:intl/intl.dart';

class DateDropdownField extends StatelessWidget {
  final DateTime? selectedDate;
  final void Function(DateTime?) onChanged;

  const DateDropdownField({super.key, required this.selectedDate, required this.onChanged});

  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDate = selectedDate ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: context.colorScheme.copyWith(
              primary: context.onPrimaryColor.withAlpha(50),
              onPrimary: context.onPrimaryColor,
              surface: context.surface,
              onSurface: context.onSurface,
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(context.onPrimaryColor),
                textStyle: WidgetStateProperty.all(
                  Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: context.onPrimaryColor,
                    fontWeight: FontWeight.w600, // 👈 your change here
                  ),
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10);
    final formattedDate =
        selectedDate != null
            ? DateFormat('dd/MM/yyyy').format(selectedDate!)
            : DateFormat('dd/MM/yyyy').format(DateTime.now()); // fallback display

    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: context.colorScheme.outline, width: 2),
          borderRadius: borderRadius,
          color: context.colorScheme.surface,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formattedDate,
              style: context.textTheme.titleSmall!.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: context.colorScheme.onSurface),
          ],
        ),
      ),
    );
  }
}
