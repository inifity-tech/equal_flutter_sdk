import 'dart:convert';

import 'package:equal_sdk_flutter/model/equal_sdk_params.dart';
import 'package:http/http.dart' as http;

class EqualSDKManager {
  static const String PROD_VERIFY_URL =
      'https://sdk-api.equal.in/business/ie/transaction/verify';
  static const String TEST_VERIFY_URL =
      'https://sdk-api.test.equal.in/business/ie/transaction/verify';
  static const String PROD_APP_URL = 'https://equal.in';
  static const String TEST_APP_URL = 'https://test.equal.in';

  final EqualSDKConfig equalSDKConfig;

  EqualSDKManager({required this.equalSDKConfig});

  String get verifyUrl => equalSDKConfig.token.startsWith('test')
      ? TEST_VERIFY_URL
      : PROD_VERIFY_URL;

  String get equalDomain =>
      equalSDKConfig.token.startsWith('test') ? TEST_APP_URL : PROD_APP_URL;

  Future<String?> getGatewayURL(Function(dynamic) onError) async {
    print('equal config $equalSDKConfig');
    try {
      final response = await http.post(
        Uri.parse(verifyUrl),
        headers: {
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

      print("response iframe url $data");

      if (data['status'] == 'SUCCESS') {
        String code = data['code'];
        String transactionId = data['transaction_id'];
        String identifier = '';

        if (data.containsKey('allowed_consumers') &&
            data['allowed_consumers'].isNotEmpty &&
            data['allowed_consumers'][0]['identifier'] != null) {
          identifier = data['allowed_consumers'][0]['identifier'];
        }

        String finalMobile = equalSDKConfig.mobile ?? identifier;
        String iframeUrl =
            '$equalDomain/app/gateway?transaction_id=$transactionId'
            '&code=$code&source=flutterSdk&sdk_launch=true'
            '&isMobileLaunch=true&embedded=true';

        if (finalMobile.isNotEmpty) {
          iframeUrl += '&mb=${base64.encode(utf8.encode(finalMobile))}';
        }
        print('iframe url $iframeUrl');
        return iframeUrl;
      } else {
        final errorMessage = data['message'] ??
            'Unable to load the gateway due to a technical error. Please try again.';
        onError({'status': 'ERROR', 'message': errorMessage});
      }
    } catch (e) {
      print("catch error ${e}");
      const errorMessage =
          'Unable to load the gateway due to a technical error. Please try again.';
      onError({'status': 'ERROR', 'message': errorMessage});
    }
    return null;
  }
}
