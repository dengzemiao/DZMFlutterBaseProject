import 'dart:convert';

class CaseModel {
  /// ID
  int? id;

  /// 构造函数
  CaseModel({
    required this.id,
  });

  /// 从原始 JSON 转换
  factory CaseModel.fromRawJson(String str) => CaseModel.fromJson(json.decode(str));

  /// 转换为原始 JSON
  String toRawJson() => json.encode(toJson());

  /// 拷贝
  CaseModel copyWith({
    int? id,
  }) => 
    CaseModel(
      id: id ?? this.id,
    );

  /// 转换为 JSON
  factory CaseModel.fromJson(Map<String, dynamic> json) {
    final model = CaseModel(
      id: json["id"],
    );
    return model;
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() => {
    "id": id,
  };
}