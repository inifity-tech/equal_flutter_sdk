import 'package:equal_sdk_flutter/equal_sdk_flutter.dart';
import 'package:equal_sdk_flutter/model/equal_sdk_params.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.camera.request();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _clientId;
  late TextEditingController _idempotencyId;
  late TextEditingController _token;
  late TextEditingController _mobile;

  final ValueNotifier<dynamic> _sdkResponse = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    _clientId = TextEditingController(
        text:
            'equal.business.9123265d-0683-49cf-afb0-862a144039b6#8f405d81-ee46-4fd4-9ab9-087848127b5e');
    _idempotencyId =
        TextEditingController(text: '1fe323a5-99d8-4853-8b71-5a7aa26aa809');
    _token = TextEditingController(
        text: 'test.Kf9Le0vXqeG9_LKBTttbOe52gKujyz_KO0HKqW5SiLQ=');
    _mobile = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _clientId,
                decoration: const InputDecoration(
                    label: Text("Client ID"), border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _idempotencyId,
                decoration: const InputDecoration(
                    label: Text("Idempotency ID"),
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _token,
                decoration: const InputDecoration(
                    label: Text("token"), border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _mobile,
                decoration: const InputDecoration(
                    label: Text("Mobile Number"), border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    EqualSDK.instance.launchSDK(
                      context: context,
                      equalSdkConfig: EqualSDKConfig(
                        clientId: _clientId.text.trim(),
                        idempotencyId: _idempotencyId.text.trim(),
                        token: _token.text.trim(),
                        mobile: _mobile.text.trim(),
                      ),
                      onSubmit: (data) {
                        _sdkResponse.value = data;
                      },
                      onError: (data) {
                        _sdkResponse.value = data;
                      },
                    );
                  },
                  child: const Text('Launch SDK'),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ValueListenableBuilder(
                valueListenable: _sdkResponse,
                builder: (_, __, ___) => Text(_sdkResponse.value.isNotEmpty
                    ? "SDK Response is ${_sdkResponse.value}"
                    : ''),
              )
            ],
          ),
        ),
      ),
    );
  }
}
