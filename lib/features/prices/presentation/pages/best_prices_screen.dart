import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/extentions/size_extension.dart';
import 'package:exchange_darr/common/state_managment/bloc_state.dart';
import 'package:exchange_darr/common/widgets/app_text.dart';
import 'package:exchange_darr/common/widgets/custom/exchange_price_container.dart';
import 'package:exchange_darr/common/widgets/large_button.dart';
import 'package:exchange_darr/core/di/injection.dart';
import 'package:exchange_darr/features/home/presentation/bloc/home_bloc.dart';
import 'package:exchange_darr/features/home/presentation/widgets/sos_drop_down.dart';
import 'package:exchange_darr/features/prices/data/models/get_curs_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_prices_response.dart' hide Center;
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
  List<CityPrices> citiesList = [];

  List<Cur> curs = [];
  Future<void> _onRefresh(BuildContext context) async {
    context.read<HomeBloc>().add(GetCursEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => getIt<HomeBloc>()..add(GetCursEvent()),
      child: BlocListener<HomeBloc, HomeState>(
        listenWhen: (previous, current) => previous.getCursStatus != current.getCursStatus,
        listener: (context, state) {
          if (state.getCursStatus == Status.success && state.getCursResponse != null) {
            curs = state.getCursResponse!.curs;
            context.read<HomeBloc>().add(GetPricesEvent(isRefreshScreen: true));
          }
        },
        child: Scaffold(
          backgroundColor: context.tertiary,
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
                                BlocBuilder<HomeBloc, HomeState>(
                                  builder: (context, state) {
                                    if (state.getPricesStatus == Status.loading ||
                                        state.getPricesStatus == Status.initial) {
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

                                    if (state.getPricesStatus == Status.success && state.getPricesStatus != null) {
                                      citiesList = state.getPricesResponse!.cities;
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
                                SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: BlocBuilder<HomeBloc, HomeState>(
                            builder: (context, state) {
                              if (state.getPricesStatus == Status.loading || state.getPricesStatus == Status.initial) {
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
                              if (state.getPricesStatus == Status.success && state.getPricesResponse != null) {
                                final List<CityPrices> cities = state.getPricesResponse!.cities;
                                final selectedCity = cities[selectedIndex];

                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: selectedCity.centers.length,
                                  itemBuilder: (context, centerIndex) {
                                    final center = selectedCity.centers[centerIndex];
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
                                                curs: [],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }

                              if (state.getPricesStatus == Status.failure) {
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
