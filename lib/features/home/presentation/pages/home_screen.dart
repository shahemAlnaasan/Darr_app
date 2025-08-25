import 'package:exchange_darr/common/extentions/size_extension.dart';
import 'package:exchange_darr/features/home/presentation/widgets/sos_drop_down.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.screenWidth,
        height: context.screenHeight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            SosDropdown(dropDownTitle: "حلب"),
            SosDropdown(dropDownTitle: "دمشق"),
            SosDropdown(dropDownTitle: "ادلب"),
          ],
        ),
      ),
    );
  }
}
