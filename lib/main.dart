//
// import 'package:flutter/material.dart';
// import 'package:uni_links/uni_links.dart';
// import 'dart:async';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatefulWidget {
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   StreamSubscription? _sub;
//
//   @override
//   void initState() {
//     super.initState();
//     _sub = uriLinkStream.listen((Uri? uri) {
//       if (uri != null) {
//         final postId = uri.queryParameters['id'];
//         print("Navigate to post with ID: $postId");
//         // Navigate based on `postId`
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: Scaffold(body: Center(child: Text("Waiting for link..."))));
//   }
//
//   @override
//   void dispose() {
//     _sub?.cancel();
//     super.dispose();
//   }
// }
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:share_plus/share_plus.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLinks appLinks = AppLinks();
  String? productId;

  @override
  void initState() {
    super.initState();
    initDeepLinking();
  }

  void initDeepLinking() async {
    final uri = await appLinks.getInitialLink();
    handleUri(uri);

    appLinks.uriLinkStream.listen((uri) {
      handleUri(uri);
    });
  }

  void handleUri(Uri? uri) {
    if (uri != null && uri.queryParameters.containsKey('id')) {
      setState(() {
        productId = uri.queryParameters['id'];
      });
    }
  }

  void _shareProductLink(String id) {
    final link = 'https://unilinkdemo-771b8.web.app/redirect?id=$id';
    Share.share('Check this product: $link');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('App Links Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (productId != null)
                Text('Product ID: $productId', style: TextStyle(fontSize: 20))
              else
                Text('No deep link receive', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _shareProductLink('123'),
                child: Text('Share Product Link'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
