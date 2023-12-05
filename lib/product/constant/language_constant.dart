import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum Languages {
  turkish('tr', 'TR'),
  english('en', 'US');

  final String language;
  final String? country;

  const Languages(this.language, this.country);

  Locale toLocale() => Locale(language, country);
  void setLanguage(BuildContext context) => context.setLocale(toLocale());
}

extension IterableLanguageExtension on Iterable<Languages> {
  List<Locale> toLocale() => map((e) => e.toLocale()).toList();
}
