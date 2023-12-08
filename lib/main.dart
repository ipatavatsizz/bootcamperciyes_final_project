import 'package:bootcamperciyes_final_project/feature/not_found/not_found_view.dart';
import 'package:bootcamperciyes_final_project/feature/onboard/onboard_item.dart';
import 'package:bootcamperciyes_final_project/feature/onboard/onboard_view.dart';
import 'package:bootcamperciyes_final_project/firebase_options.dart';
import 'package:bootcamperciyes_final_project/product/constant/color_schemes.g.dart';
import 'package:bootcamperciyes_final_project/product/constant/language_constant.dart';
import 'package:bootcamperciyes_final_project/product/constant/locale_keys.g.dart';
import 'package:bootcamperciyes_final_project/product/core/application.dart';
import 'package:bootcamperciyes_final_project/product/cubit/auth_cubit.dart';
import 'package:bootcamperciyes_final_project/product/cubit/card_cubit.dart';
import 'package:bootcamperciyes_final_project/product/cubit/language_cubit.dart';
import 'package:bootcamperciyes_final_project/product/cubit/places_cubit.dart';
import 'package:bootcamperciyes_final_project/product/cubit/search_cubit.dart';
import 'package:bootcamperciyes_final_project/product/service/database_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChannels.textInput.invokeMethod('TextInput.hide');

  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // This feature will be added later
  // final GoogleSignIn googleSignIn = GoogleSignIn(
  //   // The OAuth client id of your app. This is required.
  //   clientId: 'Your Client ID',
  // );

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await DatabaseService.initialize();

  runApp(
    MultiBlocListener(
      listeners: [
        BlocProvider<PlacesCubit>(create: (context) => PlacesCubit()),
        BlocProvider<SearchCubit>(create: (context) => SearchCubit()),
        BlocProvider<CardCubit>(create: (context) => CardCubit()),
        BlocProvider<LanguageCubit>(create: (context) => LanguageCubit()),
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
      ],
      child: EasyLocalization(
        path: Application.path.translations,
        startLocale: Languages.fromString(
          DatabaseService.instance.database
              .get('language', defaultValue: Application.language.name)!,
        ).toLocale(),
        fallbackLocale: Languages.english.toLocale(),
        supportedLocales: Application.supportedLanguages.toLocale(),
        child: MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      debugShowCheckedModeBanner: false,
      scrollBehavior: MaterialScrollBehavior().copyWith(overscroll: false),
      scaffoldMessengerKey: Application.messenger,
      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (context) => NotFoundView()),
      navigatorKey: Application.navigation,
      home: OnboardView(
        children: [
          OnboardItem(
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
            onDisplay: (controller) async {
              final permission = await Geolocator.requestPermission();
              if (permission == LocationPermission.denied ||
                  permission == LocationPermission.deniedForever) {}
            },
            text: [
              'Öncelikle birkaç adet uygulama izni istemem gerekecek.'
                  'Bu izinleri sadece uygulama çalışırken kullandığımı unutma.'
                  'Veri güvenliğin konusunda bana güvenebilirsin! 😊',
            ],
          ),
        ],
      ),
      theme: ApplicationTheme.light,
      // darkTheme: ThemeData(
      //   useMaterial3: true,
      //   colorScheme: ApplicationTheme.dark,
      //   textTheme: GoogleFonts.openSansTextTheme(),
      //   appBarTheme: Theme.of(context).appBarTheme.copyWith(
      //         elevation: 0,
      //         scrolledUnderElevation: 0,
      //       ),
      // ),
      // theme: ThemeData.light().copyWith(
      //   brightness: Brightness.light,
      //   appBarTheme: Theme.of(context).appBarTheme.copyWith(
      //         elevation: 0,
      //         scrolledUnderElevation: 0,
      //       ),
      //   textTheme: GoogleFonts.openSansTextTheme(),
      // ),
      // darkTheme: ThemeData.dark().copyWith(
      //   brightness: Brightness.dark,
      //   textTheme: GoogleFonts.openSansTextTheme(),
      // ),
    );
  }
}
