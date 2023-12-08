import 'dart:async';

import 'package:bootcamperciyes_final_project/feature/home/home_view.dart';
import 'package:bootcamperciyes_final_project/product/constant/locale_keys.g.dart';
import 'package:bootcamperciyes_final_project/product/core/application.dart';
import 'package:bootcamperciyes_final_project/product/cubit/places_cubit.dart';
import 'package:bootcamperciyes_final_project/product/widget/custom_snackbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;

abstract class HomeState extends State<HomeView> {
  Completer<maps.GoogleMapController> mapController = Completer();

  @override
  void dispose() {
    mapController = Completer();
    super.dispose();
  }

  Future<void> onMapCreated(
    maps.GoogleMapController controller,
    PlaceCubitState state,
  ) async {
    if (!mapController.isCompleted) mapController.complete(controller);
    try {
      await controller.animateCamera(
        maps.CameraUpdate.newLatLngZoom(
          maps.LatLng(
            state.latitude!,
            state.longitude!,
          ),
          15,
        ),
      );
    } catch (_) {
      debugPrint('HATA');
      Application.messenger.currentState?.showSnackBar(
        CustomSnackbar(
          content: Text(
            LocaleKeys.errors_something_went_wrong,
          ).tr(),
        ),
      );
    }
  }
}
