import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bootcamperciyes_final_project/feature/onboard/onboard_item.dart';
import 'package:bootcamperciyes_final_project/feature/onboard/onboard_view.dart';
import 'package:bootcamperciyes_final_project/product/constant/locale_keys.g.dart';
import 'package:bootcamperciyes_final_project/product/core/application.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Future<void> initialize() async {
    // Future.wait([
    //   Geolocator.requestPermission(),
    //   context.read<AuthCubit>().signIn(),
    // ]);

    debugPrint(Application.path.images.add('welcome.png'));

    Application.navigation.currentState?.pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, _, __) => OnboardView(
          children: [
            OnboardItem(
              image: Image.asset(
                Application.path.images.add('welcome.png'),
                width: 200,
                height: 200,
              ),
              onNext: (controller) => controller.nextPage(
                duration: Duration(milliseconds: 250),
                curve: Curves.linear,
              ),
              text: [
                'Merhaba! Görüyorum ki bu ${LocaleKeys.title.tr()} ile ilk deneyimin.',
                'Hadi, izin ver sana uygulamayı tanıtayım.',
              ],
            ),
            OnboardItem(
              onFinish: (controller) async {},
              onNext: (controller) {},
              text: [
                'Öncelikle birkaç adet uygulama izni istemem gerekecek.',
                'Bu izinleri sadece uygulama çalışırken kullandığımı unutma.',
                'Veri güvenliğin konusunda bana güvenebilirsin! 😊',
              ],
            ),
          ],
        ),
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
