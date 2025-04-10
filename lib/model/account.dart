import 'dart:convert';
import './user.dart';

class AccountModel {
  /// Access Token
  String? accessToken;
  /// 有效秒数
  int? effectiveSeconds;
  /// Access Token 过期时间（时间戳）
  int? expiredAt;
  /// 用户信息
  UserInfo? userInfo;

  // 创建单例实例
  static final AccountModel _instance = AccountModel._internal();
  // 私有构造函数
  AccountModel._internal();
  // 返回单例实例
  factory AccountModel() {
    return _instance;
  }

  // 更新单例数据
  void updateFromRawJson(String str) {
    final jsonData = json.decode(str);
    _instance._updateFromJson(jsonData);
  }

  void updateFromJson(Map<String, dynamic> json) {
    _instance._updateFromJson(json);
  }

  // 内部更新数据方法
  void _updateFromJson(Map<String, dynamic> json) {
    accessToken = json["access_token"];
    effectiveSeconds = json["effective_seconds"];
    expiredAt = json["expired_at"];
    userInfo = json["user_info"] == null ? null : UserInfo.fromJson(json["user_info"]);
  }

  // 清空单例的数据
  void clear() {
    accessToken = null;
    effectiveSeconds = null;
    expiredAt = null;
    userInfo = null;
  }

  AccountModel copyWith({
    String? accessToken,
    int? effectiveSeconds,
    int? expiredAt,
    UserInfo? userInfo,
  }) => 
    AccountModel()
      ..accessToken = accessToken ?? this.accessToken
      ..effectiveSeconds = effectiveSeconds ?? this.effectiveSeconds
      ..expiredAt = expiredAt ?? this.expiredAt
      ..userInfo = userInfo ?? this.userInfo;

  factory AccountModel.fromRawJson(String str) => AccountModel()..updateFromRawJson(str);

  String toRawJson() => json.encode(toJson());

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel()..updateFromJson(json);

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "effective_seconds": effectiveSeconds,
    "expired_at": expiredAt,
    "user_info": userInfo?.toJson(),
  };
}