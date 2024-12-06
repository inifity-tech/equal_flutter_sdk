import 'package:equal_sdk_flutter/equal_sdk_flutter.dart';
import 'package:equal_sdk_flutter/model/equal_sdk_params.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Platform messages are asynchronous, so we initialize in an async method.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      home: Navigator(
        pages: [
          MaterialPage(child: HomePage()),
        ],
        onPopPage: (route, result) {
          return route.didPop(result);
        },
      ),
    );
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

  final ValueNotifier<String> _sdkResponse = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    _clientId = TextEditingController(
        text:
            'equal.business.9123265d-0683-49cf-afb0-862a144039b6#8f405d81-ee46-4fd4-9ab9-087848127b5e');
    _idempotencyId =
        TextEditingController(text: '7b138463-489c-4f7b-96ab-103616e30ad4');
    _token = TextEditingController(
        text: 'test.zxGQRQiPmD4GnrqCUATbMACSDtpg9jKyeLST71H150g=');
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
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    EqualSDK.instance.launchSDK(
                        context,
                        EqualSDKConfig(
                          clientId: _clientId.text.trim(),
                          idempotencyId: _idempotencyId.text.trim(),
                          token: _token.text.trim(),
                        ), (type, data) {
                      _sdkResponse.value = "$type - $data";
                    });
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
                      : ''))
            ],
          ),
        ),
      ),
    );
  }
}
