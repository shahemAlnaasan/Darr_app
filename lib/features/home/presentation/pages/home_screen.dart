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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Cur> curs = [];
  Future<void> _onRefresh(BuildContext context) async {
    context.read<HomeBloc>().add(GetCursEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => getIt<HomeBloc>()..add(GetCursEvent()),
      child: MultiBlocListener(
        listeners: [
          BlocListener<HomeBloc, HomeState>(
            listenWhen: (previous, current) => previous.getCursResponse != current.getCursResponse,
            listener: (context, state) {
              if (state.getCursResponse != null) {
                curs = state.getCursResponse!.curs;
                context.read<HomeBloc>().add(GetAvgPrices(isRefreshScreen: true));
              }
            },
          ),
          // BlocListener<HomeBloc, HomeState>(
          //   listenWhen: (previous, current) => previous.getCursStatus != current.getCursStatus,
          //   listener: (context, state) {
          //     if (state.getAvgPricesStatus == Status.success && state.avgPricesResponse != null) {
          //       curs = state.getCursResponse!.curs;
          //     }
          //   },
          // ),
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
                              final List<CityPrices> cities = state.avgPricesResponse!.cities;

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

                            if (state.getAvgPricesStatus == Status.failure) {
                              return Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppText.bodyLarge("لايوجد نشرة اسعار لعرضها", fontWeight: FontWeight.w400),
                                    SizedBox(height: 10),
                                    LargeButton(
                                      onPressed: () {
                                        context.read<HomeBloc>().add(GetCursEvent());
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
