import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/extentions/size_extension.dart';
import 'package:exchange_darr/common/state_managment/bloc_state.dart';
import 'package:exchange_darr/common/widgets/app_text.dart';
import 'package:exchange_darr/common/widgets/custom/exchange_price_container.dart';
import 'package:exchange_darr/common/widgets/large_button.dart';
import 'package:exchange_darr/core/di/injection.dart';
import 'package:exchange_darr/features/prices/data/models/get_curs_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_prices_response.dart' hide Center;
import 'package:exchange_darr/features/prices/data/models/get_prices_uni_response.dart';
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
  int selectedIndex = 0;
  List<CityPrices> citiesList = [];
  List<Cur> curs = [];
  Future<void> _onRefresh(BuildContext context) async {
    context.read<PricesBloc>().add(GetUniPricesEvent(isRefreshScreen: true));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => getIt<PricesBloc>()..add(GetUniPricesEvent(isRefreshScreen: true)),
      child: BlocListener<PricesBloc, PricesState>(
        listenWhen: (previous, current) => previous.getCursStatus != current.getCursStatus,
        listener: (context, state) {
          // if (state.getCursStatus == Status.success && state.getCursResponse != null) {
          //   curs = state.getCursResponse!.curs;
          //   context.read<PricesBloc>().add(GetUniPricesEvent(isRefreshScreen: true));
          // }
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
                              "الاسعار العالمية:",
                              textAlign: TextAlign.right,
                              fontWeight: FontWeight.bold,
                              color: context.onPrimaryColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: BlocBuilder<PricesBloc, PricesState>(
                            builder: (context, state) {
                              if (state.getUniPricesStatus == Status.loading ||
                                  state.getUniPricesStatus == Status.initial ||
                                  state.getCursStatus == Status.loading) {
                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 4,
                                  itemBuilder: (context, index) => Skeletonizer(
                                    enabled: true,
                                    containersColor: const Color.fromARGB(99, 158, 158, 158),
                                    enableSwitchAnimation: true,
                                    child: ExchangePriceContainer(
                                      parms: PriceContainerParms(
                                        buyCur: "price",
                                        buyPrice: "price",
                                        sellCur: "price",
                                        sellPrice: "price",
                                        curs: [],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              if (state.getUniPricesStatus == Status.success && state.getPricesUniResponse != null) {
                                final List<GetPricesUniResponse> prices = state.getPricesUniResponse!;

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: prices.length,
                                  itemBuilder: (context, index) {
                                    final price = prices[index];

                                    return ExchangePriceContainer(
                                      parms: PriceContainerParms(
                                        buyCur: price.cur1,
                                        buyPrice: price.buy.toString(),
                                        sellCur: price.cur2,
                                        sellPrice: price.sell.toString(),
                                        curs: curs,
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
