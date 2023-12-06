import 'dart:async';

import 'package:bootcamperciyes_final_project/product/constant/application_constant.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:googleapis/datastore/v1.dart';
import 'package:googleapis/places/v1.dart';

enum CubitStatus { initial, loading, location, places, success, failure }

@immutable
class PlaceCubitState with EquatableMixin {
  final double? latitude;
  final double? longitude;
  final double radius;
  final GoogleMapsPlacesV1SearchNearbyResponse? data;
  final CubitStatus status;

  final String? error;

  PlaceCubitState({
    this.status = CubitStatus.initial,
    this.latitude,
    this.longitude,
    this.radius = 500,
    this.data,
    this.error,
  });

  PlaceCubitState copyWith({
    CubitStatus? status,
    LatLng? position,
    double? radius,
    double? latitude,
    double? longitude,
    GoogleMapsPlacesV1SearchNearbyResponse? data,
    String? error,
  }) =>
      PlaceCubitState(
        status: status ?? this.status,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        radius: radius ?? this.radius,
        data: data ?? this.data,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [status, latitude, longitude, radius, data, error];
}

class PlacesCubit extends Cubit<PlaceCubitState> {
  PlacesCubit() : super(PlaceCubitState());

  Future<void> getLastLocation() async {
    emit(state.copyWith(status: CubitStatus.location));

    try {
      final position = await Geolocator.getLastKnownPosition();
      if (position == null) return;
      debugPrint('getLastKnownPosition success');
      emit(
        state.copyWith(
          status: CubitStatus.success,
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    } on TimeoutException catch (_) {
      emit(
        state.copyWith(
          error: 'Couldn\'t get location data',
          status: CubitStatus.failure,
        ),
      );
    } on LocationServiceDisabledException catch (_) {
      // emit(
      //   state.copyWith(
      //     error: 'Location service is disabled',
      //     status: CubitStatus.failure,
      //   ),
      // );
      // Future.delayed(
      //   Duration(seconds: 1),
      //   () async => await Geolocator.openLocationSettings(),
      // );
    } on MissingPluginException catch (_) {}
  }

  Future<void> getLocation() async {
    emit(state.copyWith(status: CubitStatus.location));

    try {
      final position = await Geolocator.getCurrentPosition();
      emit(
        state.copyWith(
          status: CubitStatus.success,
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    } on TimeoutException catch (_) {
      emit(
        state.copyWith(
          error: 'Couldn\'t get location data',
          status: CubitStatus.failure,
        ),
      );
    } on LocationServiceDisabledException catch (_) {
      await getLastLocation();
      // emit(
      //   state.copyWith(
      //     error: 'Location service is disabled',
      //     status: CubitStatus.failure,
      //   ),
      // );
      // Future.delayed(
      //   Duration(seconds: 1),
      //   () async => await Geolocator.openLocationSettings(),
      // );
    } on PlatformException catch (e) {
      emit(state.copyWith(error: e.message, status: CubitStatus.failure));
    } on MissingPluginException catch (_) {}
  }

  Future<void> searchNearby() async {
    emit(state.copyWith(status: CubitStatus.places));

    try {
      final data = await Application.placesApi.places.searchNearby(
        GoogleMapsPlacesV1SearchNearbyRequest(
          locationRestriction:
              GoogleMapsPlacesV1SearchNearbyRequestLocationRestriction(
            circle: GoogleMapsPlacesV1Circle(
              radius: 500,
              center: LatLng(latitude: 30, longitude: 30),
            ),
          ),
        ),
        $fields: '*',
      );
      emit(
        state.copyWith(status: CubitStatus.success, data: data),
      );
    } on DetailedApiRequestError catch (e) {
      emit(state.copyWith(status: CubitStatus.failure, error: e.message));
    } on MissingPluginException catch (_) {}
  }
}
