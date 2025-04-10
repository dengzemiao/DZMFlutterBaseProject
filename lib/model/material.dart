import 'dart:convert';
class MaterialModel {
  /// 素材ID
  int id;
  /// 类型，1.视频,2.音频,3.文档,4.图片
  int? type;
  /// 素材名称
  String? name;
  /// 文件大小（字节）
  int? size;
  /// 格式
  String? format;
  /// 时长，视频和音频才有（秒）
  double? duration;
  /// 素材播放地址
  String? url;

  MaterialModel({
    required this.id,
    this.type,
    this.name,
    this.size,
    this.format,
    this.duration,
    this.url
  });

  MaterialModel copyWith({
    int? id,
    int? type,
    String? name,
    int? size,
    String? format,
    double? duration,
    String? url
  }) => 
    MaterialModel(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      size: size ?? this.size,
      format: format ?? this.format,
      duration: duration ?? this.duration,
      url: url ?? this.url
    );

  factory MaterialModel.fromRawJson(String str) => MaterialModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MaterialModel.fromJson(Map<String, dynamic> json) => MaterialModel(
    id: json["id"],
    type: json["type"],
    name: json["name"],
    size: json["size"],
    format: json["format"],
    duration: (json["duration"] is int) ? json["duration"].toDouble() : json["duration"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "name": name,
    "size": size,
    "format": format,
    "duration": duration,
    "url": url
  };
}
