import 'package:flutter/material.dart';
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

  String timeString = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Update time: $timeString'),
        Expanded(
          child: WebView(
            initialUrl: 'https://flutter.dev',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            timeString = DateTime.now().toIso8601String();
            setState(() {});
          },
          child: Text('Update time'),
        )
      ],
    );
  }
}
