import 'package:equal_sdk_flutter/model/equal_sdk_params.dart';
import 'package:equal_sdk_flutter/view/equal_in_app_web_view_helper.dart';
import 'package:flutter/material.dart';

import 'equal_sdk_manager.dart';

class EqualSDKLauncher extends StatelessWidget {
  const EqualSDKLauncher(
      {super.key, required this.equalSDKConfig, required this.onEvent});

  final EqualSDKConfig equalSDKConfig;
  final Function(String, dynamic) onEvent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future:
            EqualSDKManager(equalSDKConfig: equalSDKConfig).getGatewayURL((v) {
          // onEvent(v['status'], v['message']);
        }),
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
                onCallback: (eventType, data) {
                  print("event type $eventType  >> $data");
                  onEvent(eventType, data);
                },
              );
          }
        },
      ),
    );
  }
}
