import 'package:exchange_darr/common/extentions/size_extension.dart';
import 'package:exchange_darr/features/auth/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';
import '../../../../common/extentions/colors_extension.dart';
import '../../../../common/widgets/app_text.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      body: SingleChildScrollView(
        child: SizedBox(
          height: context.screenHeight - 2.5 * kBottomNavigationBarHeight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 5, 30, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset(Assets.images.logo.companyLogo.path, scale: 6),
                SizedBox(height: 20),
                AppText.headlineMedium(
                  "مرحبا بكم في دار الصرافة",
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                  color: context.onPrimaryColor,
                ),
                SizedBox(height: 20),
                LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
