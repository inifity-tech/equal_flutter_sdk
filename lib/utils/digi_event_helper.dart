import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../model/digi_event_model.dart';

class DigiEventHelper {
  static DigiEventHelper? _instance = null;

  factory DigiEventHelper() {
    _instance ??= DigiEventHelper._internal();
    return _instance!;
  }

  static DigiEventHelper getInstance() {
    return DigiEventHelper();
  }

  DigiEventHelper._internal();

  /// Handles the DigiLocker response from the authorization flow
  /// [url] - The callback URL containing response parameters
  /// [onDecision] - Callback function to handle the processed response
  void handleDigiResponse(WebUri? url, Function(String) onDecision) {
    if (url == null) {
      handleErrorRes('Invalid URL', onDecision);
      return;
    }

    final Map<String, String> responseParams = url.queryParameters;

    if (responseParams.containsKey('error')) {
      handleErrorRes(responseParams['error'], onDecision);
      return;
    }

    final String state = responseParams['state'] ?? '';

    if (!responseParams.containsKey('code')) {
      handleErrorRes('Authorization code missing', onDecision);
      return;
    }

    final String code = responseParams['code'] ?? '';

    _closeWindow(
        DigiEventModel(
            aadhaarDigiResponse: 'Authorization successful',
            aadhaarDigiStatusKey: DigiLockerStatus.SUCCESS.name,
            digiState: state,
            digiCode: code),
        onDecision);
  }

  void handleErrorRes(String? error, Function(String) onDecision) {
    _closeWindow(
        DigiEventModel(
          aadhaarDigiResponse: 'Authorization failed',
          errorCode: error ?? 'Unknown error',
          aadhaarDigiStatusKey: DigiLockerStatus.FAILED.name,
        ),
        onDecision);
  }

  void _closeWindow(
      DigiEventModel digiEventModel, Function(String) onDecision) {
    onDecision(jsonEncode(digiEventModel.toJson()));
  }
}
