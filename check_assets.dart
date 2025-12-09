import 'dart:io';

void main() {
  final assetsDir = Directory('assets/test'); // عدّل المسار حسب مشروعك
  final dartFilesDir = Directory('lib');

  final assetFiles = assetsDir
      .listSync(recursive: true)
      .whereType<File>()
      .map((f) => f.path.split(Platform.pathSeparator).last)
      .toSet();

  final dartFiles = dartFilesDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  final usedAssets = <String>{};

  for (var dartFile in dartFiles) {
    final content = dartFile.readAsStringSync();
    for (var asset in assetFiles) {
      if (content.contains(asset)) {
        usedAssets.add(asset);
      }
    }
  }

  final unusedAssets = assetFiles.difference(usedAssets);

  if (unusedAssets.isEmpty) {
    print('كل الصور في assets مستخدمة.');
  } else {
    print('الصور غير المستخدمة في الكود:');
    for (var asset in unusedAssets) {
      print(asset);
    }
  }
}
