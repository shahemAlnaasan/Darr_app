import 'package:flutter/material.dart';
import 'main_screen.dart';

Future<Widget> splashScreen(BuildContext context) async {
  // final bool hasLogin = await HiveHelper.getFromHive(boxName: AppKeys.userBox, key: AppKeys.hasLogin) ?? false;
  // final bool hasVerifyLogin =
  //     await HiveHelper.getFromHive(boxName: AppKeys.userBox, key: AppKeys.hasVerifyLogin) ?? false;
  // log("hasLogin $hasLogin");
  // log("hasVerifyLogin $hasVerifyLogin");
  // if (hasLogin) {
  //   if (hasVerifyLogin) {
  //     return MainScreen();
  //   } else {
  //     return BlocProvider(
  //       create: (context) => getIt<AuthBloc>()..add(InitVerifyInfoEvent()),
  //       child: VerifyLoginScreen(),
  //     );
  //   }
  // }
  return MainScreen();
}

class HomeDecider extends StatefulWidget {
  const HomeDecider({super.key});

  @override
  State<HomeDecider> createState() => _HomeDeciderState();
}

class _HomeDeciderState extends State<HomeDecider> {
  late Future<Widget> _splashFuture;

  @override
  void initState() {
    super.initState();
    _splashFuture = splashScreen(context); // Called only once
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _splashFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: SizedBox.shrink());
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        } else if (snapshot.hasData) {
          return snapshot.data!;
        }
        return const Scaffold(body: Center(child: Text('Something went wrong')));
      },
    );
  }
}
