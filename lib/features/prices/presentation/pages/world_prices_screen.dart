import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/extentions/size_extension.dart';
import 'package:exchange_darr/common/state_managment/bloc_state.dart';
import 'package:exchange_darr/common/widgets/app_text.dart';
import 'package:exchange_darr/common/widgets/custom/exchange_price_container.dart';
import 'package:exchange_darr/common/widgets/large_button.dart';
import 'package:exchange_darr/core/di/injection.dart';
import 'package:exchange_darr/features/home/presentation/widgets/sos_drop_down.dart';
import 'package:exchange_darr/features/prices/data/models/get_prices_response.dart' hide Center;
import 'package:exchange_darr/features/prices/presentation/bloc/prices_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WorldPricesScreen extends StatefulWidget {
  const WorldPricesScreen({super.key});

  @override
  State<WorldPricesScreen> createState() => _WorldPricesScreenState();
}

class _WorldPricesScreenState extends State<WorldPricesScreen> {
  final ScrollController _scrollController = ScrollController();
  int selectedIndex = 0;
  List<CityPrices> citiesList = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => getIt<PricesBloc>()..add(GetUsdPricesEvent(isRefreshScreen: true)),
      child: Scaffold(
        backgroundColor: context.tertiary,
        body: SizedBox(
          width: context.screenWidth,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AppText.titleLarge(
                      "الاسعار العالمية:",
                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.bold,
                      color: context.primaryColor,
                    ),
                  ),
                ),
                // SizedBox(height: 5),
                SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 10, top: 20, bottom: 20),
                    margin: const EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // ✅ prevent Row from filling all width
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 10,
                      children: [
                        AppText.bodyMedium(
                          "فلترة حسب:",
                          fontWeight: FontWeight.bold,
                          color: context.primaryColor,
                          textAlign: TextAlign.right,
                          height: 2,
                        ),
                        BlocBuilder<PricesBloc, PricesState>(
                          builder: (context, state) {
                            if (state.getUsdPricesStatus == Status.loading ||
                                state.getUsdPricesStatus == Status.initial) {
                              return Row(
                                spacing: 10,
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(6, (i) {
                                  return Skeletonizer(
                                    enabled: true,
                                    containersColor: const Color.fromARGB(99, 158, 158, 158),
                                    enableSwitchAnimation: true,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: context.surfaceContainer,
                                        borderRadius: BorderRadius.circular(22),
                                        border: Border.all(color: context.surfaceContainer),
                                      ),
                                      child: AppText.bodyMedium(
                                        "Lss",
                                        fontWeight: FontWeight.bold,
                                        color: context.primaryColor,
                                        height: 2,
                                      ),
                                    ),
                                  );
                                }),
                              );
                            }

                            if (state.getUsdPricesStatus == Status.success && state.getUsdPricesResponse != null) {
                              citiesList = state.getUsdPricesResponse!.cities;
                              return Row(
                                spacing: 10,
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(citiesList.length, (i) {
                                  final isSelected = selectedIndex == i;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        final selectedItem = citiesList.removeAt(i);
                                        citiesList.insert(0, selectedItem);
                                        selectedIndex = 0;
                                      });
                                      _scrollController.animateTo(
                                        0,
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: context.surfaceContainer,
                                        borderRadius: BorderRadius.circular(22),
                                        border: Border.all(
                                          color: isSelected ? context.primaryColor : context.surfaceContainer,
                                        ),
                                      ),
                                      child: AppText.bodyMedium(
                                        citiesList[i].cityName,
                                        fontWeight: FontWeight.bold,
                                        color: context.primaryColor,
                                        height: 2,
                                      ),
                                    ),
                                  );
                                }),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: BlocBuilder<PricesBloc, PricesState>(
                    builder: (context, state) {
                      if (state.getUsdPricesStatus == Status.loading || state.getUsdPricesStatus == Status.initial) {
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
                      if (state.getUsdPricesStatus == Status.success && state.getUsdPricesResponse != null) {
                        final List<CityPrices> cities = state.getUsdPricesResponse!.cities;

                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cities.length,
                          itemBuilder: (context, cityIndex) {
                            final city = cities[cityIndex];

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: city.centers.length,
                              itemBuilder: (context, centerIndex) {
                                final center = city.centers[centerIndex];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: SosDropdown(
                                    dropDownTitle: center.centerName,
                                    childrens: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: center.currencies.length,
                                      itemBuilder: (context, currencyIndex) {
                                        final cur = center.currencies[currencyIndex];

                                        return ExchangePriceContainer(
                                          parms: PriceContainerParms(
                                            buyCur: cur.currencyName,
                                            buyPrice: cur.buy.toString(),
                                            sellCur: "دولار امريكي",
                                            sellPrice: cur.sell.toString(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }

                      if (state.getUsdPricesStatus == Status.failure) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppText.bodyLarge("لايوجد نشرة اسعار لعرضها", fontWeight: FontWeight.w400),
                              SizedBox(height: 10),
                              LargeButton(
                                onPressed: () {
                                  context.read<PricesBloc>().add(GetUsdPricesEvent(isRefreshScreen: true));
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
