import 'package:flutter/material.dart';

class Device {

  // 静态变量存储单例
  static final Device _instance = Device._internal();
  // 静态方法获取单例实例
  factory Device() => _instance;
  // 私有构造函数，确保只能通过工厂方法获取实例
  Device._internal();
  /// 是否为平板
  bool _isTablet = false;
  /// 是否为手机
  bool _isPhone = false;
  /// 是否为平板
  bool get isTablet => _isTablet;
  /// 是否为手机
  bool get isPhone => _isPhone;

  // 初始化方法（在APP启动时调用）
  void init(BuildContext context) {
    // 是否为平板
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    // 是否为平板
    _isTablet = shortestSide >= 600;
    // 是否为手机
    _isPhone = !_isTablet;
  }

  // 动态更新方法（可选，用于响应屏幕旋转）
  void update(BuildContext context) {
    init(context);
  }
}