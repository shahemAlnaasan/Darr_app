import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/extentions/navigation_extensions.dart';
import 'package:exchange_darr/common/extentions/size_extension.dart';
import 'package:exchange_darr/common/state_managment/bloc_state.dart';
import 'package:exchange_darr/common/utils/url_launche_helper.dart';
import 'package:exchange_darr/core/di/injection.dart';
import 'package:exchange_darr/features/home/data/models/get_atms_info_response.dart';
import 'package:exchange_darr/features/home/presentation/bloc/home_bloc.dart';
import 'package:exchange_darr/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AtmDetailsScreen extends StatefulWidget {
  final String atmId;
  const AtmDetailsScreen({super.key, required this.atmId});

  @override
  State<AtmDetailsScreen> createState() => _AtmDetailsScreenState();
}

class _AtmDetailsScreenState extends State<AtmDetailsScreen> {
  GetAtmsInfoResponse? getAtmsInfoResponse;
  Future<void> _onRefresh(BuildContext context) async {
    context.read<HomeBloc>().add(GetAtmInfoEvent(id: widget.atmId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => getIt<HomeBloc>()..add(GetAtmInfoEvent(id: widget.atmId)),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.getAtmInfoStatus == Status.success && state.getAtmsInfoResponse != null) {
            setState(() {
              getAtmsInfoResponse = state.getAtmsInfoResponse!;
            });
          }
        },
        child: Scaffold(
          backgroundColor: context.background,
          body: Container(
            width: context.screenWidth,
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "تفاصيل الصراف",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: context.onPrimaryColor,
                                  fontSize: 27,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.pop();
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: context.onPrimaryColor, width: .3),
                                    color: context.primaryColor,
                                  ),
                                  child: Icon(Icons.arrow_forward_ios_outlined, size: 19),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: context.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(color: Color(0x20000000), blurRadius: 5, offset: Offset(0, 4)),
                              ],
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    spacing: 40,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          final result = await MapsLinkHelper.normalizeGoogleMapsLink(
                                            getAtmsInfoResponse!.info.location,
                                          );
                                          await UrlLaucncheHelper.launchWebUrl(result);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: context.tertiary,
                                            borderRadius: BorderRadius.circular(8),
                                            // boxShadow: const [BoxShadow(color: Color(0x20000000), blurRadius: 5, offset: Offset(0, 4))],
                                          ),
                                          padding: EdgeInsets.all(10),
                                          width: 50,
                                          height: 50,
                                          child: Skeleton.ignore(
                                            child: Image.asset(Assets.images.location.path, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: 100,
                                          child: Image.network(
                                            getAtmsInfoResponse?.info.img ?? "",
                                            fit: BoxFit.contain,
                                            filterQuality: FilterQuality.high,
                                            errorBuilder: (context, error, stackTrace) {
                                              return SizedBox.shrink();
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(color: context.onPrimaryColor, height: 2),
                                SizedBox(height: 20),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    "اسم الصراف:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: context.onPrimaryColor,
                                      fontSize: 22,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: BlocBuilder<HomeBloc, HomeState>(
                                    builder: (context, state) {
                                      if (state.getAtmInfoStatus == Status.loading ||
                                          state.getAtmInfoStatus == Status.initial) {
                                        return Skeletonizer(
                                          child: Text(
                                            "dsdsgdsg",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: context.onPrimaryColor,
                                              fontSize: 20,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        );
                                      } else if (state.getAtmInfoStatus == Status.success ||
                                          state.getAtmsInfoResponse != null) {
                                        return Text(
                                          getAtmsInfoResponse!.info.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: context.onPrimaryColor,
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.right,
                                        );
                                      } else {
                                        return SizedBox.shrink();
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(height: 30),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    spacing: 30,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "العنوان:",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: context.onPrimaryColor,
                                              fontSize: 22,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          SizedBox(height: 10),
                                          BlocBuilder<HomeBloc, HomeState>(
                                            builder: (context, state) {
                                              if (state.getAtmInfoStatus == Status.loading ||
                                                  state.getAtmInfoStatus == Status.initial) {
                                                return Skeletonizer(
                                                  child: Text(
                                                    "dsdsgdsg",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w300,
                                                      color: context.onPrimaryColor,
                                                      fontSize: 20,
                                                    ),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                );
                                              } else if (state.getAtmInfoStatus == Status.success ||
                                                  state.getAtmsInfoResponse != null) {
                                                return Text(
                                                  getAtmsInfoResponse?.info.address ?? "",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    color: context.onPrimaryColor,
                                                    fontSize: 20,
                                                  ),
                                                  textAlign: TextAlign.right,
                                                );
                                              } else {
                                                return SizedBox.shrink();
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "رقم الهاتف:",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: context.onPrimaryColor,
                                              fontSize: 22,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          SizedBox(height: 10),
                                          BlocBuilder<HomeBloc, HomeState>(
                                            builder: (context, state) {
                                              if (state.getAtmInfoStatus == Status.loading ||
                                                  state.getAtmInfoStatus == Status.initial) {
                                                return Skeletonizer(
                                                  child: Text(
                                                    "dsdsgdsg",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w300,
                                                      color: context.onPrimaryColor,
                                                      fontSize: 20,
                                                    ),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                );
                                              } else if (state.getAtmInfoStatus == Status.success ||
                                                  state.getAtmsInfoResponse != null) {
                                                return Text(
                                                  getAtmsInfoResponse?.info.phone ?? "",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    color: context.onPrimaryColor,
                                                    fontSize: 20,
                                                  ),
                                                  textAlign: TextAlign.right,
                                                );
                                              } else {
                                                return SizedBox.shrink();
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 40),
                                SizedBox(height: 10),
                              ],
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
}
