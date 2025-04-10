import 'dart:convert';

class StudyRecordModel {
  /// 用户ID
  int? userId;
  /// 课程ID
  int? courseId;
  /// 课程名称
  String? courseName;
  /// 课程封面
  String? courseCover;
  /// 章节ID
  int? chapterId;
  /// 章节名称
  String? chapterName;
  /// 章节封面
  String? chapterCover;
  /// 音视频时长
  double? duration;
  /// 播放进度
  int? position;
  /// 是否完播，0 未完成，1完成
  int? finished;
  /// 更新时间，时间戳（秒）
  int? updatedAt;

  StudyRecordModel({
    this.userId,
    this.courseId,
    this.courseName,
    this.courseCover,
    this.chapterId,
    this.chapterName,
    this.chapterCover,
    this.duration,
    this.position,
    this.finished,
    this.updatedAt,
  });

  StudyRecordModel copyWith({
    int? userId,
    int? courseId,
    String? courseName,
    String? courseCover,
    int? chapterId,
    String? chapterName,
    String? chapterCover,
    double? duration,
    int? position,
    int? finished,
    int? updatedAt,
  }) => 
    StudyRecordModel(
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      chapterId: chapterId ?? this.chapterId,
      chapterName: chapterName ?? this.chapterName,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      finished: finished ?? this.finished,
      updatedAt: updatedAt ?? this.updatedAt,
    );

  factory StudyRecordModel.fromRawJson(String str) => StudyRecordModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StudyRecordModel.fromJson(Map<String, dynamic> json) => StudyRecordModel(
    userId: json["user_id"],
    courseId: json["course_id"],
    courseName: json["course_name"],
    courseCover: json["course_cover"],
    chapterId: json["chapter_id"],
    chapterName: json["chapter_name"],
    chapterCover: json["chapter_cover"],
    duration: (json["duration"] is int) ? json["duration"].toDouble() : json["duration"],
    position: json["position"],
    finished: json["finished"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "course_id": courseId,
    "course_name": courseName,
    "course_cover": courseCover,
    "chapter_id": chapterId,
    "chapter_name": chapterName,
    "chapter_cover": chapterCover,
    "duration": duration,
    "position": position,
    "finished": finished,
    "updated_at": updatedAt,
  };
}
