import 'dart:async';

import 'package:exchange_darr/common/consts/app_keys.dart';
import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/widgets/app_text.dart';
import 'package:exchange_darr/common/widgets/custom_text_field.dart';
import 'package:exchange_darr/core/datasources/hive_helper.dart';
import 'package:exchange_darr/features/prices/data/models/get_curs_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_exchage_response.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/update_exchange_syp_usecase.dart';
import 'package:exchange_darr/features/prices/presentation/bloc/prices_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CurrenciesPairs extends StatefulWidget {
  final Price price;
  final List<Cur> curs;
  const CurrenciesPairs({super.key, required this.price, required this.curs});

  @override
  State<CurrenciesPairs> createState() => _CurrenciesPairsState();
}

class _CurrenciesPairsState extends State<CurrenciesPairs> {
  final TextEditingController firstAmountController = TextEditingController();

  final TextEditingController secondAmountController = TextEditingController();

  String buyCurName = "";
  String sellCurName = "";
  String buyCurImage = "";
  String sellCurImage = "";
  String _formatNumber(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(3).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }

  @override
  void initState() {
    firstAmountController.text = _formatNumber(double.tryParse(widget.price.buy) ?? 0);
    secondAmountController.text = _formatNumber(double.tryParse(widget.price.sell) ?? 0);
    final buyCur = widget.curs.firstWhere(
      (cur) => cur.id == widget.price.cur,
      orElse: () => Cur(id: "-1", name: widget.price.cur, img: ""),
    );
    final sellCurCode = widget.price.isSyp ? "syp" : "usd";
    final sellCur = widget.curs.firstWhere(
      (cur) => cur.id == sellCurCode,
      orElse: () => Cur(id: "-1", name: widget.price.cur, img: ""),
    );
    buyCurName = buyCur.name;
    buyCurImage = buyCur.img;
    sellCurName = sellCur.name;
    sellCurImage = sellCur.img;

    super.initState();
  }

  Timer? _debounce;

  void _onPriceChanged(String value, bool isSyp) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(seconds: 1, milliseconds: 500), () {
      updatePrice(isSyp);
    });
  }

  void updatePrice(bool isSyp) async {
    final int? id = await HiveHelper.getFromHive(boxName: AppKeys.userBox, key: AppKeys.userId);
    final params = UpdateExchangeParams(
      id: id.toString(),
      cur: widget.price.cur,
      buy: firstAmountController.text,
      sell: secondAmountController.text,
    );
    context.read<PricesBloc>().add(UpdateExchangeEvent(params: params, isSyp: isSyp));
  }

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
              Image.network(
                buyCurImage,
                width: 27,
                height: 27,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) {
                  return SizedBox.shrink();
                },
              ),

              AppText.titleMedium(
                buyCurName,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                height: 2,
                style: TextStyle(fontSize: 19),
              ),
              Skeleton.ignore(
                child: AppText.titleMedium("-", color: Colors.white, fontWeight: FontWeight.w600, height: 2),
              ),
              AppText.titleMedium(
                sellCurName,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                height: 2,
                style: TextStyle(fontSize: 19),
              ),
              Image.network(
                sellCurImage,
                width: 27,
                height: 27,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) {
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ),

        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: context.primaryContainer,
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
                    child: AppText.bodyLarge("شراء", color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                    child: AppText.bodyLarge("مبيع", color: Colors.white, fontWeight: FontWeight.w600),
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
                      onChanged: (val) => _onPriceChanged(val, widget.price.isSyp),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: buildTextField(
                      hint: "المبلغ",
                      controller: secondAmountController,
                      keyboardType: TextInputType.number,
                      onChanged: (val) => _onPriceChanged(val, widget.price.isSyp),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
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
      filledColor: context.primaryColor,
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
