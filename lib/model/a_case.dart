import 'dart:convert';

class CaseModel {
  /// ID
  int? id;
  List<Map<String, dynamic>>? list;

  /// 构造函数
  CaseModel({
    this.id,
    this.list,
  });

  /// 拷贝
  CaseModel copyWith({
    int? id,
    List<Map<String, dynamic>>? list,
  }) => 
    CaseModel(
      id: id ?? this.id,
      list: list ?? this.list,
    );

  /// 从原始 JSON 转换
  factory CaseModel.fromRawJson(String str) => CaseModel.fromJson(json.decode(str));

  /// 转换为 JSON
  factory CaseModel.fromJson(Map<String, dynamic> json) => CaseModel()..updateFromJson(json);
  
  /// 转换为原始 JSON
  String toRawJson() => json.encode(toJson());

  /// 转换为 JSON
  Map<String, dynamic> toJson() => {
    "id": id,
    "list": list,
  };

  /// 更新数据
  /// [force] 是否强制覆盖（即使为null也覆盖），默认为false，仅当 json 中有对应 key 时才覆盖
  void updateFromJson(Map<String, dynamic> json, {bool force = false}) {
    if (json.isNotEmpty || force) {
      id = force || json.containsKey('id') ? json['id'] : id;
      final listData = json['list'] ?? [];
      list = force || json.containsKey('list') ? List<Map<String, dynamic>>.from(listData.map((x) => x)) : list;
    }
  }

  /// 更新数据
  /// [force] 是否强制覆盖（即使为null也覆盖），默认为false
  void updateFromRawJson(String? str, {bool force = false}) {
    final jsonData = json.decode(str ?? '{}');
    updateFromJson(jsonData, force: force);
  }
}