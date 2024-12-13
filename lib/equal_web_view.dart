import 'package:equal_sdk_flutter/model/equal_sdk_params.dart';
import 'package:equal_sdk_flutter/view/equal_in_app_web_view_helper.dart';
import 'package:flutter/material.dart';

import 'equal_sdk_manager.dart';

class EqualSDKLauncher extends StatelessWidget {
  const EqualSDKLauncher(
      {super.key,
      required this.equalSDKConfig,
      required this.onSubmit,
      required this.onError});

  final EqualSDKConfig equalSDKConfig;
  final Function(dynamic) onSubmit;
  final Function(dynamic) onError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: EqualSDKManager().getGatewayURL(
          equalSDKConfig,
          (v) {
            onError(v.toJson());
            Navigator.pop(context);
          },
        ),
        builder: (_, snapShot) {
          switch (snapShot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              return EqualInAppWebViewWidget(
                initialUrl: snapShot.data ?? '',
                onSubmit: onSubmit,
                onError: onError,
              );
          }
        },
      ),
    );
  }
}
