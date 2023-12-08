import 'dart:developer';

import 'package:bootcamperciyes_final_project/product/constant/field_mask_constant.dart';
import 'package:bootcamperciyes_final_project/product/constant/language_constant.dart';
import 'package:bootcamperciyes_final_project/product/constant/locale_keys.g.dart';
import 'package:bootcamperciyes_final_project/product/constant/place_types.dart';
import 'package:bootcamperciyes_final_project/product/core/application.dart';
import 'package:bootcamperciyes_final_project/product/extension/field_mask_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/places/v1.dart';
import 'package:recase/recase.dart';

enum SearchCubitStatus { initial, loading, search, success, failure }

@immutable
class SearchCubitState with EquatableMixin {
  final SearchCubitStatus status;
  final String? error;
  final GoogleMapsPlacesV1SearchTextResponse? places;
  final String search;
  final IncludedType? filter;

  SearchCubitState({
    this.status = SearchCubitStatus.initial,
    this.error,
    this.places,
    this.search = '',
    this.filter,
  });

  SearchCubitState copyWith({
    SearchCubitStatus? status,
    String? error,
    GoogleMapsPlacesV1SearchTextResponse? places,
    String? search,
    IncludedType? filter,
  }) =>
      SearchCubitState(
        status: status ?? this.status,
        error: error ?? this.error,
        places: places ?? this.places,
        search: search ?? this.search,
        filter: filter ?? this.filter,
      );

  @override
  List<Object?> get props => [status, error, places, search, filter];
}

class SearchCubit extends Cubit<SearchCubitState> {
  SearchCubit() : super(SearchCubitState());

  Future<void> search(String text) async =>
      emit(state.copyWith(status: SearchCubitStatus.search, search: text));

  Future<void> searchText(
    String search, {
    IncludedType? includedType,
    Languages? language,
    GoogleMapsPlacesV1SearchTextRequestLocationBias? locationBias,
    GoogleMapsPlacesV1SearchTextRequestLocationRestriction? locationRestriction,
    int? maxResultCount,
    bool? openNow,
    bool? strictTypeFiltering,
    double? minRating,
  }) async {
    emit(state.copyWith(status: SearchCubitStatus.loading));

    if (maxResultCount != null && maxResultCount > 20) maxResultCount = 20;
    if (maxResultCount != null && maxResultCount < 0) maxResultCount = 1;

    if (minRating != null && minRating > 5.0) minRating = 5.0;
    if (minRating != null && minRating < 0.0) minRating = 0.0;

    if (search.isEmpty) {
      return emit(state.copyWith(status: SearchCubitStatus.initial));
    }

    try {
      final data = await Application.placesApi.places.searchText(
        GoogleMapsPlacesV1SearchTextRequest(
          includedType: includedType?.name,
          languageCode: language?.language,
          locationBias: locationBias,
          locationRestriction: locationRestriction,
          maxResultCount: maxResultCount,
          openNow: openNow,
          strictTypeFiltering: strictTypeFiltering,
          textQuery: search,
          minRating: minRating,
        ),
        // TODO: Check how much this costs* (google gave alert about exceeded trial cost value. total 1.66k TL)
        $fields: [
          FieldMask.name,
          FieldMask.id,
          FieldMask.displayName,
          FieldMask.location,
          FieldMask.delivery,
          FieldMask.currentOpeningHours,
          FieldMask.googleMapsUri,
          FieldMask.nationalPhoneNumber,
          FieldMask.photos,
          FieldMask.reviews,
          FieldMask.types,
          FieldMask.websiteUri,
          FieldMask.rating,
        ].parameter,
      );

      inspect(data);

      emit(state.copyWith(status: SearchCubitStatus.success, places: data));
    } catch (_) {
      emit(
        state.copyWith(
          status: SearchCubitStatus.failure,
          error: LocaleKeys.errors_something_went_wrong.tr().sentenceCase,
        ),
      );
    }
  }
}
