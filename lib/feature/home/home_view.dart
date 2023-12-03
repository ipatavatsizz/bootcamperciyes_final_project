import 'package:bootcamperciyes_final_project/product/widget/appbar.dart';
import 'package:bootcamperciyes_final_project/product/widget/google_map_widget.dart';
import 'package:bootcamperciyes_final_project/product/widget/navigationbar.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: ApplicationNavigationBar(),
        appBar: ApplicationAppBar(),
        body: GoogleMapWidget(),
      ),
    );
  }
}
