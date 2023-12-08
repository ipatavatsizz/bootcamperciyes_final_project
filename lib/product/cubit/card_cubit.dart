import 'package:bootcamperciyes_final_project/product/core/application.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:googleapis/places/v1.dart';

enum CardCubitStatus { initial, loading, success, failure }

class CardCubitState with EquatableMixin {
  final CardCubitStatus status;

  final GoogleMapsPlacesV1Place? data;
  final List<GoogleMapsPlacesV1PhotoMedia>? photos;
  final double? distance;

  final String? error;

  CardCubitState({
    this.status = CardCubitStatus.initial,
    this.data,
    this.photos,
    this.distance,
    this.error,
  });

  CardCubitState copyWith({
    CardCubitStatus? status,
    GoogleMapsPlacesV1Place? data,
    List<GoogleMapsPlacesV1PhotoMedia>? photos,
    double? distance,
    String? error,
  }) =>
      CardCubitState(
        status: status ?? this.status,
        data: data ?? this.data,
        photos: photos ?? this.photos,
        distance: distance ?? this.distance,
        error: error ?? error,
      );

  @override
  List<Object?> get props => [status, data, photos, distance, error];
}

class CardCubit extends Cubit<CardCubitState> {
  CardCubit() : super(CardCubitState());

  Future<void> getCardData(GoogleMapsPlacesV1Place data) async {
    emit(state.copyWith(status: CardCubitStatus.loading, data: data));
  }

  Future<void> getDistanceData(double latitude, double longitude) async {
    emit(state.copyWith(status: CardCubitStatus.loading));

    try {
      final distance = Geolocator.distanceBetween(
        latitude,
        longitude,
        state.data!.location!.latitude!,
        state.data!.location!.longitude!,
      );
      debugPrint('distance value is $distance');
      emit(state.copyWith(status: CardCubitStatus.success, distance: distance));
    } catch (_) {
      emit(state.copyWith(status: CardCubitStatus.failure));
    }
  }

  Future<void> getPhotoData() async {
    if (state.data!.photos == null) return;
    emit(state.copyWith(status: CardCubitStatus.loading));
    try {
      final List<GoogleMapsPlacesV1PhotoMedia> photos = [];
      for (final data in state.data!.photos!) {
        int? maxHeightPx, maxWidthPx;
        if (data.heightPx != null) {
          maxHeightPx = data.heightPx! >= 4800 ? 4800 : data.heightPx;
        }
        if (data.widthPx != null) {
          maxWidthPx = data.widthPx! >= 4800 ? 4800 : data.widthPx;
        }

        final photo = await Application.placesApi.places.photos.getMedia(
          '${data.name}/media',
          maxHeightPx: maxHeightPx,
          maxWidthPx: maxWidthPx,
          skipHttpRedirect: true,
          $fields: '*',
        );
        photos.add(photo);
      }

      emit(state.copyWith(status: CardCubitStatus.success, photos: photos));
    } catch (_) {
      emit(state.copyWith(status: CardCubitStatus.failure));
    }
  }
}
