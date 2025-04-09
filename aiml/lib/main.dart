import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RSK Live',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setUserAgent(
          "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Mobile Safari/537.36")
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse("https://rsklive.com/"))
      ..runJavaScript("""
        document.querySelector('meta[name="viewport"]')?.setAttribute(
          'content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'
        );
        document.body.style.webkitTextSizeAdjust = 'none';
        document.body.style.fontSmoothing = 'antialiased';
        document.body.style.textRendering = 'optimizeLegibility';
        document.body.style.imageRendering = 'crisp-edges';
      """);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900], // Dark bluish background
        toolbarHeight: 25, // Decreased AppBar height
      ),
      resizeToAvoidBottomInset: false,  // Prevent resizing of the screen when the keyboard appears
      body: Stack(
        children: [
          Positioned.fill(
            child: WebViewWidget(controller: controller),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            ),
        ],
      ),
    );
  }
}