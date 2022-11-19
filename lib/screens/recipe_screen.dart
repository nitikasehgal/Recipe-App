import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeScreen extends StatefulWidget {
  String posturl;
  RecipeScreen(this.posturl);
  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  String? finalUrl;
  final Completer<WebViewController> _completer =
      Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    if (widget.posturl.contains('http://')) {
      finalUrl = widget.posturl.replaceAll("http://", "https://");
    } else {
      finalUrl = widget.posturl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(children: [
          Container(
            padding: EdgeInsets.only(top: 40, right: 24, left: 24, bottom: 16),
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [Color(0xff213A50), Color(0xFF071930)],
            )),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment:
                  // kIsWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
                  MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 135,
                ),
                Text(
                  "Recipe",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.2),
                ),
                Text(
                  "App",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.2),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 100,
            width: MediaQuery.of(context).size.width,
            child: WebView(
              initialUrl: finalUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webviewcontroller) {
                setState(() {
                  _completer.complete(webviewcontroller);
                });
              },
            ),
          )
        ]),
      ),
    );
  }
}
