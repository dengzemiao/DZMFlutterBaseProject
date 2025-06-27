import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/tabbar/index.dart';
import '../pages/public/webview.dart';
// 日志页面，不用可以删除
import '../log/index.dart';

class AppRoutes {

  /// 单例对象
  static final AppRoutes _instance = AppRoutes._internal();
  /// 工厂构造函数返回单例对象
  factory AppRoutes() => _instance;
  /// 私有构造函数
  AppRoutes._internal();

  /// ================================ 公共 ================================

  /// 日志页面
  String get logvc => '/log';
  Widget get logPage => const LogController();

  /// 入口页
  String get initialRoute => tabbar;
  /// 底部导航
  String get tabbar => '/pages/tabbar';
  Widget get tabbarPage => const TabbarController();
  /// 内部浏览器
  String get webview => '/pages/webview';
  Widget get webViewPage => const WebviewController();
  /// 未知
  String get notFound => '/pages/not_found';


  /// 路由列表
  List<GetPage> get getPages => [

    /// ================================ 公共 ================================
    
    GetPage(name: logvc, page: () => logPage),
    GetPage(name: tabbar, page: () => tabbarPage),
    GetPage(name: webview, page: () => webViewPage),
  ];
}
