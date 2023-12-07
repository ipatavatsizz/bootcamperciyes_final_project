import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bootcamperciyes_final_project/feature/home/home_state.dart';
import 'package:bootcamperciyes_final_project/feature/home/widget/map_controls.dart';
import 'package:bootcamperciyes_final_project/product/constant/application_constant.dart';
import 'package:bootcamperciyes_final_project/product/constant/locale_keys.g.dart';
import 'package:bootcamperciyes_final_project/product/constant/navigation_constant.dart';
import 'package:bootcamperciyes_final_project/product/cubit/places_cubit.dart';
import 'package:bootcamperciyes_final_project/product/widget/custom_appbar.dart';
import 'package:bootcamperciyes_final_project/product/widget/custom_navigation_bar.dart';
import 'package:bootcamperciyes_final_project/product/widget/custom_navigation_drawer.dart';
import 'package:bootcamperciyes_final_project/product/widget/loading_state.dart';
import 'package:bootcamperciyes_final_project/product/widget/reload_button.dart';
import 'package:bootcamperciyes_final_project/product/widget/sub_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:recase/recase.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends HomeState {
  @override
  Widget build(BuildContext context) {
    context.read<PlacesCubit>().getLocation();
    return Scaffold(
      endDrawer: CustomNavigationDrawer(),
      appBar: CustomAppBar(),
      resizeToAvoidBottomInset: false,
      extendBody: true,
      bottomNavigationBar: CustomNavigationBar(),
      body: Center(
        child: BlocConsumer<PlacesCubit, PlaceCubitState>(
          listener: (context, state) async {
            if (state.error != null || state.status == CubitStatus.failure) {
              Application.messenger.currentState?.showSnackBar(
                SnackBar(
                  content:
                      Text(state.error ?? LocaleKeys.errors_unexpected).tr(),
                ),
              );
            }
          },
          builder: (context, state) {
            Future.delayed(
              Duration(seconds: 2),
              () => Application.messenger.currentState!.showSnackBar(
                SnackBar(
                  content: Text(
                    state.error?.titleCase ??
                        LocaleKeys.errors_unexpected.tr().sentenceCase,
                  ),
                ),
              ),
            );
            switch (state.status) {
              case CubitStatus.location:
                return LoadingWidget(
                  child:
                      Text(LocaleKeys.getting_location_data.tr().sentenceCase),
                );
              case CubitStatus.success:
                return Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: [
                    maps.GoogleMap(
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      mapToolbarEnabled: false,
                      zoomControlsEnabled: false,
                      initialCameraPosition: maps.CameraPosition(
                        target: maps.LatLng(state.latitude!, state.longitude!),
                        zoom: 10,
                      ),
                      onMapCreated: (controller) async =>
                          onMapCreated(controller, state),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: MapControls(
                        mapController,
                        maps.LatLng(state.latitude!, state.longitude!),
                      ),
                    ),
                    Align(alignment: Alignment.topCenter, child: SubAppBar()),
                  ],
                );
              case CubitStatus.failure:
                return ReloadButton(NavigationPages.home);
              default:
                return LoadingWidget(
                  child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      TyperAnimatedText(
                        LocaleKeys.loading.tr(),
                        speed: Duration(milliseconds: 80),
                      ),
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
