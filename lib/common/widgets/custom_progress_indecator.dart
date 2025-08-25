import 'package:flutter/material.dart';

class CustomProgressIndecator extends StatelessWidget {
  final Color? color;
  const CustomProgressIndecator({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(children: [CircularProgressIndicator(color: color ?? Colors.white)]);
  }
}
