import 'package:jiffy/jiffy.dart';

class Date {

  // 静态变量存储单例
  static final Date _instance = Date._internal();
  // 静态方法获取单例实例
  factory Date() => _instance;
  // 私有构造函数，确保只能通过工厂方法获取实例
  Date._internal();

  /// 将服务器时间（UTC时间戳或UTC字符串）转换为手机本地时区时间
  /// [utcTime] 支持类型：int（时间戳，秒或毫秒）、String（UTC时间字符串）、DateTime
  /// [format] 输出格式（默认：yyyy-MM-dd HH:mm:ss）
  /// [isMillis] 当输入是时间戳时，是否为毫秒级（默认false，即秒级）
  String formatUtcToLocal(
    dynamic utcTime, {
    String format = 'yyyy-MM-dd HH:mm:ss',
    bool isMillis = false,
  }) {
    try {
      if (utcTime is int) {
        // 处理时间戳
        final timestamp = isMillis ? utcTime : utcTime * 1000;
        return Jiffy.parseFromMillisecondsSinceEpoch(timestamp, isUtc: true)
            .toLocal() // 关键：转换为本地时区
            .format(pattern: format);
      } else if (utcTime is String) {
        // 处理 UTC 时间字符串
        return Jiffy.parse(utcTime, isUtc: true)
            .toLocal() // 关键：转换为本地时区
            .format(pattern: format);
      } else if (utcTime is DateTime) {
        // 处理 DateTime
        return Jiffy.parseFromDateTime(utcTime.toUtc())
            .toLocal() // 防止本地时间误识别为 UTC
            .format(pattern: format);
      } else {
        throw ArgumentError('Unsupported type: ${utcTime.runtimeType}');
      }
    } catch (e) {
      throw FormatException('Failed to parse time: $utcTime. Error: $e');
    }
  }

  /// 将本地时间转换为 UTC 时间字符串
  /// [localTime] 支持类型：int（时间戳，秒或毫秒）、String（本地时间字符串）、DateTime
  /// [format] 输出格式（默认：yyyy-MM-dd HH:mm:ss）
  /// [isMillis] 当输入是时间戳时，是否为毫秒级（默认false，即秒级）
  String formatLocalToUtc(
    dynamic localTime, {
    String format = 'yyyy-MM-dd HH:mm:ss',
    bool isMillis = false,
  }) {
    try {
      if (localTime is int) {
        // 处理时间戳（默认按本地时间处理）
        final timestamp = isMillis ? localTime : localTime * 1000;
        return Jiffy.parseFromMillisecondsSinceEpoch(timestamp)
            .toUtc() // 关键：转换为 UTC 时区
            .format(pattern: format);
      } else if (localTime is String) {
        // 处理本地时间字符串（如 2025-06-15 08:00:00）
        return Jiffy.parse(localTime)
            .toUtc() // 关键：转换为 UTC 时区
            .format(pattern: format);
      } else if (localTime is DateTime) {
        // 处理 DateTime（默认认为是本地时间）
        return Jiffy.parseFromDateTime(localTime)
            .toUtc() // 关键：转换为 UTC 时区
            .format(pattern: format);
      } else {
        throw ArgumentError('Unsupported type: ${localTime.runtimeType}');
      }
    } catch (e) {
      throw FormatException('Failed to parse time: $localTime. Error: $e');
    }
  }

  /// 判断时间戳是否早于当前时间超过指定天数
  /// [timestamp] 支持秒或毫秒（通过 isMillis 区分）
  /// [days] 超过的天数
  /// [isMillis] 是否为毫秒级，默认 false（即单位为秒）
  bool isTimestampOlderThanDays(int timestamp, int days, {bool isMillis = false}) {
    final ts = isMillis ? timestamp ~/ 1000 : timestamp;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final diffInSeconds = now - ts;
    return diffInSeconds > days * 24 * 60 * 60;
  }

  /// 将时间戳（秒或毫秒）格式化为字符串（HH:mm:ss 或 mm:ss）
  /// [timestamp] 可以为 null
  /// [isMillis] 是否为毫秒级时间戳，默认 false（即单位为秒）
  /// [showHours] 是否显示小时部分，默认 true
  String formatTimestamp(int? timestamp, {bool isMillis = false, bool showHours = true}) {
    final seconds = (timestamp == null) ? 0 : (isMillis ? timestamp ~/ 1000 : timestamp);
    return formatDuration(Duration(seconds: seconds), showHours: showHours);
  }

  /// 格式化 Duration 为字符串，格式为 HH:mm:ss 或 mm:ss
  /// [duration] 可选，默认为 Duration.zero
  /// [showHours] 是否显示小时部分
  String formatDuration(Duration? duration, {bool showHours = true}) {
    final temp = duration ?? Duration.zero;
    if (showHours) {
      final hours = temp.inHours.toString().padLeft(2, '0');
      final minutes = (temp.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (temp.inSeconds % 60).toString().padLeft(2, '0');
      return '$hours:$minutes:$seconds';
    } else {
      final minutes = (temp.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (temp.inSeconds % 60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    }
  }

  /// 获取当前时间（支持返回本地时区或UTC时区）
  /// [format] 输出格式（默认：yyyy-MM-dd HH:mm:ss）
  /// [isUtc] 是否返回UTC时间（默认false）
  String getCurrentTime({
    String format = 'yyyy-MM-dd HH:mm:ss',
    bool isUtc = false,
  }) {
    return isUtc
      ? Jiffy.now().toUtc().format(pattern: format)
      : Jiffy.now().format(pattern: format);
  }
}