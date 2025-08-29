import 'package:flutter/material.dart';
import '../../../../common/extentions/colors_extension.dart';

AppBar mainAppbar(BuildContext context, {void Function()? onTap}) {
  return AppBar(
    toolbarHeight: 60,
    backgroundColor: context.tertiary,
    elevation: 0,
    surfaceTintColor: context.background,
    automaticallyImplyLeading: false,
    actionsPadding: const EdgeInsets.only(left: 15),
    forceMaterialTransparency: true,

    // titleTextStyle: TextStyle(fontWeight: FontWeight.w100),
    title: Text("دار الصرافة", style: TextStyle(fontSize: 20, color: context.primaryColor)),
    // leading: Padding(
    //   padding: const EdgeInsets.only(right: 15),
    //   child: Image.asset(Assets.images.logo.logo.path, scale: 10, filterQuality: FilterQuality.high),
    // ),
    leadingWidth: 65,

    // actions: [buildActionButton(icon: Assets.images.logout.path, onPressed: () {}, context: context)],
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(0.5),
      child: Container(height: 1, color: context.primaryColor),
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
    child: Image.asset(icon, scale: scale ?? 6.5, color: context.primaryColor),
  );
}
