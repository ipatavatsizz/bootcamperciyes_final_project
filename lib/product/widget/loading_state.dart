import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    required this.child,
    this.color,
    this.size = 32,
    this.value,
  });

  final Widget child;
  final double? value;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.beat(
            color: color ?? Theme.of(context).colorScheme.primary,
            size: size,
          ),
          SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
