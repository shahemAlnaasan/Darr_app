import 'package:exchange_darr/app.dart';
import 'package:flutter/material.dart';
import 'common/utils/init_main.dart';

void main() async {
  await Initialization.initMain();
  runApp(Initialization.initLocalization(const App()));
}
