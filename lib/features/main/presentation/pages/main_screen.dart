import 'package:easy_localization/easy_localization.dart';
import 'package:exchange_darr/features/home/presentation/pages/home_screen.dart';
import 'package:exchange_darr/features/prices/presentation/pages/best_prices_screen.dart';
import 'package:exchange_darr/generated/assets.gen.dart';
import 'package:exchange_darr/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/widgets/app_text.dart';
import '../widgets/main_appbar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _MainScreenContent();
  }
}

class _MainScreenContent extends StatefulWidget {
  @override
  State<_MainScreenContent> createState() => _MainScreenContentState();
}

class _MainScreenContentState extends State<_MainScreenContent> {
  int _selectedIndex = 0;
  final List<int> _tabHistory = [0];

  final _navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
  };

  final List<Widget> _rootScreens = [const HomeScreen(), const BestPricesScreen(), const HomeScreen()];

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
        backgroundColor: context.background,
        body: IndexedStack(
          index: _selectedIndex,
          children: List.generate(_rootScreens.length, (i) => _buildTabNavigator(i)),
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.onPrimaryColor)),
      ),
      child: BottomAppBar(
        notchMargin: 16,
        padding: const EdgeInsets.only(bottom: 2, top: 1),
        height: 75,
        color: context.surfaceContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (index) {
            final icons = [
              Assets.images.navbar.home.path,
              Assets.images.bestPrice.path,
              Assets.images.navbar.home.path,
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
      onTap: () => _onTabTapped(index),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(icon, scale: 5.5, color: context.primaryColor),
            const SizedBox(height: 1),
            AppText.bodyMedium(
              [LocaleKeys.navbar_home.tr(), "افضل الاسعار", LocaleKeys.navbar_how_are_we.tr()][index],
              style: context.textTheme.labelMedium!.copyWith(
                color: context.primaryColor,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: isSelected ? context.primaryColor : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
