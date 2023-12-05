import 'package:bootcamperciyes_final_project/feature/not_found/not_found_view.dart';
import 'package:bootcamperciyes_final_project/feature/splash/splash_view.dart';
import 'package:bootcamperciyes_final_project/product/constant/application_constant.dart';
import 'package:bootcamperciyes_final_project/product/constant/language_constant.dart';
import 'package:bootcamperciyes_final_project/product/cubit/places/places_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    MultiBlocListener(
      listeners: [
        BlocProvider<PlacesCubit>(
          create: (context) => PlacesCubit(),
        ),
      ],
      child: EasyLocalization(
        path: Application.path.translations,
        startLocale: Application.language.toLocale(),
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
      home: SplashView(),
      theme: ThemeData.light().copyWith(
        brightness: Brightness.light,
        textTheme: GoogleFonts.openSansTextTheme(),
      ),
      // darkTheme: ThemeData.dark().copyWith(
      //   brightness: Brightness.dark,
      //   textTheme: GoogleFonts.openSansTextTheme(),
      // ),
    );
  }
}
