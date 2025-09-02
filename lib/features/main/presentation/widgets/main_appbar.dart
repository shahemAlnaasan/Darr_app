import 'package:exchange_darr/common/theme/app_theme.dart';
import 'package:exchange_darr/features/main/bloc/main_bloc.dart';
import 'package:exchange_darr/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/extentions/colors_extension.dart';

AppBar mainAppbar(
  BuildContext context, {
  void Function()? onTap,
  required void Function()? onLoginPress,
  required void Function()? onNewPress,
}) {
  return AppBar(
    toolbarHeight: 60,
    backgroundColor: context.background,
    elevation: 0,
    surfaceTintColor: context.background,
    automaticallyImplyLeading: false,
    leading: InkWell(
      onTap: onTap,
      child: Icon(Icons.menu, color: context.onPrimaryColor),
    ),
    title: Image.asset(Assets.images.logo.companyLogo.path, scale: 11, filterQuality: FilterQuality.high),
    titleSpacing: 0,
    actions: [
      BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return buildActionButton(
            icon: state.theme == AppTheme.lightTheme
                ? Assets.images.navbar.nightMode.path
                : Assets.images.navbar.lightMode.path,
            onPressed: () {
              context.read<MainBloc>().add(SetThemeEvent());
            },
            context: context,
          );
        },
      ),
      buildActionButton(icon: Assets.images.user.path, scale: 5, onPressed: () => onLoginPress!(), context: context),
    ],
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(0.5),
      child: Container(height: 2, color: context.onPrimaryColor),
    ),
  );
}

Widget buildActionButton({
  required String icon,
  double? scale,
  required void Function()? onPressed,
  required BuildContext context,
}) {
  return InkWell(
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    onTap: onPressed,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [Image.asset(icon, scale: scale ?? 6.5, color: context.onPrimaryColor)],
    ),
  );
}
