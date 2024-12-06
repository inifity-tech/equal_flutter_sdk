import 'package:flutter/material.dart';

class IWebView extends StatelessWidget {
  final String initialUrl;
  final Function(dynamic eventType, dynamic data) onCallback;

  IWebView({super.key, required this.initialUrl, required this.onCallback});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
