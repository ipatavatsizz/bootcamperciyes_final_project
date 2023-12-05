import 'package:bootcamperciyes_final_project/product/constant/navigation_constant.dart';
import 'package:flutter/widgets.dart';

extension BuildContextExtensions on BuildContext {
  void navigate(NavigationPages page) => page.navigate();
}
