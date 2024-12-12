import 'dart:convert';

import 'package:equal_sdk_flutter/model/equal_sdk_params.dart';
import 'package:equal_sdk_flutter/model/event_response.dart';
import 'package:http/http.dart' as http;

class EqualSDKManager {
  static const String PROD_VERIFY_URL =
      'https://sdk-api.equal.in/business/ie/transaction/verify';
  static const String TEST_VERIFY_URL =
      'https://sdk-api.test.equal.in/business/ie/transaction/verify';
  static const String PROD_APP_URL = 'https://equal.in';
  static const String TEST_APP_URL = 'https://test.equal.in';

  static String? _transactionId;
  static String? get transactionId => _transactionId;

  String _getVerifyUrl(EqualSDKConfig equalSDKConfig) =>
      equalSDKConfig.token.startsWith('test')
          ? TEST_VERIFY_URL
          : PROD_VERIFY_URL;

  String _getEqualDomain(EqualSDKConfig equalSDKConfig) =>
      equalSDKConfig.token.startsWith('test') ? TEST_APP_URL : PROD_APP_URL;

  Future<String?> getGatewayURL(
      EqualSDKConfig equalSDKConfig, Function(EventResponse) onError) async {
    try {
      final response = await http.post(
        Uri.parse(_getVerifyUrl(equalSDKConfig)),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'client_id': equalSDKConfig.clientId,
          'token': equalSDKConfig.token,
          'idempotency_id': equalSDKConfig.idempotencyId,
        }),
      );

      final data = jsonDecode(response.body);
      if (data['status'] != 'SUCCESS') {
        final errorMessage = data['message'] ??
            'Unable to load the gateway due to a technical error. Please try again.';
        onError(EventResponse(status: 'ON_ERROR', message: errorMessage));
        return null;
      }

      final String code = data['code'];
      _transactionId = data['transaction_id'];

      final String identifier = data['allowed_consumers']?.isNotEmpty == true
          ? data['allowed_consumers'][0]['identifier'] ?? ''
          : '';

      final String finalMobile = equalSDKConfig.mobile ?? identifier;
      final String equalDomain = _getEqualDomain(equalSDKConfig);

      final Map<String, String> queryParams = {
        'transaction_id': _transactionId??'',
        'code': code,
        'source': 'flutterSdk',
        'sdk_launch': 'true',
        'isMobileLaunch': 'true',
        'embedded': 'true',
      };

      if (finalMobile.isNotEmpty) {
        queryParams['mb'] = base64.encode(utf8.encode(finalMobile));
      }

      final Uri iframeUri = Uri.parse(equalDomain + '/app/gateway')
          .replace(queryParameters: queryParams);

      return iframeUri.toString();
    } catch (e) {
      const errorMessage =
          'Unable to load the gateway due to a technical error. Please try again.';
      onError(EventResponse(status: 'ON_ERROR', message: errorMessage));
      return null;
    }
  }
}
