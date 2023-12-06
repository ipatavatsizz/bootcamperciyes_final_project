import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CustomNavigationDrawer extends StatefulWidget {
  const CustomNavigationDrawer({super.key});

  @override
  State<CustomNavigationDrawer> createState() => _CustomNavigationDrawerState();
}

class _CustomNavigationDrawerState extends State<CustomNavigationDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: -1,
      onDestinationSelected: (value) {
        debugPrint(value.toString());
      },
      children: [
        NavigationDrawerDestination(
          icon: Icon(Ionicons.person_circle_outline),
          label: Text('Account'),
        ),
        NavigationDrawerDestination(
          icon: Icon(Ionicons.settings_outline),
          label: Text('Settings'),
        ),
      ],
    );
  }
}
