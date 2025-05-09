import 'package:flutter/material.dart';
import 'package:base_project/base/refresh/index.dart';
import 'package:base_project/utils/public.dart';
class HomeController extends BaseRefreshController {

  const HomeController({super.key, super.title});

  @override
  HomeControllerState createState() => HomeControllerState();
}

class HomeControllerState extends BaseRefreshControllerState with WidgetsBindingObserver {
  @override
  void initStateContext() {
    super.initStateContext();
    // 检查网络状态
    permission.listenNetworkOnce((isConnected) {
      logs.add({logs.keyTitle: '检查网络结果：$isConnected', logs.keySuccess: isConnected});
    });
  }
}