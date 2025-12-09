import 'dart:io';
import 'package:yaml/yaml.dart';

void main() async {
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    print('❌ ملف pubspec.yaml غير موجود في المسار الحالي.');
    return;
  }

  final content = pubspecFile.readAsStringSync();
  final doc = loadYaml(content);

  if (doc['dependencies'] == null) {
    print('❌ لا توجد حزم dependencies في pubspec.yaml');
    return;
  }

  final dependencies = Map<String, dynamic>.from(doc['dependencies']);
  final libDir = Directory('lib');

  if (!libDir.existsSync()) {
    print('❌ مجلد lib/ غير موجود.');
    return;
  }

   final dartFiles = libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  final unusedPackages = <String>[];

  for (final packageName in dependencies.keys) {
    bool foundUsage = false;

    for (final file in dartFiles) {
      final content = file.readAsStringSync();

      // نبحث عن استيراد الحزمة أو اسمها في الكود
      if (content.contains("import 'package:$packageName/") ||
          content.contains('package:$packageName') ||
          content.contains(packageName)) {
        foundUsage = true;
        break;
      }
    }

    if (!foundUsage) {
      unusedPackages.add(packageName);
    }
  }

  if (unusedPackages.isEmpty) {
    print('🎉 كل الحزم المستخدمة في pubspec.yaml مستخدمة في الكود.');
  } else {
    print('⚠️ الحزم غير المستخدمة:');

    for (var pkg in unusedPackages) {
      print('- $pkg');
    }
  }
}
