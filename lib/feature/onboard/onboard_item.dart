import 'package:flutter/material.dart';

class OnboardItem {
  final List<String> text;
  final Widget? image;
  final Function(PageController controller)? onDisplay;
  final Function(PageController controller)? onNext;
  final Function(PageController controller)? onBack;
  final Function(PageController controller)? onFinish;

  OnboardItem({
    required this.text,
    this.image,
    this.onDisplay,
    this.onNext,
    this.onBack,
    this.onFinish,
  });
}
