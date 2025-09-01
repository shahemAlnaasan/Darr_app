import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/extentions/navigation_extensions.dart';
import 'package:exchange_darr/common/extentions/size_extension.dart';
import 'package:exchange_darr/common/state_managment/bloc_state.dart';
import 'package:exchange_darr/common/widgets/app_text.dart';
import 'package:exchange_darr/common/widgets/custom/exchange_price_container.dart';
import 'package:exchange_darr/common/widgets/large_button.dart';
import 'package:exchange_darr/core/di/injection.dart';
import 'package:exchange_darr/features/home/presentation/pages/atm_details_screen.dart';
import 'package:exchange_darr/features/home/presentation/widgets/sos_drop_down.dart';
import 'package:exchange_darr/features/prices/data/models/get_curs_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_prices_response.dart' hide Center;
import 'package:exchange_darr/features/prices/presentation/bloc/prices_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DollarPricesScreen extends StatefulWidget {
  const DollarPricesScreen({super.key});

  @override
  State<DollarPricesScreen> createState() => _DollarPricesScreenState();
}

class _DollarPricesScreenState extends State<DollarPricesScreen> {
  final ScrollController _scrollController = ScrollController();
  int selectedIndex = 0;
  List<CityPrices> citiesList = [];
  List<Cur> curs = [];
  final List<String> priorityOrder = ["دمشق", "حلب", "حمص"];
  Future<void> _onRefresh(BuildContext context) async {
    context.read<PricesBloc>().add(GetCursEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => getIt<PricesBloc>()..add(GetCursEvent()),
      child: BlocListener<PricesBloc, PricesState>(
        listenWhen: (previous, current) => previous.getCursResponse != current.getCursResponse,
        listener: (context, state) {
          if (state.getCursResponse != null) {
            curs = state.getCursResponse!.curs;
            context.read<PricesBloc>().add(GetUsdPricesEvent(isRefreshScreen: true));
          }
        },
        child: Scaffold(
          backgroundColor: context.background,
          body: SizedBox(
            width: context.screenWidth,
            child: Builder(
              builder: (context) {
                return RefreshIndicator(
                  onRefresh: () => _onRefresh(context),
                  backgroundColor: context.primaryColor,
                  color: context.onPrimaryColor,
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
                              "اسعار الدولار:",
                              textAlign: TextAlign.right,
                              fontWeight: FontWeight.bold,
                              color: context.onPrimaryColor,
                            ),
                          ),
                        ),
                        // SizedBox(height: 5),
                        SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 10, top: 10, bottom: 20),
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
                                  color: context.onPrimaryColor,
                                  textAlign: TextAlign.right,
                                  height: 2,
                                ),
                                BlocBuilder<PricesBloc, PricesState>(
                                  builder: (context, state) {
                                    if (state.getUsdPricesStatus == Status.loading ||
                                        state.getUsdPricesStatus == Status.initial ||
                                        state.getCursStatus == Status.loading) {
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

                                    if (state.getUsdPricesStatus == Status.success &&
                                        state.getUsdPricesResponse != null) {
                                      // Original cities from API
                                      final List<CityPrices> cities = state.getUsdPricesResponse!.cities;

                                      // 🔎 Desired priority order

                                      // Reorder citiesList according to the priority
                                      final prioritized = <CityPrices>[];
                                      for (var name in priorityOrder) {
                                        final match = cities.where((c) => c.cityName == name).toList();
                                        if (match.isNotEmpty) prioritized.addAll(match);
                                      }

                                      // Add remaining cities not in priorityOrder
                                      final remaining = cities
                                          .where((c) => !priorityOrder.contains(c.cityName))
                                          .toList();

                                      citiesList = [...prioritized, ...remaining];

                                      return Row(
                                        spacing: 10,
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(citiesList.length, (i) {
                                          final isSelected = selectedIndex == i;
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedIndex = i;
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
                                                color: context.primaryColor,
                                                borderRadius: BorderRadius.circular(22),
                                                border: Border.all(
                                                  color: isSelected ? context.surfaceContainer : context.primaryColor,
                                                  width: 2.5,
                                                ),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Color(0x20000000),
                                                    blurRadius: 5,
                                                    offset: Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: AppText.bodyMedium(
                                                citiesList[i].cityName,
                                                fontWeight: FontWeight.bold,
                                                color: context.onPrimaryColor,
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
                              if (state.getUsdPricesStatus == Status.loading ||
                                  state.getUsdPricesStatus == Status.initial) {
                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 4,
                                  itemBuilder: (context, index) => Skeletonizer(
                                    enabled: true,
                                    containersColor: const Color.fromARGB(99, 158, 158, 158),
                                    enableSwitchAnimation: true,
                                    child: SosDropdown(
                                      dropDownTitle: "حasdsلب",
                                      isAtm: true,

                                      initChild: ExchangePriceContainer(
                                        parms: PriceContainerParms(
                                          buyCur: "initCur.code",
                                          buyPrice: "initCur.buy",
                                          sellCur: "initCur.buy",
                                          sellPrice: "initCur.se",
                                          curs: curs,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              if (state.getUsdPricesStatus == Status.success && state.getUsdPricesResponse != null) {
                                final List<CityPrices> cities = state.getUsdPricesResponse!.cities;

                                final prioritized = <CityPrices>[];
                                for (var name in priorityOrder) {
                                  final match = cities.where((c) => c.cityName == name).toList();
                                  if (match.isNotEmpty) prioritized.addAll(match);
                                }

                                final remaining = cities.where((c) => !priorityOrder.contains(c.cityName)).toList();

                                citiesList = [...prioritized, ...remaining];

                                final selectedCity = citiesList[selectedIndex];

                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: selectedCity.centers.length,
                                  itemBuilder: (context, centerIndex) {
                                    final center = selectedCity.centers[centerIndex];

                                    // Filter invalid currencies
                                    final filteredCurrencies = center.currencies.where((cur) {
                                      final buy = double.tryParse(cur.buy.toString()) ?? 0;
                                      final sell = double.tryParse(cur.sell.toString()) ?? 0;
                                      return !(buy == 0 && sell == 0);
                                    }).toList();

                                    if (filteredCurrencies.isEmpty) return const SizedBox.shrink();

                                    final initCur = filteredCurrencies[0];

                                    return SosDropdown(
                                      dropDownTitle: center.centerName,
                                      isAtm: true,
                                      onDetailsTap: () => context.push(AtmDetailsScreen(atmId: center.id)),
                                      initChild: ExchangePriceContainer(
                                        parms: PriceContainerParms(
                                          buyCur: initCur.code,
                                          buyPrice: initCur.buy.toString(),
                                          sellCur: "usd",
                                          sellPrice: initCur.sell.toString(),
                                          curs: curs,
                                        ),
                                      ),
                                      childrens: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: filteredCurrencies.length,
                                        itemBuilder: (context, currencyIndex) {
                                          final cur = filteredCurrencies[currencyIndex];

                                          return ExchangePriceContainer(
                                            parms: PriceContainerParms(
                                              buyCur: cur.code,
                                              buyPrice: cur.buy.toString(),
                                              sellCur: "usd",
                                              sellPrice: cur.sell.toString(),
                                              curs: curs,
                                            ),
                                          );
                                        },
                                      ),
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
