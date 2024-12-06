import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:equal_sdk_flutter/method_channel/equal_sdk_flutter_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelEqualSdkFlutter platform = MethodChannelEqualSdkFlutter();
  const MethodChannel channel = MethodChannel('equal_sdk_flutter');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
  });
}
