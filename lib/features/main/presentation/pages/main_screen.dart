import 'package:easy_localization/easy_localization.dart';
import 'package:exchange_darr/common/state_managment/bloc_state.dart';
import 'package:exchange_darr/common/utils/url_launche_helper.dart';
import 'package:exchange_darr/core/di/injection.dart';
import 'package:exchange_darr/features/home/data/models/get_company_info_response.dart';
import 'package:exchange_darr/features/home/presentation/bloc/home_bloc.dart';
import 'package:exchange_darr/features/home/presentation/pages/ads_screen.dart';
import 'package:exchange_darr/features/home/presentation/pages/home_screen.dart';
import 'package:exchange_darr/features/main/presentation/pages/about_us_screen.dart';
import 'package:exchange_darr/features/prices/presentation/pages/best_prices_screen.dart';
import 'package:exchange_darr/features/prices/presentation/pages/my_prices_screen.dart';
import 'package:exchange_darr/features/prices/presentation/pages/dollar_prices_screen.dart';
import 'package:exchange_darr/features/prices/presentation/pages/world_prices_screen.dart';
import 'package:exchange_darr/generated/assets.gen.dart';
import 'package:exchange_darr/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/widgets/app_text.dart';
import '../widgets/main_appbar.dart';

class MainScreen extends StatelessWidget {
  final int? selectedIndex;

  const MainScreen({super.key, this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return _MainScreenContent(initialIndex: selectedIndex ?? 2);
  }
}

class _MainScreenContent extends StatefulWidget {
  final int initialIndex;

  const _MainScreenContent({required this.initialIndex});

  @override
  State<_MainScreenContent> createState() => _MainScreenContentState();
}

class _MainScreenContentState extends State<_MainScreenContent> {
  late int _selectedIndex;
  final List<int> _tabHistory = [];
  GetCompanyInfoResponse? getCompanyInfoResponse;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _tabHistory.add(_selectedIndex);
  }

  final _navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
    3: GlobalKey<NavigatorState>(),
    4: GlobalKey<NavigatorState>(),
  };

  final List<Widget> _rootScreens = [
    const BestPricesScreen(),
    const DollarPricesScreen(),
    const HomeScreen(),
    const WorldPricesScreen(),
    const AdsScreen(),
  ];

  void _onTabTapped(int index) {
    if (_selectedIndex == index) {
      final navigator = _navigatorKeys[index]!.currentState!;
      navigator.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _tabHistory.remove(index);
        _tabHistory.add(index);
        _selectedIndex = index;
      });
    }
  }

  Widget _buildTabNavigator(int index) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (_) => _rootScreens[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        final currentNavigator = _navigatorKeys[_selectedIndex]!.currentState!;
        if (didPop) return;

        if (currentNavigator.canPop()) {
          currentNavigator.pop();
        } else if (_tabHistory.length > 1) {
          setState(() {
            _tabHistory.removeLast();
            _selectedIndex = _tabHistory.last;
          });
        } else {
          SystemNavigator.pop();
        }
      },
      child: BlocProvider(
        create: (context) => getIt<HomeBloc>()..add(GetCompanyInfoEvent()),
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state.getCompanyInfoStatus == Status.success || state.getCompanyInfoResponse != null) {
              setState(() {
                getCompanyInfoResponse = state.getCompanyInfoResponse!;
              });
            }
          },
          child: Scaffold(
            key: _scaffoldKey,
            appBar: mainAppbar(
              context,
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              onLoginPress: () {
                final currentNavigator = _navigatorKeys[_selectedIndex]!.currentState!;
                currentNavigator.push(MaterialPageRoute(builder: (_) => PageDecider()));
              },
              onNewPress: () {
                final currentNavigator = _navigatorKeys[_selectedIndex]!.currentState!;
                currentNavigator.push(MaterialPageRoute(builder: (_) => AdsScreen()));
              },
            ),
            drawer: _buildDrawer(context, onTabTapped: _onTabTapped, getCompanyInfoResponse: getCompanyInfoResponse),
            extendBody: true,
            backgroundColor: context.primaryColor,
            body: _buildTabNavigator(_selectedIndex),
            bottomNavigationBar: _buildBottomBar(),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: context.background,
        border: Border(top: BorderSide(color: context.onPrimaryColor, width: 2)),
      ),
      child: BottomAppBar(
        notchMargin: 16,
        padding: const EdgeInsets.only(bottom: 2, top: 1),
        height: 75,
        color: context.background,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            final icons = [
              Assets.images.bestPrice.path,
              Assets.images.dollar.path,
              Assets.images.navbar.home.path,
              Assets.images.world.path,
              Assets.images.news.path,
            ];
            return _buildNavItem(icon: icons[index], index: index);
          }),
        ),
      ),
    );
  }

  Widget _buildNavItem({required String icon, required int index}) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () => _onTabTapped(index),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4, top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Image.asset(
                icon,
                scale: isSelected ? 5.5 : 6,
                color: isSelected ? context.onTertiary : context.onPrimaryColor,
                alignment: Alignment.bottomCenter,
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.topCenter,
                child: AppText.bodyMedium(
                  ["افضل الاسعار", "اسعار الدولار", LocaleKeys.navbar_home.tr(), "اسعار عالمية", "الاعلانات"][index],
                  style: context.textTheme.labelMedium!.copyWith(
                    color: isSelected ? context.onTertiary : context.onPrimaryColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(
    BuildContext context, {
    required void Function(int) onTabTapped,
    required GetCompanyInfoResponse? getCompanyInfoResponse,
  }) {
    return Drawer(
      backgroundColor: context.background,
      child: Column(
        children: [
          SizedBox(height: 50),
          Image.asset(Assets.images.logo.companyLogo.path, scale: 9, filterQuality: FilterQuality.high),
          ListTile(
            leading: Image.asset(Assets.images.user.path, scale: 5.5, color: context.onPrimaryColor),
            title: Text("تسجيل الدخول"),
            onTap: () {
              Navigator.pop(context);
              final currentNavigator = _navigatorKeys[_selectedIndex]!.currentState!;
              currentNavigator.push(MaterialPageRoute(builder: (_) => PageDecider()));
            },
          ),
          ListTile(
            leading: Image.asset(Assets.images.navbar.home.path, scale: 5.5, color: context.onPrimaryColor),
            title: Text("الرئيسية"),
            onTap: () {
              Navigator.pop(context);
              onTabTapped(2);
            },
          ),
          ListTile(
            leading: Image.asset(Assets.images.bestPrice.path, scale: 5.5, color: context.onPrimaryColor),
            title: Text("أفضل الأسعار"),
            onTap: () {
              Navigator.pop(context);
              onTabTapped(0);
            },
          ),
          ListTile(
            leading: Image.asset(Assets.images.dollar.path, scale: 5.5, color: context.onPrimaryColor),
            title: Text("أسعار الدولار"),
            onTap: () {
              Navigator.pop(context);
              onTabTapped(1);
            },
          ),
          ListTile(
            leading: Image.asset(Assets.images.world.path, scale: 5.5, color: context.onPrimaryColor),
            title: Text("الأسعار العالمية"),
            onTap: () {
              Navigator.pop(context);
              onTabTapped(3);
            },
          ),
          ListTile(
            leading: Image.asset(Assets.images.news.path, scale: 5.5, color: context.onPrimaryColor),
            title: Text("الاعلانات"),
            onTap: () {
              Navigator.pop(context);
              onTabTapped(4);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(color: context.onPrimaryColor, height: 2, thickness: 1),
          ),
          SizedBox(height: 10),
          AppText.bodyLarge("تابعنا على صفحاتنا", fontWeight: FontWeight.bold),
          SizedBox(height: 20),
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () async => await UrlLaucncheHelper.launchWebUrl(getCompanyInfoResponse!.info.facebook),
                child: Image.asset(Assets.images.facebook.path, scale: 4, color: context.onPrimaryColor),
              ),
              GestureDetector(
                onTap: () async => await UrlLaucncheHelper.launchWebUrl(getCompanyInfoResponse!.info.whatsapp),
                child: Image.asset(Assets.images.whatsapp.path, scale: 4, color: context.onPrimaryColor),
              ),
              GestureDetector(
                onTap: () async => await UrlLaucncheHelper.launchWebUrl(getCompanyInfoResponse!.info.telegram),
                child: Image.asset(Assets.images.telegram.path, scale: 4, color: context.onPrimaryColor),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(color: context.onPrimaryColor, height: 2, thickness: 1),
          ),

          ListTile(
            leading: Image.asset(Assets.images.info.path, scale: 5.5, color: context.onPrimaryColor),
            title: Text("من نحن"),
            onTap: () {
              Navigator.pop(context);
              final currentNavigator = _navigatorKeys[_selectedIndex]!.currentState!;
              currentNavigator.push(
                MaterialPageRoute(builder: (_) => AboutUsScreen(title: getCompanyInfoResponse!.info.aboutus)),
              );
            },
          ),
          ListTile(
            leading: Image.asset(Assets.images.share.path, scale: 5.5, color: context.onPrimaryColor),
            title: Text("شارك التطبيق"),
            onTap: () async => await UrlLaucncheHelper.launchWebUrl(getCompanyInfoResponse!.info.share),
          ),
        ],
      ),
    );
  }
}
