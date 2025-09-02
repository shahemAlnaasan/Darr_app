import 'package:exchange_darr/common/consts/app_keys.dart';
import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/extentions/navigation_extensions.dart';
import 'package:exchange_darr/common/state_managment/bloc_state.dart';
import 'package:exchange_darr/common/widgets/app_text.dart';
import 'package:exchange_darr/common/widgets/custom_drop_down.dart';
import 'package:exchange_darr/common/widgets/custom_progress_indecator.dart';
import 'package:exchange_darr/common/widgets/large_button.dart';
import 'package:exchange_darr/core/datasources/hive_helper.dart';
import 'package:exchange_darr/features/prices/data/models/get_curs_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_exchage_response.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/add_exchange_syp_usecase.dart';
import 'package:exchange_darr/features/prices/presentation/bloc/prices_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCurrencyBottomSheet extends StatefulWidget {
  final List<Cur> curs;
  final List<Price> prices;
  const AddCurrencyBottomSheet({super.key, required this.curs, required this.prices});

  @override
  State<AddCurrencyBottomSheet> createState() => _AddCurrencyBottomSheetState();
}

class _AddCurrencyBottomSheetState extends State<AddCurrencyBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  List<Cur> firstCurs = [];
  List<Cur> secondCurs = [];
  Cur? firstSelectedCur;
  Cur? secondSelectedCur;
  String? singleSelectValidator(value) {
    if (value == null) {
      return "الرجاء اختيار العملة";
    }
    return null;
  }

  @override
  void initState() {
    firstCurs = widget.curs.where((cur) => cur.id == "usd" || cur.id == "syp").toList();
    final existingCurIds = widget.prices.map((p) => p.cur).toSet();
    secondCurs = widget.curs.where((cur) => !existingCurIds.contains(cur.id)).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PricesBloc, PricesState>(
      listener: (context, state) {
        if (state.addExchangeStatus == Status.success) {
          context.read<PricesBloc>().add(GetCursEvent());
          context.pop();
        }
      },
      child: Form(
        key: _formKey,
        child: Dialog(
          // elevation: 0,
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            decoration: BoxDecoration(
              color: context.background,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: const Color(0x20000000), blurRadius: 5, offset: const Offset(0, 4))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText.titleLarge("اضف عملة جديدة", color: context.onPrimaryColor, fontWeight: FontWeight.w600),

                CustomDropdown<Cur>(
                  menuList: firstCurs,
                  initaValue: firstSelectedCur,
                  compareFn: (a, b) => a.id == b.id,
                  singleSelectValidator: (value) => singleSelectValidator(value),
                  labelText: "اختر العملة الاولى",
                  hintText: "اختر العملة الاولى",
                  valueFontSize: 16,
                  itemAsString: (cur) => cur.name,
                  fillColor: context.primaryColor,
                  color: context.onPrimaryColor,
                  onChanged: (cur) {
                    firstSelectedCur = cur;
                  },
                ),
                CustomDropdown<Cur>(
                  menuList: secondCurs,
                  initaValue: secondSelectedCur,
                  singleSelectValidator: (value) => singleSelectValidator(value),
                  compareFn: (a, b) => a.id == b.id,
                  labelText: "اختر العملة الثانية",
                  hintText: "اختر العملة الثانية",
                  valueFontSize: 16,
                  fillColor: context.primaryColor,
                  color: context.onPrimaryColor,

                  itemAsString: (cur) => cur.name,
                  onChanged: (cur) {
                    secondSelectedCur = cur;
                  },
                ),

                BlocBuilder<PricesBloc, PricesState>(
                  builder: (context, state) {
                    return LargeButton(
                      onPressed: state.addExchangeStatus == Status.loading
                          ? () {}
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                final int? id = await HiveHelper.getFromHive(
                                  boxName: AppKeys.userBox,
                                  key: AppKeys.userId,
                                );
                                final AddExchangeParams addExchangeParams = AddExchangeParams(
                                  id: id.toString(),
                                  cur: secondSelectedCur!.id,
                                );
                                final isSyp = firstSelectedCur!.id == "syp" || firstSelectedCur!.name == "ليرة سورية"
                                    ? true
                                    : false;
                                context.read<PricesBloc>().add(
                                  AddExchangeEvent(params: addExchangeParams, isSyp: isSyp),
                                );
                              }
                            },
                      text: "اضافة",
                      backgroundColor: context.primaryContainer,
                      circularRadius: 12,
                      child: state.addExchangeStatus == Status.loading ? CustomProgressIndecator() : null,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
