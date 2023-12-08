import 'package:bootcamperciyes_final_project/feature/home/home_view.dart';
import 'package:bootcamperciyes_final_project/feature/not_found/not_found_view.dart';
import 'package:bootcamperciyes_final_project/feature/search/search_view.dart';
import 'package:bootcamperciyes_final_project/feature/settings/settings_view.dart';
import 'package:bootcamperciyes_final_project/feature/splash/splash_view.dart';
import 'package:bootcamperciyes_final_project/product/core/application.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

enum NavigationPages {
  home(
    page: HomeView(),
    icon: Icon(Ionicons.home_outline),
  ),
  notFound(
    page: NotFoundView(),
    visible: false,
  ),
  splash(page: SplashView(), visible: false),
  search(page: SearchView(), icon: Icon(Ionicons.search_outline)),
  settings(
    page: SettingsView(),
    icon: Icon(Ionicons.settings_outline),
  );

  final Widget page;
  final Widget? icon;
  final bool visible;

  const NavigationPages({
    required this.page,
    this.icon,
    this.visible = true,
  });

  void navigate() => {
        Application.navigationIndex = Application.navigationPages.indexOf(this),
        Application.navigation.currentState?.pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionDuration: Duration.zero,
          ),
        ),
      };
}

extension IterableNavigationPages on Iterable<NavigationPages> {
  List<NavigationPages> get filtered => where((e) => e.visible).toList();
  List<Widget> get widget =>
      where((e) => e.visible).map((e) => e.page).toList();
}
