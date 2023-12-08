import 'package:bootcamperciyes_final_project/product/core/application.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Testing!'),
          ElevatedButton.icon(
            onPressed: () async {
              Application.messenger.currentState?.showSnackBar(
                SnackBar(
                  content: Column(
                    children: [Text('Test message!')],
                  ),
                ),
              );
            },
            icon: Icon(Ionicons.construct_outline),
            label: Text('Try me!'),
          ),
        ],
      ),
    );
  }
}
