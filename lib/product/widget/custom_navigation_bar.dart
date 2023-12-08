import 'package:bootcamperciyes_final_project/product/core/application.dart';
import 'package:flutter/material.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: BottomNavigationBar(
          // IDEA: add selectedSize to look good
          backgroundColor: Colors.transparent,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: Application.navigationIndex,
          elevation: 0,
          onTap: (index) {
            Application.navigationIndex = index;
            Application.navigationPages.elementAt(index).navigate();
          },
          items: Application.navigationPages
              .map((e) => BottomNavigationBarItem(icon: e.icon!, label: e.name))
              .toList(),
        ),
      ),
    );
  }
}
