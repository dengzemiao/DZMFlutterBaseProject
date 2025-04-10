import 'package:flutter/material.dart';
// import 'package:base_project/utils/public.dart';

class PublicNavigatorObserver extends NavigatorObserver {

  // /// 管控路由
  // final controlRoutes = [appRoutes.webview];

  // @override
  // void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
  //   if (controlRoutes.contains(route.settings.name)) {
  //     // 黑色状态栏
  //     setSystemStatusBarStyle(
  //       statusBarColor: Colors.black,
  //       statusBarIconBrightness: Brightness.light
  //     );
  //   } else {
  //     // 透明状态栏
  //     setSystemStatusBarStyle(
  //       statusBarColor: Colors.transparent,
  //       statusBarIconBrightness: Brightness.dark
  //     );
  //   }
  //   // log('【 didPush 】${route.settings.name}【 Previous 】${previousRoute?.settings.name}');
  // }

  // @override
  // void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
  //   if (controlRoutes.contains(previousRoute?.settings.name)) {
  //     // 黑色状态栏
  //     setSystemStatusBarStyle(
  //       statusBarColor: Colors.black,
  //       statusBarIconBrightness: Brightness.light
  //     );
  //   } else {
  //     // 透明状态栏
  //     setSystemStatusBarStyle(
  //       statusBarColor: Colors.transparent,
  //       statusBarIconBrightness: Brightness.dark
  //     );
  //   }
  //   // log('【 didPop 】${route.settings.name}【 Previous 】${previousRoute?.settings.name}');
  // }
}