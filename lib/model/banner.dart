import 'dart:convert';


class BannerModel {
  /// id
  int? id;
  /// 图片地址
  String? picture;
  /// 1.仅图片,2.课程,3.外链
  int? type;
  /// 内容
  String? content;

  BannerModel({
    this.id,
    this.picture,
    this.type,
    this.content,
  });

  BannerModel copyWith({
    int? id,
    String? picture,
    int? type,
    String? content,
  }) => 
    BannerModel(
      id: id ?? this.id,
      picture: picture ?? this.picture,
      type: type ?? this.type,
      content: content ?? this.content,
    );

  factory BannerModel.fromRawJson(String str) => BannerModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    id: json["id"],
    picture: json["picture"],
    type: json["type"],
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "picture": picture,
    "type": type,
    "content": content,
  };
}
