import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bootcamperciyes_final_project/product/constants/application_constant.dart';
import 'package:bootcamperciyes_final_project/product/cubit/places/places_cubit.dart';
import 'package:bootcamperciyes_final_project/product/widget/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;

class GoogleMapWidget extends StatelessWidget {
  final Completer<maps.GoogleMapController> _controller = Completer();

  GoogleMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlacesCubit, PlacesStates>(
      listener: (context, state) async {
        if (state.error != null || state.status == CubitStatus.failure) {
          Application.messenger.currentState?.showSnackBar(
            SnackBar(
              content: Text(state.error ?? 'Unexpected error occured.'),
            ),
          );
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case CubitStatus.location:
            return LoadingWidget(child: Text('Getting location data'));
          case CubitStatus.success:
            return maps.GoogleMap(
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              initialCameraPosition: maps.CameraPosition(
                target: maps.LatLng(state.latitude!, state.longitude!),
              ),
              onMapCreated: (controller) {
                _controller.complete(controller);
                controller.animateCamera(
                  maps.CameraUpdate.newLatLngZoom(
                    maps.LatLng(state.latitude!, state.longitude!),
                    8,
                  ),
                );
              },
            );
          case CubitStatus.failure:
            return Text('Something went wrong');
          default:
            return LoadingWidget(
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText('Loading...'),
                ],
              ),
            );
        }
      },
    );
  }
}
