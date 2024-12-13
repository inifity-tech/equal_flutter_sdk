import 'package:equal_sdk_flutter/equal_sdk_manager.dart';
import 'package:equal_sdk_flutter/helper/web_view_settings_helper.dart';
import 'package:equal_sdk_flutter/model/event_response.dart';
import 'package:equal_sdk_flutter/utils/digi_event_helper.dart';
import 'package:equal_sdk_flutter/view/i_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class EqualInAppWebViewWidget extends IWebView {
  final ValueNotifier<InAppWebViewController?> _webViewController =
      ValueNotifier(null);
  final ValueNotifier<bool> _isPopupVisible = ValueNotifier(false);
  final ValueNotifier<String?> _digiUrl = ValueNotifier(null);

  EqualInAppWebViewWidget({
    required super.initialUrl,
    required super.onSubmit,
    required super.onError,
  });

  // SDK Event Handling
  void _handleSdkEvents(String url, BuildContext context) {
    try {
      if (url.contains('URL_SDK_EVENT')) {
        if (url.contains('ON_CLOSE')) {
          onError.call(
            EventResponse(status: 'CLOSED_SDK', transactionId: '').toJson(),
          );
        } else if (url.contains('ON_SUBMIT')) {
          onSubmit.call(EventResponse(
                  status: 'SUCCESS_SUBMIT',
                  transactionId: EqualSDKManager.transactionId)
              .toJson());
        }
      }
    } catch (e) {
      onError.call(
        EventResponse(status: 'ON_ERROR', transactionId: '').toJson(),
      );
    } finally {
      Navigator.pop(context);
    }
  }

  // Exit Confirmation Dialog
  Future<void> _showExitDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              onError.call(
                EventResponse(
                  status: 'CLOSED_SDK',
                ).toJson(),
              );
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void postWebMessage(dynamic eventData) {
    try {
      _webViewController.value?.postWebMessage(
        message: WebMessage(data: eventData),
      );
      _isPopupVisible.value = false;
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _showExitDialog(context);
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(initialUrl)),
                initialSettings: getWebViewOptions(),
                onWebViewCreated: (controller) {
                  _webViewController.value = controller;
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  final url = navigationAction.request.url.toString();

                  if (url.startsWith('tel:')) {
                    // TODO: Implement tel link handling logic
                    return NavigationActionPolicy.CANCEL;
                  }

                  if (url.contains('whatsapp')) {
                    launchUrl(Uri.parse(url));
                    return NavigationActionPolicy.CANCEL;
                  }

                  if (url.contains("digitallocker.gov")) {
                    _digiUrl.value = url;
                    _isPopupVisible.value = true;
                    return NavigationActionPolicy.CANCEL;
                  }

                  if (url.contains('URL_SDK_EVENT')) {
                    _handleSdkEvents(url, context);
                    return NavigationActionPolicy.CANCEL;
                  }

                  return NavigationActionPolicy.ALLOW;
                },
              ),
              ValueListenableBuilder(
                valueListenable: _isPopupVisible,
                builder: (context, isVisible, _) {
                  if (!isVisible || _digiUrl.value == null) {
                    return const SizedBox.shrink();
                  }

                  return Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: InAppWebView(
                        initialUrlRequest: URLRequest(
                          url: WebUri(_digiUrl.value!),
                        ),
                        initialSettings: getWebViewOptions(),
                        shouldOverrideUrlLoading:
                            (controller, navigationAction) async {
                          final url = navigationAction.request.url.toString();
                          if (url.contains("gateway/return_url")) {
                            DigiEventHelper.getInstance().handleDigiResponse(
                              navigationAction.request.url,
                              postWebMessage,
                            );
                          }
                          return NavigationActionPolicy.ALLOW;
                        },
                        onCloseWindow: (controller) {
                          _isPopupVisible.value = false;
                        },
                      ),
                    ),
                  );
                },
              ),
              // ValueListenableBuilder(
              //   valueListenable: _isPopupVisible,
              //   builder: (context, isVisible, _) {
              //     if (!isVisible) {
              //       return const SizedBox.shrink();
              //     }
              //
              //     return Positioned(
              //       top: 8,
              //       right: 8,
              //       child: ElevatedButton(
              //         onPressed: () {
              //           DigiEventHelper.getInstance().handleErrorRes(
              //             "Closed window",
              //             postWebMessage,
              //           );
              //         },
              //         child: const Text(
              //           'X',
              //           style: TextStyle(color: Colors.amber),
              //         ),
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
