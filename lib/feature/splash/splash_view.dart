import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bootcamperciyes_final_project/product/constant/application_constant.dart';
import 'package:bootcamperciyes_final_project/product/constant/locale_keys.g.dart';
import 'package:bootcamperciyes_final_project/product/constant/navigation_constant.dart';
import 'package:bootcamperciyes_final_project/product/cubit/auth_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Future<void> initialize() async {
    Future.wait([
      Geolocator.requestPermission(),
      context.read<AuthCubit>().signIn(),
    ]);

    Application.navigation.currentState?.pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, _, __) => NavigationPages.home.page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 100,
                child: Image.asset('${Application.path.icons}/app_icon.png'),
              ),
              AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    LocaleKeys.title.tr(),
                    textStyle:
                        Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                    speed: Duration(milliseconds: 120),
                  ),
                ],
                isRepeatingAnimation: false,
                onFinished: initialize,
                totalRepeatCount: 1,
              ),
              Text(
                LocaleKeys.subtitle,
                style: Theme.of(context).textTheme.bodyLarge,
              ).tr(),
            ],
          ),
        ),
      ),
    );
  }
}
