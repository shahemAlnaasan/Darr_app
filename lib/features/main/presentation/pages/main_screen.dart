import 'package:easy_localization/easy_localization.dart';
import 'package:exchange_darr/features/home/presentation/pages/home_screen.dart';
import 'package:exchange_darr/features/prices/presentation/pages/best_prices_screen.dart';
import 'package:exchange_darr/features/prices/presentation/pages/my_prices_screen.dart';
import 'package:exchange_darr/features/prices/presentation/pages/world_prices_screen.dart';
import 'package:exchange_darr/generated/assets.gen.dart';
import 'package:exchange_darr/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/widgets/app_text.dart';
import '../widgets/main_appbar.dart';

class MainScreen extends StatelessWidget {
  final int? selectedIndex; // 👈 optional index

  const MainScreen({super.key, this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return _MainScreenContent(initialIndex: selectedIndex ?? 0);
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
  };

  final List<Widget> _rootScreens = [
    const HomeScreen(),
    const BestPricesScreen(),
    const WorldPricesScreen(),
    const WorldPricesScreen(),
    const WorldPricesScreen(),
    const PageDecider(),
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
      child: Scaffold(
        appBar: mainAppbar(context, onTap: () {}),
        extendBody: true,
        backgroundColor: context.tertiary,
        body: _buildTabNavigator(_selectedIndex),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: context.tertiary,
        border: Border(top: BorderSide(color: context.primaryColor)),
      ),
      child: BottomAppBar(
        notchMargin: 16,
        padding: const EdgeInsets.only(bottom: 2, top: 1),
        height: 75,
        color: context.tertiary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) {
            final icons = [
              Assets.images.navbar.home.path,
              Assets.images.bestPrice.path,
              Assets.images.dollar.path,
              Assets.images.world.path,
              Assets.images.news.path,
              Assets.images.user.path,
            ];
            return Expanded(
              child: _buildNavItem(icon: icons[index], index: index),
            );
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
                color: isSelected ? context.primaryColor : context.primaryColor.withAlpha(150),
                alignment: Alignment.bottomCenter,
              ),
            ),
            // const SizedBox(height: 1),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.topCenter,
                child: AppText.bodyMedium(
                  [
                    LocaleKeys.navbar_home.tr(),
                    "افضل الاسعار",
                    "اسعار الدولار",
                    "الاسعار العالمية",
                    "الاخبار",
                    "اسعاري",
                  ][index],
                  style: context.textTheme.labelMedium!.copyWith(
                    color: isSelected ? context.primaryColor : context.primaryColor.withAlpha(150),
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
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
}
