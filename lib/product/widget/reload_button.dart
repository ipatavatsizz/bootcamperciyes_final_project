import 'package:bootcamperciyes_final_project/product/constant/navigation_constant.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ReloadButton extends StatelessWidget {
  const ReloadButton(this.page, {super.key});

  final NavigationPages page;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => page.navigate(),
      icon: Icon(Ionicons.reload_outline, size: 28),
      label: Text('Reload page'),
    );
  }
}
