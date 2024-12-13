import 'package:equal_sdk_flutter/equal_web_view.dart';
import 'package:equal_sdk_flutter/model/equal_sdk_params.dart';
import 'package:flutter/material.dart';

abstract class EqualSDK {
  static final EqualSDK _instance = _EqualSDKImplementation();

  static EqualSDK get instance => _instance;

  void launchSDK({
    required BuildContext context,
    required EqualSDKConfig equalSdkConfig,
    required Function(dynamic) onSubmit,
    required Function(dynamic) onError,
  });
}

class _EqualSDKImplementation implements EqualSDK {
  @override
  void launchSDK({
    required BuildContext context,
    required EqualSDKConfig equalSdkConfig,
    required Function(dynamic) onSubmit,
    required Function(dynamic) onError,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EqualSDKLauncher(
          equalSDKConfig: equalSdkConfig,
          onSubmit: onSubmit,
          onError: onError,
        ),
      ),
    );
  }
}
