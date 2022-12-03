import 'package:flutter/material.dart';
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

  String timeString = '';

  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Update time: $timeString'),
        Expanded(
          child: InAppWebView(
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            initialUrlRequest:
                URLRequest(url: Uri.parse("https://flutter.dev")),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            webViewController?.loadUrl(
                urlRequest: URLRequest(url: Uri.parse("https://flutter.dev")));
            timeString = DateTime.now().toIso8601String();
            setState(() {});
          },
          child: Text('Update time'),
        )
      ],
    );
  }
}
