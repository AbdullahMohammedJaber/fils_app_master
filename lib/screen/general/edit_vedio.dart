import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_video_editor/easy_video_editor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FileBasedVideoEditScreen extends StatefulWidget {
  final File videoFile;

  const FileBasedVideoEditScreen({super.key, required this.videoFile});

  @override
  State<FileBasedVideoEditScreen> createState() =>
      _FileBasedVideoEditScreenState();
}

class _FileBasedVideoEditScreenState extends State<FileBasedVideoEditScreen> {
  double exportProgress = 0.0;
  bool exporting = false;

  Future<void> editVideoFromFile() async {
    final inputPath = widget.videoFile.path;

    // ✅ استخدم مجلد مؤقت بدلاً من المستندات
    final tempDir = await getTemporaryDirectory();
    final outputPath = path.join(
      tempDir.path,
      'temp_edited_${DateTime.now().millisecondsSinceEpoch}.mp4',
    );

    setState(() {
      exporting = true;
      exportProgress = 0.0;
    });

    final editor = VideoEditorBuilder(videoPath: inputPath)
        .trim(startTimeMs: 0, endTimeMs: 30000)
        .crop(aspectRatio: VideoAspectRatio.ratio16x9)
        .compress(resolution: VideoResolution.p720);

    try {
      final resultPath = await editor.export(
        outputPath: outputPath,
        onProgress: (progress) {
          setState(() => exportProgress = progress);
        },
      );

      setState(() => exporting = false);

      if (mounted) Navigator.pop(context, File(resultPath!));
    } catch (e) {
      setState(() => exporting = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('فشل تعديل الفيديو: $e')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    editVideoFromFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            exporting
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    Text(
                      "جاري تعديل الفيديو ${(exportProgress * 100).toStringAsFixed(1)}%",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                )
                : const SizedBox(),
      ),
    );
  }
}
