// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class CaptchaScreen extends StatelessWidget {
//   final Function(String) onVerified;
//
//   const CaptchaScreen({super.key, required this.onVerified});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('تحقق من أنك إنسان')),
//       body: WebView(
//         initialUrl: 'assets/reCaptcha.html',
//         javascriptMode: JavascriptMode.unrestricted,
//         javascriptChannels: {
//           JavascriptChannel(
//             name: 'Captcha',
//             onMessageReceived: (JavascriptMessage message) {
//               onVerified(message.message); // Google token
//               Navigator.pop(context);
//             },
//           )
//         },
//       ),
//     );
//   }
// }
