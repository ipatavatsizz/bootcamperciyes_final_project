import 'package:bootcamperciyes_final_project/product/constant/application_constant.dart';
import 'package:bootcamperciyes_final_project/product/constant/locale_keys.g.dart';
import 'package:bootcamperciyes_final_project/product/cubit/language_cubit.dart';
import 'package:bootcamperciyes_final_project/product/widget/custom_appbar.dart';
import 'package:bootcamperciyes_final_project/product/widget/custom_navigation_bar.dart';
import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:recase/recase.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: CustomNavigationBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              onTap: () {
                showModalBottomSheet(
                  isDismissible: true,
                  showDragHandle: true,
                  context: context,
                  builder: (context) => Scaffold(
                    body: BlocConsumer<LanguageCubit, LanguageCubitState>(
                      listener: (context, state) {
                        context.setLocale(state.language.toLocale());
                      },
                      builder: (context, state) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10),
                            Text(
                              LocaleKeys.select_language.tr().sentenceCase,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            ...Application.supportedLanguages
                                .map(
                                  (e) => ListTile(
                                    title: Text(e.name.sentenceCase),
                                    onTap: () => context
                                        .read<LanguageCubit>()
                                        .changeLanguage(e),
                                  ),
                                )
                                .toList(),
                            Spacer(),
                            Flexible(
                              child: Text(
                                LocaleKeys.change_text.tr().sentenceCase,
                              ),
                            ),
                            SizedBox(height: 50),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.language.tr(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    context
                        .watch<LanguageCubit>()
                        .state
                        .language
                        .name
                        .sentenceCase,
                  ),
                ],
              ),
              trailing: CountryFlag.fromLanguageCode(
                context.watch<LanguageCubit>().state.language.language,
                width: 42,
                height: 21,
              ),
            ),
            Divider(),
            ListTile(
              onTap: () => showLicensePage(
                context: context,
                applicationName: LocaleKeys.title.tr(),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.licenses.tr(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              trailing: Icon(Ionicons.information_circle_outline),
            ),
            Divider(),
            ListTile(),
          ],
        ),
      ),
    );
  }
}
