import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    return NotificationListener<MyNotification>(
        onNotification: (e) {
          debugPrint('webview message: ${e.mensagem}');
          webViewMsg = e.mensagem;
          setState(() {});
          return false;
        },
        child: Column(
          children: [
            Text('Update by webview: $webViewMsg'),
            Expanded(child: WebViewChild()),
          ],
        ));
  }
}

// classe customizada de notificação para receber o callback dos webviews com o notifylistener
class MyNotification extends Notification {
  String mensagem;

  MyNotification(this.mensagem);
}

class WebViewChild extends StatefulWidget {
  const WebViewChild({super.key});

  @override
  State<WebViewChild> createState() => _WebViewChildState();
}

class _WebViewChildState extends State<WebViewChild> {
  WebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            initialUrl: 'https://flutter.dev',
            javascriptChannels: <JavascriptChannel>{
              channel(context),
            },
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            var page = await rootBundle.loadString('assets/page.html');

            await webViewController?.loadHtmlString(page);
            // timeString = DateTime.now().toIso8601String();
            setState(() {});
          },
          child: Text('Load Test Page'),
        )
      ],
    );
  }

  JavascriptChannel channel(BuildContext context) {
    return JavascriptChannel(
        name: 'CHANNEL',
        onMessageReceived: (message) {
          MyNotification(message.message).dispatch(context);
        });
  }
}
