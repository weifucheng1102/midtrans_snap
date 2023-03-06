library midtrans_snap;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:midtrans_snap/constants.dart';
import 'package:midtrans_snap/models.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class MidtransSnap extends StatelessWidget {
  MidtransSnap({
    super.key,
    required this.mode,
    required this.token,
    required this.midtransClientKey,
    this.onPageStarted,
    this.onPageFinished,
    this.onResponse,
  });

  final MidtransEnvironment mode;
  final String token, midtransClientKey;
  final void Function(String url)? onPageStarted, onPageFinished;
  final void Function(MidtransResponse result)? onResponse;

  static PlatformWebViewControllerCreationParams _getCreationParams() {
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      return WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    }

    return const PlatformWebViewControllerCreationParams();
  }

  final _controller =
      WebViewController.fromPlatformCreationParams(_getCreationParams())
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000));

  @override
  Widget build(BuildContext context) {
    final isProduction = mode == MidtransEnvironment.production;

    return WebViewWidget(
      controller: _controller
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {
              onPageStarted?.call(url);
            },
            onPageFinished: (String url) {
              onPageFinished?.call(url);
            },
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
          ),
        )
        ..addJavaScriptChannel(
          'Print',
          onMessageReceived: (JavaScriptMessage receiver) {
            if (![null, 'undefined'].contains(receiver.message)) {
              final resultMap = jsonDecode(receiver.message);
              final result = MidtransResponse.fromJson(resultMap as Map);

              onResponse?.call(result);
            }
          },
        )
        ..loadRequest(
          Uri.dataFromString(
            '''<html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script 
          type="text/javascript"
          src="${isProduction ? production : sandbox}"
          data-client-key="$midtransClientKey"
        ></script>
      </head>
      <body onload="setTimeout(function(){pay()}, 1000)">
        <script type="text/javascript">
            function pay() {
                snap.pay('$token', {
                  // Optional
                  onSuccess: function(result) {
                    Print.postMessage(JSON.stringify(result));
                  },
                  // Optional
                  onPending: function(result) {
                    Print.postMessage(JSON.stringify(result));
                  },
                  // Optional
                  onError: function(result) {
                    Print.postMessage(JSON.stringify(result));
                  },
                  onClose: function() {
                    Print.postMessage('{"transaction_status":"close"}');
                  }
                });
            }
        </script>
      </body>
    </html>''',
            mimeType: 'text/html',
            encoding: Encoding.getByName('utf-8'),
          ),
        ),
    );
  }
}
