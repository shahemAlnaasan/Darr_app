import 'package:flutter/material.dart';
import '../../../../common/extentions/colors_extension.dart';

AppBar mainAppbar(BuildContext context, {void Function()? onTap}) {
  return AppBar(
    toolbarHeight: 60,
    backgroundColor: context.surfaceContainer,
    elevation: 0,
    surfaceTintColor: context.background,
    automaticallyImplyLeading: false,
    actionsPadding: const EdgeInsets.only(left: 15),

    // titleTextStyle: TextStyle(fontWeight: FontWeight.w100),
    title: Text("دار الصرافة", style: TextStyle(fontSize: 20, color: context.primaryColor)),
    // leading: Padding(
    //   padding: const EdgeInsets.only(right: 15),
    //   child: Image.asset(Assets.images.logo.logo.path, scale: 10, filterQuality: FilterQuality.high),
    // ),
    leadingWidth: 65,

    // actions: [buildActionButton(icon: Assets.images.share.path, onPressed: () {}, context: context)],
    // bottom: PreferredSize(
    //   preferredSize: const Size.fromHeight(1),
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 15),
    //     child: Container(height: 2, color: context.onPrimaryColor),
    //   ),
    // ),
  );
}

Widget buildActionButton({
  required String icon,
  double? scale,
  required void Function()? onPressed,
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Image.asset(icon, scale: scale ?? 4, color: Color.fromARGB(255, 31, 57, 95)),
  );
}
