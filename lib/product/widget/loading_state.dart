import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({required this.child, super.key, this.value});

  final Widget child;
  final double? value;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(value: value),
          SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
