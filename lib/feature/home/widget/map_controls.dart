import 'dart:async';

import 'package:bootcamperciyes_final_project/product/constant/application_constant.dart';
import 'package:bootcamperciyes_final_project/product/constant/locale_keys.g.dart';
import 'package:bootcamperciyes_final_project/product/widget/custom_snackbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';

class MapControls extends StatefulWidget {
  MapControls(this.controller, this.position, {super.key});

  final Completer<GoogleMapController> controller;
  final LatLng position;

  @override
  State<MapControls> createState() => _MapControlsState();
}

class _MapControlsState extends State<MapControls> {
  Future<void> zoomIn() async {
    try {
      debugPrint('zoomIn!');
      final controller = await widget.controller.future;
      await controller.animateCamera(
        CameraUpdate.zoomIn(),
      );
    } on MissingPluginException catch (_) {
      // TODO: add retry button
    } catch (e) {
      debugPrint('HATA $e');
      Application.messenger.currentState?.showSnackBar(
        CustomSnackbar(
          content: Text(
            LocaleKeys.errors_something_went_wrong,
          ).tr(),
        ),
      );
    }
  }

  Future<void> zoomOut() async {
    try {
      final controller = await widget.controller.future;
      await controller.animateCamera(
        CameraUpdate.zoomOut(),
      );
    } catch (_) {
      Application.messenger.currentState?.showSnackBar(
        CustomSnackbar(
          content: Text(
            LocaleKeys.errors_something_went_wrong,
          ).tr(),
        ),
      );
    }
  }

  Future<void> locate(LatLng position) async {
    try {
      final controller = await widget.controller.future;
      await controller.animateCamera(
        CameraUpdate.newLatLng(position),
      );
    } catch (_) {
      Application.messenger.currentState?.showSnackBar(
        CustomSnackbar(
          content: Text(
            LocaleKeys.errors_something_went_wrong,
          ).tr(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(
        bottom: 80,
        right: 10,
        left: 10,
        top: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Zoom In',
            icon: Icon(Ionicons.add_outline),
            iconSize: 24,
            onPressed: zoomIn,
          ),
          IconButton(
            tooltip: 'Zoom Out',
            icon: Icon(Ionicons.remove_outline),
            iconSize: 24,
            onPressed: zoomOut,
          ),
          IconButton(
            tooltip: 'Locate',
            icon: Icon(Ionicons.locate_outline),
            iconSize: 24,
            onPressed: () => locate(widget.position),
          ),
        ],
      ),
    );
  }
}
