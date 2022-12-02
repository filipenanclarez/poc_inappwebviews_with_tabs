import 'package:flutter/material.dart';

import 'flutter_webview.dart' as flutterWV;
import 'inapp_webview.dart' as inappWV;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("AppBar with tabs"),
          bottom: TabBar(
            tabs: <Widget>[
              Text("First Tab"),
              Text("Second Tab"),
              Text("Third Tab"),
              Text("Four Tab"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            flutterWV.CustomWebview(),
            inappWV.CustomWebview(),
            flutterWV.CustomWebview(),
            inappWV.CustomWebview(),
          ],
        ),
      ),
    );
  }
}
