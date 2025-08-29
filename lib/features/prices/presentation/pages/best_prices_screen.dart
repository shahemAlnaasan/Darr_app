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

class BestPricesScreen extends StatefulWidget {
  const BestPricesScreen({super.key});

  @override
  State<BestPricesScreen> createState() => _BestPricesScreenState();
}

class _BestPricesScreenState extends State<BestPricesScreen> {
  final ScrollController _scrollController = ScrollController();
  int selectedIndex = 0;
  final List<String> curs = ["دولار امريكي", "دولار امريكي", "دولار ", " امريكي", "دولار امريكي"];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => getIt<HomeBloc>()..add(GetAvgPrices(isRefreshScreen: true)),
      child: Scaffold(
        backgroundColor: context.tertiary,
        body: SizedBox(
          width: context.screenWidth,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AppText.titleLarge(
                      "افضل الاسعار:",
                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.bold,
                      color: context.primaryColor,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    // decoration: BoxDecoration(color: context.surfaceContainer, borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.only(right: 10, top: 20, bottom: 20),
                    margin: EdgeInsets.only(right: 10),
                    child: Row(
                      spacing: 10,
                      children: [
                        AppText.bodyMedium(
                          "فلترة حسب:",
                          fontWeight: FontWeight.bold,
                          color: context.primaryColor,
                          height: 2,
                        ),
                        ...List.generate(curs.length, (i) {
                          final isSelected = selectedIndex == i;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                final selectedItem = curs.removeAt(i);
                                curs.insert(0, selectedItem);
                                selectedIndex = 0;
                              });
                              _scrollController.animateTo(
                                0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: context.surfaceContainer,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: isSelected ? context.primaryColor : context.surfaceContainer),
                              ),
                              child: AppText.bodyMedium(
                                curs[i],
                                fontWeight: FontWeight.bold,
                                color: context.primaryColor,
                                height: 2,
                              ),
                            ),
                          );
                        }),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),

                // SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: BlocBuilder<HomeBloc, HomeState>(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
