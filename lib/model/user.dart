import 'dart:convert';

class UserInfo {
  /// 用户ID
  int? id;
  /// 昵称
  String? nickname;
  /// 头像
  String? avatar;
  /// 是否实名认证（0否，1是）
  int? authenticated;
  /// 手机号
  int? mobile;
  /// 绑定的店铺ID（0为不绑定）
  int? boundMerchantId;

  UserInfo({
    this.id,
    this.nickname,
    this.avatar,
    this.authenticated,
    this.mobile,
    this.boundMerchantId,
  });

  UserInfo copyWith({
    int? id,
    String? nickname,
    String? avatar,
    int? authenticated,
    int? mobile,
    int? boundMerchantId,
  }) => 
    UserInfo(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      authenticated: authenticated ?? this.authenticated,
      mobile: mobile ?? this.mobile,
      boundMerchantId: boundMerchantId ?? this.boundMerchantId,
    );

  factory UserInfo.fromRawJson(String str) => UserInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    id: json["id"],
    nickname: json["nickname"],
    avatar: json["avatar"],
    authenticated: json["authenticated"],
    mobile: json["mobile"],
    boundMerchantId: json["bound_merchant_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nickname": nickname,
    "avatar": avatar,
    "authenticated": authenticated,
    "mobile": mobile,
    "bound_merchant_id": boundMerchantId,
  };
}
