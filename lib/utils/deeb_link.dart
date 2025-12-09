import 'package:app_links/app_links.dart';

class DeepLinkHandler {
  final AppLinks _appLinks = AppLinks();

  Future<void> initDeepLinks(
    Function(String type, String id) onLinkReceived,
  ) async {
    // 📌 الرابط عند تشغيل التطبيق (initial link)
    final uri = await _appLinks.getInitialLink();
    if (uri != null) {
      print("🔗 Initial URI: $uri");
      final result = _extractTypeAndId(uri);
      if (result != null) {
        onLinkReceived(result['type']!, result['id']!);
      } else {
        print("⚠️ Initial URI did not match expected pattern.");
      }
    }

    // 📌 الروابط أثناء تشغيل التطبيق
    _appLinks.uriLinkStream.listen((uri) {
      print("🔗 Streamed URI: $uri");
      final result = _extractTypeAndId(uri);
      if (result != null) {
        onLinkReceived(result['type']!, result['id']!);
      } else {
        print("⚠️ Streamed URI did not match expected pattern.");
      }
    });
  }

  Map<String, String>? _extractTypeAndId(Uri uri) {
    final segments = uri.pathSegments;
    print("📌 Segments: $segments");

    // نتوقع الرابط: /api/v1/store/:id
    if (segments.length >= 4 &&
        segments[0] == 'api' &&
        segments[1] == 'v1' &&
        segments[2] == 'store') {
      final id = segments[3];
      return {'type': 'store', 'id': id};
    }

    return null;
  }
}
