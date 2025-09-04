import 'dart:developer';

import 'package:exchange_darr/common/consts/app_keys.dart';
import 'package:exchange_darr/common/state_managment/bloc_state.dart';
import 'package:exchange_darr/common/widgets/app_text.dart';
import 'package:exchange_darr/common/widgets/custom_toggle.dart';
import 'package:exchange_darr/core/datasources/hive_helper.dart';
import 'package:exchange_darr/features/auth/presentation/pages/login_screen.dart';
import 'package:exchange_darr/features/prices/data/models/get_curs_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_exchage_response.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/change_activation_usecase.dart';
import 'package:exchange_darr/features/prices/presentation/bloc/prices_bloc.dart';
import 'package:exchange_darr/features/prices/presentation/widgets/my_prices_content.dart';
import 'package:exchange_darr/features/prices/presentation/widgets/status_messages_content.dart';
import 'package:flutter/material.dart';
import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/extentions/size_extension.dart';
import 'package:exchange_darr/core/di/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  Future<void> _onRefresh(BuildContext context) async {
    context.read<PricesBloc>().add(GetCursEvent());
    context.read<PricesBloc>().add(ShowMsgEvent());
    context.read<PricesBloc>().add(CheckActivationStatusEvent());
  }

  List<Cur> curs = [];
  List<Cur> unusedCurs = [];
  List<Price> prices = [];
  bool isMyPrices = true;
  bool isActive = true;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => getIt<PricesBloc>()
        ..add(GetCursEvent())
        ..add(ShowMsgEvent())
        ..add(CheckActivationStatusEvent()),
      child: MultiBlocListener(
        listeners: [
          BlocListener<PricesBloc, PricesState>(
            listenWhen: (previous, current) => previous.getCursResponse != current.getCursResponse,
            listener: (context, state) {
              if (state.getCursResponse != null) {
                setState(() {
                  curs = state.getCursResponse!.curs;
                });
                context.read<PricesBloc>().add(GetExchangeSypEvent());
              }
            },
          ),
          BlocListener<PricesBloc, PricesState>(
            listenWhen: (previous, current) => previous.addMsgStatus != current.addMsgStatus,
            listener: (context, state) {
              if (state.addMsgStatus == Status.success) {
                context.read<PricesBloc>().add(ShowMsgEvent());
              }
            },
          ),
          BlocListener<PricesBloc, PricesState>(
            listenWhen: (previous, current) => previous.deleteMsgStatus != current.deleteMsgStatus,
            listener: (context, state) {
              if (state.deleteMsgStatus == Status.success) {
                context.read<PricesBloc>().add(ShowMsgEvent());
              }
            },
          ),
          BlocListener<PricesBloc, PricesState>(
            listenWhen: (previous, current) => previous.changeActivationStatus != current.changeActivationStatus,
            listener: (context, state) {
              if (state.changeActivationStatus == Status.success) {
                context.read<PricesBloc>().add(CheckActivationStatusEvent());
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Row(
                              spacing: 15,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AppText.titleSmall(
                                  "ظهور:",
                                  fontWeight: FontWeight.w600,
                                  color: context.onPrimaryColor,
                                  height: 1.7,
                                ),
                                BlocBuilder<PricesBloc, PricesState>(
                                  builder: (context, state) {
                                    if (state.checkActivationStatus == Status.loading ||
                                        state.checkActivationStatus == Status.initial) {
                                      return CustomToggle(initialValue: isActive, onChanged: (newValue) async {});
                                    }

                                    if (state.checkActivationStatus == Status.success &&
                                        state.checkActivationStatusResponse != null) {
                                      isActive = state.checkActivationStatusResponse!.info == "false";

                                      log("isActive $isActive");

                                      return CustomToggle(
                                        initialValue: isActive,
                                        onChanged: (newValue) async {
                                          final int? id =
                                              await HiveHelper.getFromHive(
                                                boxName: AppKeys.userBox,
                                                key: AppKeys.userId,
                                              ) ??
                                              0;

                                          final ChangeActivationParams params = ChangeActivationParams(
                                            status: (!newValue).toString(),
                                            id: id!,
                                          );
                                          context.read<PricesBloc>().add(ChangeActivationEvent(params: params));
                                        },
                                      );
                                    }

                                    return SizedBox.shrink();
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            IntrinsicHeight(
                              child: Row(
                                spacing: 20,
                                crossAxisAlignment: CrossAxisAlignment.stretch, // ✅ center all vertically
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      isMyPrices = true;
                                    }),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: isMyPrices ? context.tertiary : context.onPrimaryColor,
                                          width: 2,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      alignment: Alignment.centerRight,
                                      child: AppText.titleSmall(
                                        "اسعاري",
                                        fontWeight: FontWeight.w400,
                                        color: isMyPrices ? context.tertiary : context.onPrimaryColor,
                                        height: 1.7,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      isMyPrices = false;
                                    }),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: isMyPrices ? context.onPrimaryColor : context.tertiary,
                                          width: 2,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      alignment: Alignment.centerRight,
                                      child: AppText.titleSmall(
                                        "رسائل الشاشة",
                                        fontWeight: FontWeight.w400,
                                        color: isMyPrices ? context.onPrimaryColor : context.tertiary,
                                        height: 1.7,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),

                            isMyPrices
                                ? MyPricesContent(pricesList: prices, curs: curs, onRefresh: () => _onRefresh(context))
                                : StatusMessagesContent(),
                          ],
                        ),
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
