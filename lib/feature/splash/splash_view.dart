import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bootcamperciyes_final_project/product/constants/application_constant.dart';
import 'package:bootcamperciyes_final_project/product/constants/locale_keys.g.dart';
import 'package:bootcamperciyes_final_project/product/constants/navigation_constant.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Future<void> initialize() async {
    await Geolocator.requestPermission();

    Application.navigation.currentState?.pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, _, __) => NavigationPages.home.page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(LocaleKeys.title.tr()),
                ],
                isRepeatingAnimation: false,
                onFinished: initialize,
                totalRepeatCount: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
