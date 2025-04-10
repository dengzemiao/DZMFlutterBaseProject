import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import './hud.dart';

class Nav {
  
  // 静态变量存储单例
  static final Nav _instance = Nav._internal();
  // 静态方法获取单例实例
  factory Nav() => _instance;
  // 私有构造函数，确保只能通过工厂方法获取实例
  Nav._internal();

  /// 获取当前 arguments
  dynamic get arguments => Get.arguments;

  /// 获取当前 parameters
  dynamic get parameters => Get.parameters;

  /// 跳转到指定路由页面，例如：NextPage()
  Future<T?>? to<T>(
    dynamic page, {
    bool? opaque,
    Transition? transition,
    Curve? curve,
    Duration? duration,
    int? id,
    String? routeName,
    bool fullscreenDialog = false,
    dynamic arguments,
    Bindings? binding,
    bool preventDuplicates = true,
    bool? popGesture,
    double Function(BuildContext context)? gestureWidth,
  }) async {
    try {
      return await Get.to(
        page,
        arguments: arguments,
        id: id,
        preventDuplicates: preventDuplicates,
        opaque: opaque,
        transition: transition,
        curve: curve,
        duration: duration,
        routeName: routeName,
        fullscreenDialog: fullscreenDialog,
        binding: binding,
        popGesture: popGesture,
        gestureWidth: gestureWidth
      );
    } catch (_) {
      Hud().showToast('页面不存在');
      return null;
    }
  }

  /// 跳转到指定路由，例如：/next
  Future<T?>? toNamed<T>(
    String page, {
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  }) async {
    try {
      return await Get.toNamed(
        page,
        arguments: arguments,
        id: id,
        preventDuplicates: preventDuplicates,
        parameters: parameters
      );
    } catch (_) {
      Hud().showToast('页面不存在');
      return null;
    }
  }

  /// 返回
  void back<T>({
    T? result,
    bool closeOverlays = false,
    bool canPop = true,
    int? id,
  }) {
    Get.back(
      result: result,
      closeOverlays: closeOverlays,
      canPop: canPop,
      id: id
    );
  }

  /// 替换当前路由页面，例如：NextPage()
  Future<T?>? off<T>(
    dynamic page, {
    bool opaque = false,
    Transition? transition,
    Curve? curve,
    bool? popGesture,
    int? id,
    String? routeName,
    dynamic arguments,
    Bindings? binding,
    bool fullscreenDialog = false,
    bool preventDuplicates = true,
    Duration? duration,
    double Function(BuildContext context)? gestureWidth,
  }) async {
    try {
      return await Get.off(
        page,
        arguments: arguments,
        id: id,
        preventDuplicates: preventDuplicates,
        opaque: opaque,
        transition: transition,
        curve: curve,
        duration: duration,
        routeName: routeName,
        fullscreenDialog: fullscreenDialog,
        binding: binding,
        popGesture: popGesture,
        gestureWidth: gestureWidth
      );
    } catch (_) {
      Hud().showToast('页面不存在');
      return null;
    }
  }

  /// 替换当前路由，例如：/next
  Future<T?>? offNamed<T>(
    String page, {
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  }) async {
    try {
      return await Get.offNamed(
        page,
        arguments: arguments,
        id: id,
        preventDuplicates: preventDuplicates,
        parameters: parameters
      );
    } catch (_) {
      Hud().showToast('页面不存在');
      return null;
    }
  }

  /// 清空路由栈，并跳转到指定路由页面，例如：NextPage()
  Future<T?>? offAll<T>(
    dynamic page, {
    RoutePredicate? predicate,
    bool opaque = false,
    bool? popGesture,
    int? id,
    String? routeName,
    dynamic arguments,
    Bindings? binding,
    bool fullscreenDialog = false,
    Transition? transition,
    Curve? curve,
    Duration? duration,
    double Function(BuildContext context)? gestureWidth,
  }) async {
    try {
      return await Get.offAll(
        page,
        arguments: arguments,
        id: id,
        opaque: opaque,
        transition: transition,
        curve: curve,
        duration: duration,
        routeName: routeName,
        fullscreenDialog: fullscreenDialog,
        binding: binding,
        popGesture: popGesture,
        gestureWidth: gestureWidth
      );
    } catch (_) {
      Hud().showToast('页面不存在');
      return null;
    }
  }

  // 清空路由栈，并跳转到指定路由，例如：/next
  Future<T?>? offAllNamed<T>(
    String newRouteName, {
    RoutePredicate? predicate,
    dynamic arguments,
    int? id,
    Map<String, String>? parameters,
  }) async {
    try {
      return await Get.offAllNamed(
        newRouteName,
        arguments: arguments,
        id: id,
        parameters: parameters
      );
    } catch (_) {
      Hud().showToast('页面不存在');
      return null;
    }
  }

  /// 判断是否可以打开指定 url
  Future<bool> canOpen(String? url) async {
    if (url != null && url.isNotEmpty) {
      return await canLaunchUrl(Uri.parse(url));
    } else {
      return false;
    }
  }

  /// 判断是否可以打开指定 url
  Future<bool> canOpenUrl(Uri url) async {
    return await canLaunchUrl(url);
  }
  
  /// 外部浏览器打开指定 url
  Future<bool> open(String? url) async {
    if (url != null && url.isNotEmpty) {
      return await openUrl(Uri.parse(url));
    } else {
      return false;
    }
  }

  /// 外部浏览器打开指定 url
  Future<bool> openUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      try {
        return await launchUrl(url);
      } catch (_) {
        // Hud().showToast('访问失败');
        return false;
      }
    } else {
      return false;
    }
  }

  /// 打开指定 APP，如果未安装，则打开浏览器访问下载地址 durl
  Future<bool> launchApp(String? url, {String? durl}) async {
    if (await launchAppBase(url, adurl: durl, idurl: durl)) {
      return true;
    } else {
      return false;
    }
  }

  /// 打开指定 APP，如果未安装，则打开浏览器访问下载地址：安卓下载地址（adurl），iOS下载地址（idurl）
  Future<bool> launchAppBase(String? url, {String? adurl, String? idurl}) async {
    if (await open(url)) {
      return true;
    } else {
      if (Platform.isAndroid) {
        await open(adurl);
      } else if (Platform.isIOS) {
        await open(idurl);
      }
      return false;
    }
  }

  /// 打开指定页面，自动判断是纯网页链接还是内部页面，网页链接会使用外部浏览器打开，内部浏览器可以配置路径
  Future<bool>? toPath(String? path) async {
    if (path != null && path.isNotEmpty) {
      if (path.startsWith('http')) {
        return open(path);
      } else {
        toNamed(path);
        return true;
      }
    } else {
      return false;
    }
  }
}