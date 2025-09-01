import 'package:exchange_darr/generated/assets.gen.dart';
import 'package:flutter/material.dart';
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
    // actionsPadding: const EdgeInsets.only(left: 20),

    // forceMaterialTransparency: true,
    title: Image.asset(Assets.images.logo.companyLogo.path, scale: 11, filterQuality: FilterQuality.high),
    // leading: Padding(
    //   padding: const EdgeInsets.only(right: 15),
    // child: Image.asset(Assets.images.logo.logo.path, scale: 10, filterQuality: FilterQuality.high),
    // ),
    leadingWidth: 65,

    actions: [
      buildActionButton(icon: Assets.images.news.path, scale: 5.3, onPressed: () => onNewPress!(), context: context),
      // SizedBox(width: 20),
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [Image.asset(icon, scale: scale ?? 6.5, color: context.onPrimaryColor)],
    ),
  );
}
