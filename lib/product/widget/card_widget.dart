import 'package:bootcamperciyes_final_project/product/constant/application_constant.dart';
import 'package:bootcamperciyes_final_project/product/constant/locale_keys.g.dart';
import 'package:bootcamperciyes_final_project/product/cubit/card_cubit.dart';
import 'package:bootcamperciyes_final_project/product/cubit/places_cubit.dart';
import 'package:bootcamperciyes_final_project/product/widget/loading_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/places/v1.dart';

class CardWidget extends StatelessWidget {
  const CardWidget(this.data, {super.key});

  final GoogleMapsPlacesV1Place data;

  @override
  Widget build(BuildContext context) {
    context.read<CardCubit>().getCardData(data);
    final latitude = context.read<PlacesCubit>().state.latitude!;
    final longitude = context.read<PlacesCubit>().state.longitude!;
    context.read<CardCubit>().getDistanceData(latitude, longitude);
    context.read<CardCubit>().getPhotoData();

    return BlocConsumer<CardCubit, CardCubitState>(
      listener: (context, state) {
        if (state.status == CardCubitStatus.failure) {
          Application.messenger.currentState?.showSnackBar(
            SnackBar(
              content: Text(state.error ?? LocaleKeys.errors_unexpected).tr(),
            ),
          );
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case CardCubitStatus.success:
            final data = state.data!;
            debugPrint('${state.distance ?? 'NULL'}');
            // TODO: Route user to home to guide location when tap
            return GestureDetector(
              // onTap: () => context.read<PlacesCubit>(),
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.photos != null)
                      Flexible(
                        flex: 3,
                        child: PageView(
                          children: state.photos!
                              .map(
                                (data) => CachedNetworkImage(
                                  imageUrl: data.photoUri!,
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                  errorWidget: (context, url, error) =>
                                      Text(LocaleKeys.no_connection.tr()),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    SizedBox(height: 10),
                    if (data.displayName != null)
                      Center(
                        child: Text(
                          data.displayName!.text!,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    SizedBox(height: 5),
                    if (state.distance != null)
                      Text(state.distance!.toStringAsFixed(1)),
                    SizedBox(height: 5),
                    if (data.rating != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rating',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text('${data.rating}'),
                        ],
                      ),
                    SizedBox(height: 5),
                    if (data.nationalPhoneNumber != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocaleKeys.search_terms_nationalPhoneNumber.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text('${data.nationalPhoneNumber}'),
                        ],
                      ),
                  ],
                ),
              ),
            );
          default:
            return LoadingWidget(child: Text(LocaleKeys.loading.tr()));
        }
      },
    );
  }
}
