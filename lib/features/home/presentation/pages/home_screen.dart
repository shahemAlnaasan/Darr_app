import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/extentions/size_extension.dart';
import 'package:exchange_darr/common/state_managment/bloc_state.dart';
import 'package:exchange_darr/common/widgets/app_text.dart';
import 'package:exchange_darr/common/widgets/custom/exchange_price_container.dart';
import 'package:exchange_darr/common/widgets/large_button.dart';
import 'package:exchange_darr/core/di/injection.dart';
import 'package:exchange_darr/features/home/presentation/bloc/home_bloc.dart';
import 'package:exchange_darr/features/home/presentation/widgets/sos_drop_down.dart';
import 'package:exchange_darr/features/prices/data/models/avg_prices_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => getIt<HomeBloc>()..add(GetAvgPrices(isRefreshScreen: true)),
      child: Scaffold(
        backgroundColor: context.tertiary,
        body: Container(
          width: context.screenWidth,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              spacing: 10,

              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: AppText.titleLarge(
                    "متوسط الاسعار للمحافظات:",
                    textAlign: TextAlign.right,
                    fontWeight: FontWeight.bold,
                    color: context.primaryColor,
                  ),
                ),
                SizedBox(height: 20),
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state.getAvgPricesStatus == Status.loading || state.getAvgPricesStatus == Status.initial) {
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 4,
                        itemBuilder: (context, index) => Skeletonizer(
                          enabled: true,
                          containersColor: const Color.fromARGB(99, 158, 158, 158),
                          enableSwitchAnimation: true,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: SosDropdown(dropDownTitle: "حلب"),
                          ),
                        ),
                      );
                    }
                    if (state.getAvgPricesStatus == Status.success && state.avgPricesResponse != null) {
                      final List<CityPrices> cities = state.avgPricesResponse!.cities;

                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: cities.length,
                        itemBuilder: (context, cityIndex) {
                          final city = cities[cityIndex];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: SosDropdown(
                              dropDownTitle: city.cityName,
                              childrens: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: city.currencies.length,
                                itemBuilder: (context, currencyIndex) {
                                  final currencyMap = city.currencies[currencyIndex];
                                  final currencyKey = currencyMap.keys.first;
                                  final type = currencyMap[currencyKey]!;

                                  return ExchangePriceContainer(
                                    parms: PriceContainerParms(
                                      buyCur: currencyKey,
                                      buyPrice: type.buy.toString(),
                                      sellCur: "SYR",
                                      sellPrice: type.sell.toString(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }

                    if (state.getAvgPricesStatus == Status.failure) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText.bodyLarge("لايوجد نشرة اسعار لعرضها", fontWeight: FontWeight.w400),
                            SizedBox(height: 10),
                            LargeButton(
                              onPressed: () {
                                context.read<HomeBloc>().add(GetAvgPrices(isRefreshScreen: true));
                              },
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
            ),
          ),
        ),
      ),
    );
  }
}
