import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PagePriivacyPolice extends StatefulWidget {
  const PagePriivacyPolice({super.key});

  @override
  State<PagePriivacyPolice> createState() => _PagePriivacyPoliceState();
}

class _PagePriivacyPoliceState extends State<PagePriivacyPolice> {
  late InAppWebViewController webView;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("InAppWebView")),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: InAppWebView(initialFile: "assets/html/pdp.html"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
