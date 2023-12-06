import 'package:bootcamperciyes_final_project/product/constant/locale_keys.g.dart';
import 'package:bootcamperciyes_final_project/product/cubit/search_cubit.dart';
import 'package:bootcamperciyes_final_project/product/widget/card_widget.dart';
import 'package:bootcamperciyes_final_project/product/widget/custom_appbar.dart';
import 'package:bootcamperciyes_final_project/product/widget/custom_navigation_bar.dart';
import 'package:bootcamperciyes_final_project/product/widget/loading_state.dart';
import 'package:bootcamperciyes_final_project/product/widget/search_box.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:recase/recase.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      extendBody: true,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: CustomNavigationBar(),
      body: Padding(
        padding: EdgeInsets.only(bottom: 80),
        child: LayoutBuilder(
          builder: (context, constraints) {
            debugPrint(constraints.maxHeight.toString());
            debugPrint(constraints.maxWidth.toString());
            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SearchBox(
                        controller: controller,
                        autofocus: true,
                        onTapOutside: (event) async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          await SystemChrome.restoreSystemUIOverlays();
                        },
                        onEditingComplete: () =>
                            context.read<SearchCubit>().search(controller.text),
                        icon: Icon(Ionicons.search_outline, size: 28),
                        hintText: LocaleKeys.search.tr().sentenceCase,
                      ),
                      SizedBox(height: 10),
                      Flexible(
                        child: BlocConsumer<SearchCubit, SearchCubitState>(
                          listener: (context, state) {
                            if (state.status == SearchCubitStatus.search) {
                              context
                                  .read<SearchCubit>()
                                  .searchText(state.search);
                            }
                          },
                          builder: (context, state) {
                            switch (state.status) {
                              case SearchCubitStatus.success:
                                final data = state.places!.places;
                                if (data == null) return Text('No result');
                                return SizedBox(
                                  height: constraints.maxHeight,
                                  child: PageView(
                                    allowImplicitScrolling: true,
                                    scrollBehavior: MaterialScrollBehavior()
                                        .copyWith(overscroll: false),
                                    children: data
                                        .map((data) => CardWidget(data))
                                        .toList(),
                                  ),
                                );
                              case SearchCubitStatus.initial:
                                return SizedBox.shrink();
                              default:
                                return Center(
                                  child: LoadingWidget(
                                    child: Text(LocaleKeys.loading.tr()),
                                  ),
                                );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
