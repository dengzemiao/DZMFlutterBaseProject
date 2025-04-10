import 'dart:convert';

class StoreModel {
  /// 店铺ID
  int? id;
  /// 课程数量
  int? courseCount;
  /// 店铺名称
  String? name;
  /// 联系电话
  String? mobile;
  /// 地址
  String? address;
  /// 图标
  String? logo;
  /// 状态，1 启用 2禁用
  int? status;

  StoreModel({
    this.id,
    this.courseCount,
    this.name,
    this.mobile,
    this.address,
    this.logo,
    this.status
  });

  StoreModel copyWith({
    int? id,
    int? courseCount,
    String? name,
    String? mobile,
    String? address,
    String? logo,
    int? status
  }) => 
    StoreModel(
      id: id ?? this.id,
      courseCount: courseCount ?? this.courseCount,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      address: address ?? this.address,
      logo: logo ?? this.logo,
      status: status ?? this.status
    );

  factory StoreModel.fromRawJson(String str) => StoreModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
    id: json["id"],
    courseCount: json["course_count"],
    name: json["name"],
    mobile: json["mobile"],
    address: json["address"],
    logo: json["logo"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "course_count": courseCount,
    "name": name,
    "mobile": mobile,
    "address": address,
    "logo": logo,
    "status": status
  };
}
