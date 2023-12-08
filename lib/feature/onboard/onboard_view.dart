import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bootcamperciyes_final_project/feature/onboard/onboard_item.dart';
import 'package:bootcamperciyes_final_project/product/constant/navigation_constant.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class OnboardView extends StatefulWidget {
  OnboardView({
    required this.children,
    this.phase,
    super.key,
  });

  final List<OnboardItem> children;
  final int? phase;

  @override
  State<OnboardView> createState() => _OnboardViewState();
}

class _OnboardViewState extends State<OnboardView> {
  int currentIndex = 0;
  late final PageController controller =
      PageController(initialPage: widget.phase ?? 0);

  @override
  void initState() {
    super.initState();
    final onDisplay = widget.children.elementAtOrNull(currentIndex)?.onDisplay;
    if (onDisplay != null) onDisplay(controller);

    Timer.periodic(Duration(seconds: 8), (_) {
      if (currentIndex >= widget.children.length) {
        controller.nextPage(
          duration: Duration(milliseconds: 250),
          curve: Curves.linear,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      body: PageView(
        onPageChanged: (value) => currentIndex = value,
        controller: controller,
        children: [
          ...widget.children.map(
            (item) {
              final animatedTexts = item.text
                  .map(
                    (text) => TyperAnimatedText(
                      text,
                      speed: Duration(milliseconds: 60),
                    ),
                  )
                  .toList();
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (item.image != null) ...[
                          item.image!,
                          SizedBox(height: 20),
                        ],
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: AnimatedTextKit(
                            totalRepeatCount: 1,
                            onFinished: () {
                              if (item.onFinish != null) {
                                item.onFinish!(controller);
                              }
                            },
                            animatedTexts: animatedTexts,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        item.onBack != null
                            ? ElevatedButton.icon(
                                onPressed: () => item.onBack != null
                                    ? item.onBack!(controller)
                                    : null,
                                icon: Icon(Ionicons.chevron_back_outline),
                                label: Text('Back'),
                              )
                            : SizedBox.shrink(),
                        currentIndex != widget.children.length
                            ? ElevatedButton.icon(
                                onPressed: () {
                                  if (item.onNext != null) {
                                    item.onNext!(controller);
                                  }
                                  controller.nextPage(
                                    duration: Duration(milliseconds: 250),
                                    curve: Curves.linear,
                                  );
                                },
                                icon: Icon(Ionicons.chevron_forward_outline),
                                label: Text('Next'),
                              )
                            : ElevatedButton.icon(
                                onPressed: () =>
                                    NavigationPages.home.navigate(),
                                icon: Icon(Ionicons.navigate_circle),
                                label: Text('Başla!'),
                              ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
