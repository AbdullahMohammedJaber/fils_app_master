import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

class VideoEditor {
  final String inputPath;
  String? outputPath;

  VideoEditor({required this.inputPath, this.outputPath});

  /// Trim video between [startTime] and [endTime] (in seconds)
  Future<bool> trimVideo({
    required double startTime,
    required double endTime,
    String? outputPath,
  }) async {
    final output = outputPath ?? this.outputPath;
    if (output == null) {
      throw Exception('Output path not provided');
    }

    final duration = endTime - startTime;
    final command =
        '-ss $startTime -i "$inputPath" -t $duration -c:v libx264 -c:a aac -avoid_negative_ts make_zero "$output"';

    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    return ReturnCode.isSuccess(returnCode);
  }

  /// Apply brightness/contrast/saturation filters
  Future<bool> applyFilters({
    double brightness = 0.0, // -1.0 to 1.0
    double contrast = 1.0, // 0.0 to 2.0
    double saturation = 1.0, // 0.0 to 3.0
    String? outputPath,
  }) async {
    final output = outputPath ?? this.outputPath;
    if (output == null) {
      throw Exception('Output path not provided');
    }

    final command =
        '-i "$inputPath" -vf "eq=brightness=$brightness:contrast=$contrast:saturation=$saturation" -c:a copy "$output"';

    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    return ReturnCode.isSuccess(returnCode);
  }

  /// Add text to video at specified position
  Future<bool> addText({
    required String text,
    double x = 0,
    double y = 0,
    dynamic fontSize = 24,
    String fontColor = 'white',
    String? fontFile, // Path to custom font file (optional)
    String? outputPath,
  }) async {
    final output = outputPath ?? this.outputPath;
    if (output == null) {
      throw Exception('Output path not provided');
    }

    String fontConfig = '';
    if (fontFile != null) {
      fontConfig = ':fontfile=$fontFile';
    }

    final command =
        '-i "$inputPath" -vf "drawtext=text=\'$text\':x=$x:y=$y:fontsize=$fontSize:fontcolor=$fontColor$fontConfig" -codec:a copy "$output"';

    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    return ReturnCode.isSuccess(returnCode);
  }

  /// Combine multiple operations (trim + filters + text)
  Future<bool> processVideo({
    double? startTime,
    double? endTime,
    double? brightness,
    double? contrast,
    double? saturation,
    String? text,
    double? textX,
    double? textY,
    dynamic fontSize,
    String? fontColor,
    String? fontFile,
    String? outputPath,
  }) async {
    final output = outputPath ?? this.outputPath;
    if (output == null) {
      throw Exception('Output path not provided');
    }

    String filterComplex = '';
    List<String> filters = [];

    // Add trim if specified
    if (startTime != null && endTime != null) {
      filterComplex += '-ss $startTime -t ${endTime - startTime} ';
    }

    // Add image filters if specified
    if (brightness != null || contrast != null || saturation != null) {
      final b = brightness ?? 0.0;
      final c = contrast ?? 1.0;
      final s = saturation ?? 1.0;
      filters.add('eq=brightness=$b:contrast=$c:saturation=$s');
    }

    // Add text if specified
    if (text != null) {
      final x = textX ?? 0;
      final y = textY ?? 0;
      final fs = fontSize ?? 24;
      final fc = fontColor ?? 'white';
      String fontConfig = fontFile != null ? ':fontfile=$fontFile' : '';
      filters.add(
        'drawtext=text=\'$text\':x=$x:y=$y:fontsize=$fs:fontcolor=$fc$fontConfig',
      );
    }

    // Combine all filters
    if (filters.isNotEmpty) {
      filterComplex += '-vf "${filters.join(',')}" ';
    }

    final command =
        '$filterComplex-i "$inputPath" -c:v libx264 -c:a aac "$output"';

    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    return ReturnCode.isSuccess(returnCode);
  }
}
