import 'package:bootcamperciyes_final_project/product/constants/application_constant.dart';
import 'package:flutter/material.dart';

class ApplicationNavigationBar extends StatefulWidget {
  const ApplicationNavigationBar({super.key});

  @override
  State<ApplicationNavigationBar> createState() =>
      _ApplicationNavigationBarState();
}

class _ApplicationNavigationBarState extends State<ApplicationNavigationBar> {
  static int current = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 0,
      onTap: (index) {
        current = index;
        Application.navigationPages.elementAt(current).navigate();
      },
      items: Application.navigationPages
          .map((e) => BottomNavigationBarItem(icon: e.icon!, label: e.name))
          .toList(),
    );
  }
}
