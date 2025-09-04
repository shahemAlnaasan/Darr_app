import 'package:exchange_darr/common/extentions/colors_extension.dart';
import 'package:exchange_darr/common/extentions/size_extension.dart';
import 'package:exchange_darr/common/widgets/app_text.dart';
import 'package:exchange_darr/generated/assets.gen.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  final String title;
  const AboutUsScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      body: Container(
        width: context.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: AppText.titleLarge(
                  "من نحن:",
                  fontWeight: FontWeight.bold,
                  color: context.onPrimaryColor,
                  textAlign: TextAlign.right,
                  // style: TextStyle(fontSize: 19),
                ),
              ),
              SizedBox(height: 20),
              Image.asset(Assets.images.logo.companyLogo.path, scale: 7),
              SizedBox(height: 20),
              AppText.bodyMedium(
                title,
                fontWeight: FontWeight.w400,
                color: context.onPrimaryColor,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 19),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
