import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/state_managment/bloc_state.dart';
import 'package:exchange_darr/common/widgets/app_text.dart';
import 'package:exchange_darr/common/widgets/large_button.dart';
import 'package:exchange_darr/features/prices/data/models/get_curs_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_exchage_response.dart';
import 'package:exchange_darr/features/prices/presentation/bloc/prices_bloc.dart';
import 'package:exchange_darr/features/prices/presentation/widgets/add_currency.dart';
import 'package:exchange_darr/features/prices/presentation/widgets/add_currency_bottom_sheet.dart';
import 'package:exchange_darr/features/prices/presentation/widgets/currencies_pairs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyPricesContent extends StatelessWidget {
  final List<Price> pricesList;
  final List<Cur> curs;
  final void Function() onRefresh;
  const MyPricesContent({super.key, required this.pricesList, required this.curs, required this.onRefresh});
  void _showDetailsDialog(BuildContext context, {required List<Cur> curs, required List<Price> prices}) {
    final bloc = context.read<PricesBloc>();
    showDialog(
      context: context,
      builder: (ctx) {
        return BlocProvider.value(
          value: bloc,
          child: AddCurrencyBottomSheet(curs: curs, prices: prices),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Price> prices = pricesList;
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // SizedBox(height: 5),
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: AppText.titleLarge(
        //     "اسعاري:",
        //     textAlign: TextAlign.right,
        //     fontWeight: FontWeight.bold,
        //     color: context.onPrimaryColor,
        //   ),
        // ),
        SizedBox(height: 10),
        Builder(
          builder: (context) {
            return AddCurrency(
              onTap: () {
                _showDetailsDialog(context, curs: curs, prices: prices);
              },
            );
          },
        ),
        SizedBox(height: 10),
        BlocBuilder<PricesBloc, PricesState>(
          builder: (context, state) {
            if (state.getUsdPricesStatus == Status.loading ||
                state.getUsdPricesStatus == Status.initial ||
                state.getCursStatus == Status.loading) {
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, index) => Skeletonizer(
                  enabled: true,
                  containersColor: const Color.fromARGB(99, 158, 158, 158),
                  enableSwitchAnimation: true,
                  child: CurrenciesPairs(
                    curs: [],
                    price: Price(cur: "cursadasd", buy: "1000", sell: "10000", isSyp: true),
                  ),
                ),
              );
            }
            if (state.getUsdPricesStatus == Status.success && state.exchangePrices!.isNotEmpty) {
              prices = state.exchangePrices!;
              final pricesList = state.exchangePrices;

              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: pricesList!.length,
                itemBuilder: (context, index) {
                  return CurrenciesPairs(price: pricesList[index], curs: curs);
                },
              );
            }

            if (state.getExchangeUsdStatus == Status.failure || state.getCursStatus == Status.failure) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.bodyLarge("لايوجد نشرة اسعار لعرضها", fontWeight: FontWeight.w400),
                    SizedBox(height: 10),
                    LargeButton(
                      onPressed: onRefresh,
                      backgroundColor: context.surfaceContainer,
                      text: "اعادة المحاولة",
                      textStyle: TextStyle(color: context.primaryColor),
                    ),
                  ],
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
