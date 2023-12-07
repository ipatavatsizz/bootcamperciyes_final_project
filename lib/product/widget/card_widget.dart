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
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';

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
            // TODO: Route user to home to guide location when tap
            return GestureDetector(
              // onTap: () => context.read<PlacesCubit>(),
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFFFEFE8),
                  borderRadius: BorderRadius.circular(16),
                  // border: Border.all(),
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
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Ionicons.alert_outline,
                                          size: 36,
                                        ),
                                        SizedBox(height: 5),
                                        Text(LocaleKeys.no_connection.tr()),
                                      ],
                                    ),
                                  ),
                                  imageBuilder: (context, image) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      image: DecorationImage(
                                        image: image,
                                        fit: BoxFit.cover,
                                        filterQuality: FilterQuality.high,
                                      ),
                                    ),
                                  ),
                                  progressIndicatorBuilder:
                                      (context, url, progress) => LoadingWidget(
                                    value: progress.progress,
                                    child: Text(LocaleKeys.loading.tr()),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    SizedBox(height: 10),
                    if (data.displayName != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Ionicons.bookmark_outline, size: 28),
                            onPressed: () {},
                          ),
                          Text(
                            data.displayName!.text!,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(Ionicons.share_outline),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    if (state.distance != null) ...[
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocaleKeys.search_terms_distance.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${(state.distance! / 1000).toStringAsFixed(1)} km',
                          ),
                        ],
                      ),
                    ],
                    if (data.rating != null) ...[
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocaleKeys.search_terms_rating.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text('${data.rating}'),
                        ],
                      ),
                    ],
                    if (data.nationalPhoneNumber != null) ...[
                      SizedBox(height: 5),
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
                          TextButton(
                            child: Text(
                              '${data.nationalPhoneNumber}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.blue.shade300),
                            ),
                            onPressed: () async => await canLaunchUrl(
                              Uri.parse(
                                'tel:${data.nationalPhoneNumber?.replaceAll(RegExp(r'\s+|\(+|\)+'), '')}',
                              ),
                            )
                                ? Uri.parse(
                                    'tel:${data.nationalPhoneNumber?.replaceAll(RegExp(r'\s+|\(+|\)+'), '')}',
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ],
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
