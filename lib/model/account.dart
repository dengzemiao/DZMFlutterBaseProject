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

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel()..updateFromJson(json);

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "effective_seconds": effectiveSeconds,
    "expired_at": expiredAt,
    "user_info": userInfo?.toJson(),
  };

  /// 更新数据
  /// [force] 是否强制覆盖（即使为null也覆盖），默认为false，仅当 json 中有对应 key 时才覆盖
  void updateFromJson(Map<String, dynamic> json, {bool force = false}) {
    if (json.isNotEmpty || force) {
      accessToken = force || json.containsKey('access_token') ? json['access_token'] : accessToken;
      effectiveSeconds = force || json.containsKey('effective_seconds') ? json['effective_seconds'] : effectiveSeconds;
      expiredAt = force || json.containsKey('expired_at') ? json['expired_at'] : expiredAt;
      userInfo = force || json.containsKey('user_info') ? (json['user_info'] == null ? null : UserInfo.fromJson(json['user_info'])) : userInfo;
    }
  }

  /// 更新数据
  /// [force] 是否强制覆盖（即使为null也覆盖），默认为false
  void updateFromRawJson(String? str, {bool force = false}) {
    final jsonData = json.decode(str ?? '{}');
    updateFromJson(jsonData, force: force);
  }

  // 清空单例的数据
  void clear() {
    accessToken = null;
    effectiveSeconds = null;
    expiredAt = null;
    userInfo = null;
  }
}