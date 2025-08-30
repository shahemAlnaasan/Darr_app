import 'dart:developer';

import 'package:exchange_darr/common/consts/app_keys.dart';
import 'package:exchange_darr/common/state_managment/bloc_state.dart';
import 'package:exchange_darr/common/widgets/large_button.dart';
import 'package:exchange_darr/core/datasources/hive_helper.dart';
import 'package:exchange_darr/features/auth/presentation/pages/login_screen.dart';
import 'package:exchange_darr/features/prices/data/models/get_curs_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_exchage_response.dart';
import 'package:exchange_darr/features/prices/presentation/bloc/prices_bloc.dart';
import 'package:exchange_darr/features/prices/presentation/widgets/add_currency.dart';
import 'package:exchange_darr/features/prices/presentation/widgets/add_currency_bottom_sheet.dart';
import 'package:exchange_darr/features/prices/presentation/widgets/currencies_pairs.dart';
import 'package:flutter/material.dart';
import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/extentions/size_extension.dart';
import 'package:exchange_darr/common/widgets/app_text.dart';
import 'package:exchange_darr/core/di/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PageDecider extends StatefulWidget {
  const PageDecider({super.key});

  @override
  State<PageDecider> createState() => _PageDeciderState();
}

class _PageDeciderState extends State<PageDecider> {
  Future<Widget> splashScreen(BuildContext context) async {
    final bool hasLogin = await HiveHelper.getFromHive(boxName: AppKeys.userBox, key: AppKeys.hasLogin) ?? false;
    log("hasLogin $hasLogin");
    if (hasLogin) {
      return MyPricesScreen();
    } else {
      return LoginScreen();
    }
  }

  late Future<Widget> _splashFuture;

  @override
  void initState() {
    super.initState();
    _splashFuture = splashScreen(context); // Called only once
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _splashFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(backgroundColor: context.tertiary, body: SizedBox.shrink());
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        } else if (snapshot.hasData) {
          return snapshot.data!;
        }
        return const Scaffold(body: Center(child: Text('Something went wrong')));
      },
    );
  }
}

class MyPricesScreen extends StatefulWidget {
  const MyPricesScreen({super.key});

  @override
  State<MyPricesScreen> createState() => _MyPricesScreenState();
}

class _MyPricesScreenState extends State<MyPricesScreen> {
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

  Future<void> _onRefresh(BuildContext context) async {
    context.read<PricesBloc>().add(GetCursEvent());
  }

  List<Cur> curs = [];
  List<Cur> unusedCurs = [];
  List<Price> prices = [];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => getIt<PricesBloc>()..add(GetCursEvent()),
      child: BlocListener<PricesBloc, PricesState>(
        listenWhen: (previous, current) => previous.getCursStatus != current.getCursStatus,
        listener: (context, state) {
          if (state.getCursStatus == Status.success && state.getCursResponse != null) {
            curs = state.getCursResponse!.curs;
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 5),
                          Align(
                            alignment: Alignment.centerRight,
                            child: AppText.titleLarge(
                              "اسعاري:",
                              textAlign: TextAlign.right,
                              fontWeight: FontWeight.bold,
                              color: context.primaryColor,
                            ),
                          ),
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
                                log("${curs.length}");
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

                              if (state.getExchangeUsdStatus == Status.failure) {
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AppText.bodyLarge("لايوجد نشرة اسعار لعرضها", fontWeight: FontWeight.w400),
                                      SizedBox(height: 10),
                                      LargeButton(
                                        onPressed: () {
                                          context.read<PricesBloc>()
                                            ..add(GetExchangeSypEvent())
                                            ..add(GetExchangeUsdEvent());
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
