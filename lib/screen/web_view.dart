import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewTest extends StatelessWidget {
  const WebViewTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (
     Scaffold(
       appBar: AppBar(
         title: Text("Code Factory"),
       ),
        body: WebView(
          initialUrl: 'https://blog.codefactory.ai',
          javascriptMode: JavascriptMode.unrestricted,
        )
     )
    );
  }
}
