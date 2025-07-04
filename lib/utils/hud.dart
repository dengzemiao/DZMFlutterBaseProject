import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Hud {

  // EasyLoadingMaskType:
  // none: 无遮罩，用户可以交互。
  // clear: 透明遮罩，禁止用户交互。
  // black: 黑色遮罩，禁止用户交互。
  // custom: 自定义遮罩，允许设置遮罩颜色，禁止用户交互。

  // 静态变量存储单例
  static final Hud _instance = Hud._internal();
  // 静态方法获取单例实例
  factory Hud() => _instance;

  /// 允许展示 loading
  bool isAllowShowLoading = true;

  // 私有构造函数，确保只能通过工厂方法获取实例
  Hud._internal() {
    // 自定义加载样式
    EasyLoading().radius = 16;
    EasyLoading().loadingStyle = EasyLoadingStyle.custom;
    EasyLoading().textColor = Colors.white;
    EasyLoading().maskColor = Colors.black.withOpacity(0);
    EasyLoading().indicatorColor = Colors.white.withOpacity(1.0);
    EasyLoading().progressColor = Colors.white.withOpacity(1.0);
    EasyLoading().backgroundColor = Colors.black.withOpacity(0.7);
    EasyLoading().boxShadow = [];
  }

  /// 初始化 loading
  TransitionBuilder init({
    TransitionBuilder? builder,
  }) {
    return EasyLoading.init(
      builder: builder
    );
  }

  /// 显示 loading
  Future<void> show({
    String? status,
    Widget? indicator,
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap,
    bool dismissTouch = true,
  }) {
    // 为了调试使用，是否允许展示 loading
    if (!isAllowShowLoading) {
      return Future.value(null);
    }
    // 展示 loading
    return EasyLoading.show(
      status: status,
      indicator: indicator,
      maskType: maskType ?? (dismissTouch ? EasyLoadingMaskType.clear : EasyLoadingMaskType.none),
      dismissOnTap: dismissOnTap,
    );
  }

  /// 显示文案
  Future<void> showToast(
    String status, {
    Duration? duration,
    EasyLoadingToastPosition? toastPosition,
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap,
    bool dismissTouch = false,
  }) {
    return EasyLoading.showToast(
      status,
      duration: duration,
      toastPosition: toastPosition,
      maskType: maskType ?? (dismissTouch ? EasyLoadingMaskType.clear : EasyLoadingMaskType.none),
      dismissOnTap: dismissOnTap,
    );
  }

  /// 显示成功消息
  Future<void> showSuccess(
    String status, {
    Duration? duration,
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap,
    bool dismissTouch = false,
  }) {
    return EasyLoading.showSuccess(
      status,
      duration: duration,
      maskType: maskType ?? (dismissTouch ? EasyLoadingMaskType.clear : EasyLoadingMaskType.none),
      dismissOnTap: dismissOnTap,
    );
  }

  /// 显示失败消息
  Future<void> showError(
    String status, {
    Duration? duration,
    EasyLoadingMaskType? maskType,
    bool? dismissOnTap,
    bool dismissTouch = false,
  }) {
    return EasyLoading.showError(
      status,
      duration: duration,
      maskType: maskType ?? (dismissTouch ? EasyLoadingMaskType.clear : EasyLoadingMaskType.none),
      dismissOnTap: dismissOnTap,
    );
  }

  /// 移除 hud
  Future<void> dismiss({
    bool animation = true,
  }) {
    return EasyLoading.dismiss(animation: animation);
  }
}
