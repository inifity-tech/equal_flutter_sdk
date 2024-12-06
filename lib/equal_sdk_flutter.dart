import 'package:equal_sdk_flutter/equal_web_view.dart';
import 'package:equal_sdk_flutter/model/equal_sdk_params.dart';
import 'package:flutter/material.dart';

abstract class EqualSDK {
  static final EqualSDK _instance = _EqualSDKImplementation();

  static EqualSDK get instance => _instance;

  void launchSDK(BuildContext context, EqualSDKConfig equalSdkConfig,
      Function(String, dynamic) data);
}

class _EqualSDKImplementation implements EqualSDK {
  @override
  void launchSDK(BuildContext context, EqualSDKConfig equalSdkConfig,
      Function(String type, dynamic data) data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EqualSDKLauncher(
          equalSDKConfig: equalSdkConfig,
          onEvent: data,
        ),
      ),
    );
  }
}
