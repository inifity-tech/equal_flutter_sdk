import 'package:flutter/material.dart';

class IWebView extends StatelessWidget {
  final String initialUrl;
  final Function(dynamic) onSubmit;
  final Function(dynamic) onError;

  IWebView(
      {super.key,
      required this.initialUrl,
      required this.onSubmit,
      required this.onError});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
