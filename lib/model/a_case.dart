import 'dart:convert';

class CaseModel {
  /// ID
  int? id;

  /// 构造函数
  CaseModel({
    required this.id,
  });

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

  /// 从原始 JSON 转换
  factory CaseModel.fromRawJson(String str) => CaseModel.fromJson(json.decode(str));

  /// 转换为原始 JSON
  String toRawJson() => json.encode(toJson());

  /// 更新数据
  /// [force] 是否强制覆盖（即使为null也覆盖），默认为false，仅当 json 中有对应 key 时才覆盖
  void updateFromJson(Map<String, dynamic> json, {bool force = false}) {
    if (json.isNotEmpty) {
      id = force ? json['id'] : (json.containsKey('id') ? json['id'] : id);
    }
  }

  /// 更新数据
  /// [force] 是否强制覆盖（即使为null也覆盖），默认为false
  void updateFromRawJson(String? str, {bool force = false}) {
    final jsonData = json.decode(str ?? '{}');
    updateFromJson(jsonData, force: force);
  }
}