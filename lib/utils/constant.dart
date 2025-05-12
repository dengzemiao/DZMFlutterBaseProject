import 'package:flutter/material.dart';

/// 主题颜色
const Color primaryColor = Color(0xFF3791FE);
/// 主题禁用颜色
const Color primaryDisabledColor = Color(0xFF90C1FF);
/// 主题文案颜色
const Color primaryTextColor = Color(0xFF165DFF);
/// 主题背景颜色
const Color primaryBgColor = Color(0xFFF7F8FA);

/// 手机号校验
RegExp phoneRegExp = RegExp(r'^1[3-9]\d{9}$');

/// 公共 Keys
enum PublicKey {
  /// 是否同意协议
  isAgree(value: 'is_agree'),
  /// 账户信息
  account(value: 'account_info'),
  ;
  /// value
  final String value;
  const PublicKey({ required this.value });
}
