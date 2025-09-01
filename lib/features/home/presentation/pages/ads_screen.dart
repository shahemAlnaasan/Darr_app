import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/extentions/size_extension.dart';
import 'package:exchange_darr/common/state_managment/bloc_state.dart';
import 'package:exchange_darr/common/widgets/app_text.dart';
import 'package:exchange_darr/common/widgets/large_button.dart';
import 'package:exchange_darr/core/di/injection.dart';
import 'package:exchange_darr/features/home/data/models/get_ads_response.dart';
import 'package:exchange_darr/features/home/presentation/bloc/home_bloc.dart';
import 'package:exchange_darr/features/home/presentation/widgets/ad_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  GetAdsResponse? getAdsResponse;
  Future<void> _onRefresh(BuildContext context) async {
    context.read<HomeBloc>().add(GetAdsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => getIt<HomeBloc>()..add(GetAdsEvent()),
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
                          "الاعلانات:",
                          textAlign: TextAlign.right,
                          fontWeight: FontWeight.bold,
                          color: context.onPrimaryColor,
                        ),
                      ),
                      SizedBox(height: 20),
                      BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          if (state.getAdsStatus == Status.loading || state.getAdsStatus == Status.initial) {
                            return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 4,
                              itemBuilder: (context, index) => Skeletonizer(
                                enabled: true,
                                containersColor: const Color.fromARGB(99, 158, 158, 158),
                                enableSwitchAnimation: true,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: AdContainer(
                                    ad: Ad(title: "titlasfasfasfdfsdfe", txt: "txt", img: "img", map: "map"),
                                  ),
                                ),
                              ),
                            );
                          }
                          if (state.getAdsStatus == Status.success && state.getAdsResponse != null) {
                            getAdsResponse = state.getAdsResponse!;
                            return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: getAdsResponse!.ads.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: AdContainer(ad: getAdsResponse!.ads[index]),
                                );
                              },
                            );
                          }

                          if (state.getAdsStatus == Status.failure) {
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
    );
  }
}
