# Alice <img src="https://raw.githubusercontent.com/eduardoazvd17/flutter-alice-http/main/media/logo.png" width="25px">

[![pub package](https://img.shields.io/pub/v/flutter_alice_http.svg)](https://pub.dev/packages/flutter_alice_http)
[![pub package](https://img.shields.io/github/license/eduardoazvd17/flutter-alice-http.svg?style=flat)](https://github.com/eduardoazvd17/flutter-alice-http)
[![pub package](https://img.shields.io/badge/platform-flutter-blue.svg)](https://github.com/eduardoazvd17/flutter-alice-http)

Alice is an HTTP Inspector tool for Flutter which helps debugging http requests. 
It catches and stores http requests and responses, which can be viewed via simple UI. 
It is inspired from Chuck (https://github.com/jgilfelt/chuck) and Chucker (https://github.com/ChuckerTeam/chucker).


Overlay bubble version of Alice: https://github.com/jhomlala/alice

<table>
  <tr>
    <td>
		<img width="250px" src="https://raw.githubusercontent.com/eduardoazvd17/flutter-alice-http/main/media/1.png">
    </td>
    <td>
       <img width="250px" src="https://raw.githubusercontent.com/eduardoazvd17/flutter-alice-http/main/media/2.png">
    </td>
    <td>
       <img width="250px" src="https://raw.githubusercontent.com/eduardoazvd17/flutter-alice-http/main/media/3.png">
    </td>
    <td>
       <img width="250px" src="https://raw.githubusercontent.com/eduardoazvd17/flutter-alice-http/main/media/4.png">
    </td>
     <td>
       <img width="250px" src="https://raw.githubusercontent.com/eduardoazvd17/flutter-alice-http/main/media/5.png">
    </td>
    <td>
       <img width="250px" src="https://raw.githubusercontent.com/eduardoazvd17/flutter-alice-http/main/media/6.png">
    </td>
  </tr>
  <tr>
    <td>
	<img width="250px" src="https://raw.githubusercontent.com/eduardoazvd17/flutter-alice-http/main/media/7.png">
    </td>
    <td>
       <img width="250px" src="https://raw.githubusercontent.com/eduardoazvd17/flutter-alice-http/main/media/8.png">
    </td>
    <td>
       <img width="250px" src="https://raw.githubusercontent.com/eduardoazvd17/flutter-alice-http/main/media/9.png">
    </td>
    <td>
       <img width="250px" src="https://raw.githubusercontent.com/eduardoazvd17/flutter-alice-http/main/media/10.png">
    </td>
    <td>
       <img width="250px" src="https://raw.githubusercontent.com/eduardoazvd17/flutter-alice-http/main/media/11.png">
    </td>
     <td>
       <img width="250px" src="https://raw.githubusercontent.com/eduardoazvd17/flutter-alice-http/main/media/12.png">
    </td>
  </tr>

</table>

**Supported Dart http client plugins:**

- HttpClient from dart:io package
- Http from http/http package
- Generic HTTP client

**Features:**  
✔️ Detailed logs for each HTTP calls (HTTP Request, HTTP Response)  
✔️ Inspector UI for viewing HTTP calls  
✔️ Statistics  
✔️ Support for top used HTTP clients in Dart  
✔️ Error handling  
✔️ HTTP calls search
✔️ Bubble overlay entry

## Install

1. Add this to your **pubspec.yaml** file:

```yaml
dependencies:
  flutter_alice_http: ^2.0.0
```

2. Install it

```bash
$ flutter pub get
```

3. Import it

```dart
import 'package:flutter_alice_http_http/alice.dart';
```

## Usage
### Alice configuration
1. Create Alice instance:

```dart
Alice alice = Alice();
```

2. Add navigator key to your application:

```dart
MaterialApp( navigatorKey: alice.getNavigatorKey(), home: ...)
```

You need to add this navigator key in order to show inspector UI.
You can use also your navigator key in Alice:

```dart
Alice alice = Alice(navigatorKey: yourNavigatorKeyHere);
```

If you need to pass navigatorKey lazily, you can use:
```dart
alice.setNavigatorKey(yourNavigatorKeyHere);
```
This is minimal configuration required to run Alice. Can set optional settings in Alice constructor, which are presented below. If you don't want to change anything, you can move to Http clients configuration.

### Additional settings
If you want to use dark mode just add `darkTheme` flag:

```dart
Alice alice = Alice(..., darkTheme: true);
```

### HTTP Client configuration
If you're using Dio, you just need to add interceptor.

```dart
Dio dio = Dio();
dio.interceptors.add(alice.getDioInterceptor());
```


If you're using HttpClient from dart:io package:

```dart
httpClient
	.getUrl(Uri.parse("https://jsonplaceholder.typicode.com/posts"))
	.then((request) async {
		alice.onHttpClientRequest(request);
		var httpResponse = await request.close();
		var responseBody = await httpResponse.transform(utf8.decoder).join();
		alice.onHttpClientResponse(httpResponse, request, body: responseBody);
 });
```

If you're using http from http/http package:

```dart
http.get('https://jsonplaceholder.typicode.com/posts').then((response) {
    alice.onHttpResponse(response);
});
```

If you're using Chopper. you need to add interceptor:

```dart
chopper = ChopperClient(
    interceptors: alice.getChopperInterceptor(),
);
```

If you have other HTTP client you can use generic http call interface:
```dart
AliceHttpCall aliceHttpCall = AliceHttpCall(id);
alice.addHttpCall(aliceHttpCall);
```

## Extensions
You can use extensions to shorten your http and http client code. This is optional, but may improve your codebase.
Example:
1. Import:
```dart
import 'package:flutter_alice_http_http/core/alice_http_client_extensions.dart';
import 'package:flutter_alice_http_http/core/alice_http_extensions.dart';
```

2. Use extensions:
```dart
http
    .post('https://jsonplaceholder.typicode.com/posts', body: body)
    .interceptWithAlice(alice, body: body);
```

```dart
httpClient
    .postUrl(Uri.parse("https://jsonplaceholder.typicode.com/posts"))
    .interceptWithAlice(alice, body: body, headers: Map());
```
