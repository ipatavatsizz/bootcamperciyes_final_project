import 'package:bootcamperciyes_final_project/product/constant/application_constant.dart';
import 'package:bootcamperciyes_final_project/product/constant/locale_keys.g.dart';
import 'package:bootcamperciyes_final_project/product/cubit/auth_cubit.dart';
import 'package:bootcamperciyes_final_project/product/widget/loading_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

class CustomNavigationDrawer extends StatefulWidget {
  const CustomNavigationDrawer({super.key});

  @override
  State<CustomNavigationDrawer> createState() => _CustomNavigationDrawerState();
}

class _CustomNavigationDrawerState extends State<CustomNavigationDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      children: [
        BlocConsumer<AuthCubit, AuthCubitState>(
          listener: (context, state) {
            if (state.error != null ||
                state.status == AuthCubitStatus.failure) {
              Application.messenger.currentState?.showSnackBar(
                SnackBar(
                  content:
                      Text(state.error ?? LocaleKeys.errors_unexpected.tr()),
                ),
              );
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case AuthCubitStatus.success:
                final credential = state.user;
                final user = credential?.user;
                if (credential == null || user == null) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 36),
                        ),
                        onPressed: () => context.read<AuthCubit>().signIn(),
                        icon: Icon(Ionicons.log_in_outline),
                        label: Text(LocaleKeys.sign_in.tr()),
                      ),
                    ],
                  );
                }
                return LayoutBuilder(
                  builder: (context, constraints) => Container(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: MediaQuery.maybeSizeOf(context)?.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (user.photoURL != null) ...[
                                CachedNetworkImage(
                                  imageUrl: user.photoURL!,
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    width: constraints.maxWidth * .4,
                                    height: constraints.maxWidth * .4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
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
                                        Flexible(
                                          child: Text(
                                            LocaleKeys.no_connection.tr(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  imageBuilder: (context, image) => Container(
                                    width: constraints.maxWidth * .4,
                                    height: constraints.maxWidth * .4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: image,
                                        filterQuality: FilterQuality.high,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                              ],
                              Column(
                                children: [
                                  Text(LocaleKeys.logged_as.tr()),
                                  Text(
                                    user.displayName ?? LocaleKeys.unknown.tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Divider(),
                          SizedBox(height: 5),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 36),
                            ),
                            onPressed: () =>
                                context.read<AuthCubit>().signOut(),
                            icon: Icon(Ionicons.log_out_outline),
                            label: Text(LocaleKeys.sign_out.tr()),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              default:
                return LoadingWidget(child: Text(LocaleKeys.loading.tr()));
            }
          },
        ),
      ],
    );
  }
}
