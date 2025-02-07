import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_alice/alice.dart';
import 'package:flutter_alice/core/alice_http_client_extensions.dart';
import 'package:flutter_alice/core/alice_http_extensions.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Alice _alice;
  late HttpClient _httpClient;

  @override
  void initState() {
    _alice = Alice(
      showNotification: true,
      showInspectorOnShake: true,
      darkTheme: false,
    );
    _httpClient = HttpClient();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        navigatorKey: _alice.getNavigatorKey(),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Alice HTTP Inspector - Example'),
          ),
          body: Container(
            padding: EdgeInsets.all(16),
            child: ListView(
              children: [
                const SizedBox(height: 8),
                _getTextWidget(
                    "Welcome to example of Alice Http Inspector. Click buttons below to generate sample data."),
                ElevatedButton(
                  child: Text("Run http/http HTTP Requests"),
                  onPressed: _runHttpHttpRequests,
                ),
                ElevatedButton(
                  child: Text("Run HttpClient Requests"),
                  onPressed: _runHttpHttpClientRequests,
                ),
                const SizedBox(height: 24),
                _getTextWidget(
                    "After clicking on buttons above, you should receive notification."
                    " Click on it to show inspector. You can also shake your device or click button below."),
                ElevatedButton(
                  child: Text("Run HTTP Insepctor"),
                  onPressed: _runHttpInspector,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTextWidget(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 14),
      textAlign: TextAlign.center,
    );
  }

  void _runHttpHttpRequests() async {
    Map<String, dynamic> body = {"title": "foo", "body": "bar", "userId": "1"};
    http
        .post(Uri.parse('https://jsonplaceholder.typicode.com/posts'),
            body: body)
        .interceptWithAlice(_alice, body: body);

    http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'))
        .interceptWithAlice(_alice);

    http
        .put(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
            body: body)
        .interceptWithAlice(_alice, body: body);

    http
        .patch(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
            body: body)
        .interceptWithAlice(_alice, body: body);

    http
        .delete(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'))
        .interceptWithAlice(_alice, body: body);

    http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/test/test'))
        .interceptWithAlice(_alice);

    http
        .post(Uri.parse('https://jsonplaceholder.typicode.com/posts'),
            body: body)
        .then((response) {
      _alice.onHttpResponse(response, body: body);
    });

    http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'))
        .then((response) {
      _alice.onHttpResponse(response);
    });

    http
        .put(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
            body: body)
        .then((response) {
      _alice.onHttpResponse(response, body: body);
    });

    http
        .patch(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
            body: body)
        .then((response) {
      _alice.onHttpResponse(response, body: body);
    });

    http
        .delete(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'))
        .then((response) {
      _alice.onHttpResponse(response);
    });

    http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/test/test'))
        .then((response) {
      _alice.onHttpResponse(response);
    });
  }

  void _runHttpHttpClientRequests() {
    Map<String, dynamic> body = {"title": "foo", "body": "bar", "userId": "1"};
    _httpClient
        .getUrl(Uri.parse("https://jsonplaceholder.typicode.com/posts"))
        .interceptWithAlice(_alice);

    _httpClient
        .postUrl(Uri.parse("https://jsonplaceholder.typicode.com/posts"))
        .interceptWithAlice(_alice, body: body, headers: Map());

    _httpClient
        .putUrl(Uri.parse("https://jsonplaceholder.typicode.com/posts/1"))
        .interceptWithAlice(_alice, body: body);

    _httpClient
        .getUrl(Uri.parse("https://jsonplaceholder.typicode.com/test/test/"))
        .interceptWithAlice(_alice);

    _httpClient
        .postUrl(Uri.parse("https://jsonplaceholder.typicode.com/posts"))
        .then((request) async {
      _alice.onHttpClientRequest(request, body: body);
      request.write(body);
      var httpResponse = await request.close();
      var responseBody = await utf8.decoder.bind(httpResponse).join();
      _alice.onHttpClientResponse(httpResponse, request, body: responseBody);
    });

    _httpClient
        .putUrl(Uri.parse("https://jsonplaceholder.typicode.com/posts/1"))
        .then((request) async {
      _alice.onHttpClientRequest(request, body: body);
      request.write(body);
      var httpResponse = await request.close();
      var responseBody = await utf8.decoder.bind(httpResponse).join();
      _alice.onHttpClientResponse(httpResponse, request, body: responseBody);
    });

    _httpClient
        .patchUrl(Uri.parse("https://jsonplaceholder.typicode.com/posts/1"))
        .then((request) async {
      _alice.onHttpClientRequest(request, body: body);
      request.write(body);
      var httpResponse = await request.close();
      var responseBody = await utf8.decoder.bind(httpResponse).join();
      _alice.onHttpClientResponse(httpResponse, request, body: responseBody);
    });

    _httpClient
        .deleteUrl(Uri.parse("https://jsonplaceholder.typicode.com/posts/1"))
        .then((request) async {
      _alice.onHttpClientRequest(request);
      var httpResponse = await request.close();
      var responseBody = await utf8.decoder.bind(httpResponse).join();
      _alice.onHttpClientResponse(httpResponse, request, body: responseBody);
    });

    _httpClient
        .getUrl(Uri.parse("https://jsonplaceholder.typicode.com/test/test/"))
        .then((request) async {
      _alice.onHttpClientRequest(request);
      var httpResponse = await request.close();
      var responseBody = await utf8.decoder.bind(httpResponse).join();
      _alice.onHttpClientResponse(httpResponse, request, body: responseBody);
    });
  }

  void _runHttpInspector() {
    _alice.showInspector();
  }
}
