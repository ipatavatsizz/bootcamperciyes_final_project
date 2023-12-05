import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  SearchBox({
    super.key,
    this.controller,
    this.icon,
    this.hintText,
    this.elevation = 10,
    this.border,
    this.borderRadius,
    this.decoration,
    this.autofocus = false,
    this.enabled,
    this.shape,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.onTap,
    this.onTapOutside,
  });

  final TextEditingController? controller;
  final Widget? icon;
  final String? hintText;
  final double elevation;
  final InputBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final InputDecoration? decoration;
  final bool autofocus;
  final bool? enabled;
  final ShapeBorder? shape;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final Function(String?)? onSaved;

  bool showPredictions = false;

  @override
  Widget build(BuildContext context) {
    final defaultController = controller ?? TextEditingController();

    final InputBorder defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );

    final BorderRadiusGeometry defaultBorderRadius = BorderRadius.circular(12);

    final InputDecoration defaultDecoration = InputDecoration(
      prefixIcon: icon,
      contentPadding: EdgeInsets.all(10),
      hintText: hintText,
      border: border ?? defaultBorder,
    );

    final ShapeBorder defaultShape = RoundedRectangleBorder(
      borderRadius: borderRadius ?? defaultBorderRadius,
    );

    return Material(
      elevation: elevation,
      shape: shape ?? defaultShape,
      child: TextField(
        enabled: enabled,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        onTap: onTap,
        onTapOutside: onTapOutside,
        autofocus: autofocus,
        controller: defaultController,
        decoration: decoration ?? defaultDecoration,
      ),
    );
  }
}
