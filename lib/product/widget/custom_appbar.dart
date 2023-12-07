import 'package:bootcamperciyes_final_project/product/constant/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      title: Text(
        LocaleKeys.title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ).tr(),
      actions: [
        // CountryFlag.fromLanguageCode(
        //   context.locale.languageCode,
        //   width: 32,
        //   height: 64,
        // ),
        Builder(
          builder: (context) {
            return Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 10,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Scaffold.maybeOf(context)?.openEndDrawer(),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Tooltip(
                    message: 'Account',
                    child: Icon(
                      Ionicons.person_circle_outline,
                      size: 36,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(width: 10),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70);
}
