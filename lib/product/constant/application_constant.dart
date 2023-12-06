import 'package:bootcamperciyes_final_project/product/constant/language_constant.dart';
import 'package:bootcamperciyes_final_project/product/constant/navigation_constant.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/places/v1.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

class Application {
  /// Navigation Key
  static final GlobalKey<NavigatorState> navigation =
      GlobalKey<NavigatorState>();

  static final GlobalKey<ScaffoldMessengerState> messenger =
      GlobalKey<ScaffoldMessengerState>();

  static final client = clientViaApiKey(Application.googleApiKey);

  static final PlacesApi placesApi = PlacesApi(client);

  /// Google Map API Key
  static const String googleApiKey = 'AIzaSyArdqYwAhsO_uFMPra9wVG5y-JShCAdaAo';

  /// Default Application Language
  static const Languages language = Languages.turkish;

  /// Supported Languages
  static const List<Languages> supportedLanguages = Languages.values;

  /// Path variables
  static final ApplicationPath path = ApplicationPath();

  static int navigationIndex = 0;

  /// NavigationBar pages
  static final List<NavigationPages> navigationPages =
      NavigationPages.values.filtered;
}

class ApplicationPath {
  final String translations = 'assets/languages';
}
