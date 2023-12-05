import 'package:bootcamperciyes_final_project/product/constant/locale_keys.g.dart';
import 'package:bootcamperciyes_final_project/product/constant/navigation_constant.dart';
import 'package:bootcamperciyes_final_project/product/widget/search_box.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:recase/recase.dart';

class SubAppBar extends StatefulWidget {
  const SubAppBar({super.key});

  @override
  State<SubAppBar> createState() => _SubAppBarState();
}

class _SubAppBarState extends State<SubAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool expandSearch = false;
  final TextEditingController textEditingController = TextEditingController();

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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 8,
            fit: FlexFit.tight,
            child: SearchBox(
              icon: Icon(Ionicons.search_outline, size: 28),
              hintText: LocaleKeys.search.tr().sentenceCase,
              onTap: () => NavigationPages.search.navigate(),
            ),
          ),
          SizedBox(width: 10),
          Flexible(
            flex: 2,
            fit: FlexFit.loose,
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Ionicons.filter_outline,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
