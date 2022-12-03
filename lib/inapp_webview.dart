import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CustomWebview extends StatefulWidget {
  const CustomWebview({super.key});

  @override
  State<CustomWebview> createState() => _CustomWebviewState();
}

class _CustomWebviewState extends State<CustomWebview>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String webViewMsg = '';

  final GlobalKey webViewChild = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return NotificationListener<MyNotification>(
      key: webViewChild,
      onNotification: (e) {
        debugPrint('webview message: ${e.mensagem}');
        webViewMsg = e.mensagem;
        setState(() {});
        return false;
      },
      child: Column(
        children: [
          Text('Update by webview: $webViewMsg'),
          Expanded(
              child: WebViewChild(
            key: widget.key,
          )),
        ],
      ),
    );
  }
}

class MyNotification extends Notification {
  String mensagem;

  MyNotification(this.mensagem);
}

class WebViewChild extends StatefulWidget {
  const WebViewChild({super.key});

  @override
  State<WebViewChild> createState() => _WebViewChildState();
}

class _WebViewChildState extends State<WebViewChild>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: InAppWebView(
            onWebViewCreated: (controller) async {
              webViewController = controller;
              if (!Platform.isAndroid ||
                  await AndroidWebViewFeature.isFeatureSupported(
                      AndroidWebViewFeature.WEB_MESSAGE_LISTENER)) {
                await webViewController!.addWebMessageListener(
                  WebMessageListener(
                      jsObjectName: "CHANNEL",
                      allowedOriginRules: Set.from(['*']),
                      onPostMessage:
                          ((message, sourceOrigin, isMainFrame, replyProxy) {
                        if (message != null) {
                          debugPrint('recebi mensagem ${widget.key}');
                          MyNotification(message).dispatch(context);
                        }
                      })),
                );
              }
            },
            initialUrlRequest:
                URLRequest(url: Uri.parse("https://flutter.dev")),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            var page = await rootBundle.loadString('assets/page.html');

            webViewController?.loadData(data: page);

            setState(() {});
          },
          child: Text('Load Test Page'),
        )
      ],
    );
  }
}
