import 'dart:developer';

import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/extentions/navigation_extensions.dart';
import 'package:exchange_darr/common/extentions/size_extension.dart';
import 'package:exchange_darr/common/state_managment/bloc_state.dart';
import 'package:exchange_darr/common/widgets/app_text.dart';
import 'package:exchange_darr/common/widgets/custom/exchange_price_container.dart';
import 'package:exchange_darr/common/widgets/custom_text_field.dart';
import 'package:exchange_darr/common/widgets/large_button.dart';
import 'package:exchange_darr/core/di/injection.dart';
import 'package:exchange_darr/features/home/presentation/bloc/home_bloc.dart';
import 'package:exchange_darr/features/home/presentation/pages/atm_details_screen.dart';
import 'package:exchange_darr/features/home/presentation/widgets/sos_drop_down.dart';
import 'package:exchange_darr/features/prices/data/models/get_curs_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_prices_response.dart';
// import 'package:exchange_darr/features/prices/data/models/get_prices_response.dart' hide Center;
import 'package:exchange_darr/features/prices/presentation/widgets/filter_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BestPricesScreen extends StatefulWidget {
  const BestPricesScreen({super.key});

  @override
  State<BestPricesScreen> createState() => _BestPricesScreenState();
}

class _BestPricesScreenState extends State<BestPricesScreen> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  int selectedIndex = 0;
  List<CityPrices> citiesList = [];
  String? selectedCityName;
  final List<String> priorityOrder = ["دمشق", "حلب", "حمص", "حماه", "اللاذقية", "طرطوس", "ادلب"];
  List<Cur> curs = [];
  CityPrices selectedCity = CityPrices(cityName: "", centers: []);
  List<CenterData> allCenters = [];
  List<CenterData> filterdCenters = [];
  String searchQuery = "";

  Future<void> _onRefresh(BuildContext context) async {
    context.read<HomeBloc>().add(GetCursEvent());
  }

  bool isAutoRefreshing = false;
  bool _shouldKeepRefreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    log("query $query");
    setState(() {
      if (query.isEmpty) {
        filterdCenters = allCenters;
      } else {
        filterdCenters = allCenters
            .where((center) => center.centerName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _shouldKeepRefreshing = false;
    searchController.dispose();
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
      blocContext.read<HomeBloc>().add(GetPricesEvent(isRefreshScreen: true));
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
            listenWhen: (previous, current) => previous.getCursResponse != current.getCursResponse,
            listener: (context, state) {
              if (state.getCursResponse != null) {
                curs = state.getCursResponse!.curs;
                context.read<HomeBloc>().add(GetPricesEvent(isRefreshScreen: true));
              }
            },
          ),
          BlocListener<HomeBloc, HomeState>(
            listenWhen: (previous, current) => previous.getPricesStatus != current.getPricesStatus,
            listener: (context, state) {
              if (state.getPricesStatus != null && state.getPricesStatus == Status.success) {
                _startAutoRefresh(context);
              }
            },
          ),
        ],
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
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
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
                                color: context.onPrimaryColor,
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  AppText.bodyMedium(
                                    "فلترة حسب:",
                                    fontWeight: FontWeight.bold,
                                    color: context.onPrimaryColor,
                                    textAlign: TextAlign.start,
                                    height: 2,
                                  ),

                                  BlocBuilder<HomeBloc, HomeState>(
                                    builder: (context, state) {
                                      if (state.getPricesStatus == Status.loading ||
                                          state.getPricesStatus == Status.initial ||
                                          state.getCursStatus == Status.loading) {
                                        return Row(
                                          spacing: 10,
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(6, (i) {
                                            return Skeletonizer(
                                              enabled: true,
                                              containersColor: const Color.fromARGB(99, 158, 158, 158),
                                              enableSwitchAnimation: true,
                                              child: FilterOption(title: "tite", isSelected: true),
                                            );
                                          }),
                                        );
                                      }

                                      if (state.getPricesStatus == Status.success &&
                                          state.getCursStatus == Status.success &&
                                          state.getPricesResponse != null) {
                                        citiesList = state.getPricesResponse!.cities;

                                        final prioritized = <CityPrices>[];
                                        for (var name in priorityOrder) {
                                          final match = citiesList.where((c) => c.cityName == name).toList();
                                          if (match.isNotEmpty) {
                                            prioritized.addAll(match);
                                          }
                                        }

                                        final remaining = citiesList
                                            .where((c) => !priorityOrder.contains(c.cityName))
                                            .toList();

                                        citiesList = [...prioritized, ...remaining];
                                        selectedCityName = citiesList[0].cityName;

                                        return Row(
                                          spacing: 10,
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(citiesList.length, (i) {
                                            final isSelected = selectedIndex == i;
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedIndex = i;
                                                  selectedCityName = citiesList[i].cityName;
                                                  selectedCity = citiesList[selectedIndex];
                                                  _onSearchChanged();
                                                });
                                              },
                                              child: FilterOption(
                                                title: citiesList[i].cityName,
                                                isSelected: isSelected,
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
                            child: buildTextField(hint: "بحث", controller: searchController),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: BlocBuilder<HomeBloc, HomeState>(
                              builder: (context, state) {
                                if (state.getPricesStatus == Status.loading ||
                                    state.getPricesStatus == Status.initial ||
                                    state.getCursStatus == Status.loading) {
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
                                if (state.getPricesStatus == Status.success &&
                                    state.getCursStatus == Status.success &&
                                    state.getPricesResponse != null) {
                                  final List<CityPrices> cities = state.getPricesResponse!.cities;
                                  log("updated");

                                  final prioritized = <CityPrices>[];
                                  for (var name in priorityOrder) {
                                    final match = cities.where((c) => c.cityName == name).toList();
                                    if (match.isNotEmpty) prioritized.addAll(match);
                                  }

                                  final remaining = cities.where((c) => !priorityOrder.contains(c.cityName)).toList();

                                  citiesList = [...prioritized, ...remaining];

                                  if (selectedIndex >= citiesList.length) {
                                    selectedIndex = 0;
                                  }

                                  selectedCity = citiesList[selectedIndex];
                                  allCenters = selectedCity.centers;

                                  if (searchController.text.isNotEmpty) {
                                    filterdCenters = allCenters
                                        .where(
                                          (center) => center.centerName.toLowerCase().contains(
                                            searchController.text.toLowerCase(),
                                          ),
                                        )
                                        .toList();
                                  } else {
                                    filterdCenters = allCenters;
                                  }
                                  return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: filterdCenters.length,
                                    itemBuilder: (context, centerIndex) {
                                      final center = filterdCenters[centerIndex];

                                      final filteredCurrencies = center.currencies.where((cur) {
                                        final buy = double.tryParse(cur.buy) ?? 0;
                                        final sell = double.tryParse(cur.sell) ?? 0;
                                        return !(buy == 0 && sell == 0);
                                      }).toList();

                                      if (filteredCurrencies.isEmpty) {
                                        return SizedBox.shrink();
                                      }

                                      final initCur = filteredCurrencies[0];

                                      return SosDropdown(
                                        dropDownTitle: center.centerName,
                                        isAtm: true,
                                        icon: center.centerImg,
                                        onDetailsTap: () => context.push(AtmDetailsScreen(atmId: center.id)),
                                        initChild: ExchangePriceContainer(
                                          parms: PriceContainerParms(
                                            buyCur: initCur.code,
                                            buyPrice: initCur.buy,
                                            sellCur: "syp",
                                            sellPrice: initCur.sell,
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
                                                buyPrice: cur.buy,
                                                sellCur: "syp",
                                                sellPrice: cur.sell,
                                                curs: curs,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                }

                                if (state.getPricesStatus == Status.failure || state.getCursStatus == Status.failure) {
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
    Widget? preIcon,
    bool? obSecure,
  }) {
    return CustomTextField(
      textAlign: TextAlign.start,
      onTap: onTap,
      readOnly: readOnly,
      preIcon: preIcon,
      obSecure: obSecure,
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
                return validatorTitle.isNotEmpty ? validatorTitle : "لا يمكن للحقل ان يكون فارعاً";
              }
              return null;
            }
          : null,
      sufIcon: sufIcon,
    );
  }
}
