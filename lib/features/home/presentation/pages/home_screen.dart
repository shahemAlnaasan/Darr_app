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
import 'package:exchange_darr/features/prices/data/models/get_curs_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'dart:developer';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  List<Cur> curs = [];
  final List<String> priorityOrder = ["دمشق", "حلب", "حمص", "حماه", "اللاذقية", "طرطوس", "ادلب"];

  Future<void> _onRefresh(BuildContext context) async {
    context.read<HomeBloc>().add(GetCursEvent());
  }

  bool isAutoRefreshing = false;
  bool _shouldKeepRefreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _shouldKeepRefreshing = false;
    super.dispose();
  }

  void _startAutoRefresh(BuildContext context) {
    final blocContext = context;
    if (isAutoRefreshing) return;
    isAutoRefreshing = true;
    _shouldKeepRefreshing = true;

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      if (!mounted || !_shouldKeepRefreshing) return false;
      blocContext.read<HomeBloc>().add(GetAvgPrices(isRefreshScreen: true));
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => getIt<HomeBloc>()..add(GetCursEvent()),
      child: MultiBlocListener(
        listeners: [
          BlocListener<HomeBloc, HomeState>(
            listenWhen: (previous, current) => previous.getCursStatus != current.getCursStatus,
            listener: (context, state) {
              if (state.getCursResponse != null) {
                curs = state.getCursResponse!.curs;
                context.read<HomeBloc>().add(GetAvgPrices(isRefreshScreen: true));
              }
            },
          ),
          BlocListener<HomeBloc, HomeState>(
            listenWhen: (previous, current) => previous.getAvgPricesStatus != current.getAvgPricesStatus,
            listener: (context, state) {
              if (state.avgPricesResponse != null && state.getAvgPricesStatus == Status.success) {
                _startAutoRefresh(context);
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: context.background,
          body: Container(
            width: context.screenWidth,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Builder(
              builder: (context) {
                return RefreshIndicator(
                  onRefresh: () => _onRefresh(context),
                  backgroundColor: context.primaryColor,
                  color: context.onPrimaryColor,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
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
                              color: context.onPrimaryColor,
                            ),
                          ),
                          SizedBox(height: 20),
                          BlocBuilder<HomeBloc, HomeState>(
                            builder: (context, state) {
                              if (state.getAvgPricesStatus == Status.loading ||
                                  state.getAvgPricesStatus == Status.initial ||
                                  state.getCursStatus == Status.loading) {
                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 4,
                                  itemBuilder: (context, index) => Skeletonizer(
                                    enabled: true,
                                    containersColor: const Color.fromARGB(99, 158, 158, 158),
                                    enableSwitchAnimation: true,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 4.0),
                                      child: SosDropdown(dropDownTitle: "حلب"),
                                    ),
                                  ),
                                );
                              }
                              if (state.getAvgPricesStatus == Status.success && state.avgPricesResponse != null) {
                                List<CityPrices> cities = state.avgPricesResponse!.cities;
                                log("updated");
                                final prioritized = <CityPrices>[];
                                for (var name in priorityOrder) {
                                  final match = cities.where((c) => c.cityName == name).toList();
                                  if (match.isNotEmpty) {
                                    prioritized.addAll(match);
                                  }
                                }

                                // Keep the rest (excluding ones already added)
                                final remaining = cities.where((c) => !priorityOrder.contains(c.cityName)).toList();

                                cities = [...prioritized, ...remaining];

                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: cities.length,
                                  itemBuilder: (context, cityIndex) {
                                    final city = cities[cityIndex];

                                    final filteredCurrencies = city.currencies.where((currencyMap) {
                                      final type = currencyMap.values.first;
                                      return !(type.buy == 0 && type.sell == 0);
                                    }).toList();

                                    if (filteredCurrencies.isEmpty) return SizedBox.shrink();

                                    final initCurrencyMap = filteredCurrencies[0];
                                    final initCurrencyKey = initCurrencyMap.keys.first;
                                    final initType = initCurrencyMap[initCurrencyKey]!;

                                    return SosDropdown(
                                      dropDownTitle: city.cityName,
                                      initChild: ExchangePriceContainer(
                                        parms: PriceContainerParms(
                                          buyCur: initCurrencyKey,
                                          buyPrice: initType.buy.toString(),
                                          sellCur: "syp",
                                          sellPrice: initType.sell.toString(),
                                          curs: curs,
                                        ),
                                      ),
                                      childrens: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: filteredCurrencies.length,
                                        itemBuilder: (context, currencyIndex) {
                                          final currencyMap = filteredCurrencies[currencyIndex];
                                          final currencyKey = currencyMap.keys.first;
                                          final type = currencyMap[currencyKey]!;

                                          return ExchangePriceContainer(
                                            parms: PriceContainerParms(
                                              buyCur: currencyKey,
                                              buyPrice: type.buy.toString(),
                                              sellCur: "syp",
                                              sellPrice: type.sell.toString(),
                                              curs: curs,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              }

                              if (state.getAvgPricesStatus == Status.failure || state.getCursStatus == Status.failure) {
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AppText.bodyLarge("لايوجد نشرة اسعار لعرضها", fontWeight: FontWeight.w400),
                                      SizedBox(height: 10),
                                      LargeButton(
                                        onPressed: () {
                                          _onRefresh(context);
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
